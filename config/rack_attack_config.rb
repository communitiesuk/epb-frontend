# frozen_string_literal: true

environment = ENV["STAGE"]

if %w[development test].include? environment
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.enabled = false
else
  redis_url = Helper::RedisConfigurationReader.read_configuration_url("mhclg-epb-redis-ratelimit-#{environment}")
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)
end

# Monkey patch to have access to the first client IP in X_FORWARDED_FOR header
class Rack::Attack::Request < ::Rack::Request
  def source_ip
    if (forwarded_for = self.forwarded_for) && !forwarded_for.empty?
      return forwarded_for.first
    end

    ip
  end
end

# Whitelist IP addresses that ignore throttling limit; format of the env var is
# "[{"reason":"pen testers", "ip_address": "198.51.100.111"},{...}]"
white_listed_ips = JSON.parse(
  ENV["WHITELISTED_IP_ADDRESSES"] || "[]",
).map { |item|
  item["ip_address"]
}.flatten.uniq

Rack::Attack.safelist do |req|
  white_listed_ips.include? req.source_ip
end

# Excessive requests going to the certificate page or search page will ban an IP
Rack::Attack.blocklist("Certificate scrapers") do |req|
  Rack::Attack::Allow2Ban.filter(req.source_ip, maxretry: 100, findtime: 1.minute, bantime: 1.hour) do
    req.get? && (
      req.path.include?("/find-a-certificate/search-by-postcode") ||
      req.path.include?("/find-a-non-domestic-certificate/search-by-postcode") ||
      req.path.include?("/energy-certificate/")
    )
  end
end

# Throttle requests to any endpoint if we receive more than X requests per min
Rack::Attack.throttle("Requests Rate Limit", limit: 100, period: 1.minutes) do |request|
  !Helper::Toggles.enabled?("frontend-disable-request-throttling") ? request.source_ip : nil
end

# Block permanently banned IP addresses; the format of the env var is
# "[{"reason":"did a bad thing", "ip_address": "198.51.100.100"},{...}]"
banned_ips = JSON.parse(ENV["PERMANENTLY_BANNED_IP_ADDRESSES"] || "[]").map { |entry| entry["ip_address"] }.flatten.compact
Rack::Attack.blocklist("permanently blocked") do |req|
  banned_ips.include? req.source_ip
end
