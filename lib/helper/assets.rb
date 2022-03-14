module Helper
  module Assets
    def self.path(default_path)
      unless ENV["ASSETS_VERSION"]
        return default_path
      end

      "/static/#{ENV['ASSETS_VERSION']}#{default_path}"
    end

    def self.setup_cache_control(context)
      if ENV["ASSETS_VERSION"]
        context.set :static_cache_control, [:public, { max_age: 604_800 }] # cache for one week
      end
    end
  end
end
