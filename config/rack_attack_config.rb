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


  white_listed_ips = JSON.parse(
    ENV["WHITELISTED_IP_ADDRESSES"] || "[]",
  ).map { |item|
    item["ip_addresses"]
  }.flatten.uniq

  white_listed_ips.each do |ip_address|
    Rack::Attack.safelist("white_listed") do |req|
      req.source_ip == ip_address
    end
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
Rack::Attack.throttle("Requests Rate Limit", limit: 100, period: 1.minutes, &:source_ip)

# Block permanently banned IP addresses; the format of the env var is
# "[{"reason":"did a bad thing", "ip_address": "198.51.100.100"},{...}]"
JSON.parse(ENV["PERMANENTLY_BANNED_IP_ADDRESSES"] || "[]").each do |banned_ip_obj|
  Rack::Attack.blocklist("permanently blocked") do |req|
    req.source_ip == banned_ip_obj["ip_address"]
  end
end
