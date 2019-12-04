module Sinatra
  module FrontendService
    module Helpers
      def setup_locales
        I18n.load_path = Dir[File.join(settings.root, '/../locales', '*.yml')]
        I18n.enforce_available_locales = true
        I18n.available_locales = %w[en cy]
      end

      def set_locale
        I18n.locale = params['lang'] if I18n.locale_available?(params['lang'])
      end

      def t(*args)
        I18n.t(*args)
      end

      def path(url)
        url += (url.include?('?') ? '&' : '?') + 'lang=' + I18n.locale.to_s if I18n.locale != I18n.available_locales[0]

        url
      end
    end
  end
end
