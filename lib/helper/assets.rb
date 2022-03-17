module Helper
  module Assets
    def self.path(default_path)
      unless ENV["ASSETS_VERSION"]
        return default_path
      end

      "/static/#{ENV['ASSETS_VERSION']}#{default_path}"
    end

    def self.inline_svg(path)
      file_path = File.expand_path(File.join(__dir__, "/../../public", path(path)))
      if File.exist?(file_path)
        File.read(file_path)
      end
    end

    def self.data_uri_svg(path)
      svg_content = inline_svg path
      unless svg_content.nil?
        "data:image/svg+xml;utf8,#{svg_content.gsub('"', "'").gsub('#', '%23')}"
      end
    end

    def self.setup_cache_control(context)
      if ENV["ASSETS_VERSION"]
        context.set :static_cache_control, [:public, { max_age: 604_800 }] # cache for one week
      end
    end
  end
end
