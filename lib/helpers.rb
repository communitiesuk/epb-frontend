module Sinatra
  module FrontendService
    module Helpers

      POSTCODE_REGEX = Regexp.new('^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$', Regexp::IGNORECASE)

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

      def localised_url(url)
        if I18n.locale != I18n.available_locales[0]
          url = url_for(url, lang: I18n.locale.to_s)
        end

        url
      end

      def assessors
        [
          {
            "fullName": 'William Turner',
            "distance": 0.2,
            "accreditationScheme": 'CIBSIE',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Gregg Sellen',
            "distance": 0.6,
            "accreditationScheme": 'Sterling',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Juliet Montague',
            "distance": 0.6,
            "accreditationScheme": 'ECMK',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Wallace Gromit',
            "distance": 0.6,
            "accreditationScheme": 'ECMK',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Martha Stewart',
            "distance": 0.9,
            "accreditationScheme": 'CIBSIE',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Donald Duck',
            "distance": 1,
            "accreditationScheme": 'ECMK',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'John Doe',
            "distance": 2,
            "accreditationScheme": 'CIBSIE',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Harald Anderson',
            "distance": 2,
            "accreditationScheme": 'Elmhurst Energy',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Daniel Adams',
            "distance": 4,
            "accreditationScheme": 'Elmhurst Energy',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 2368',
            "email": 'epbassessor@epb.com'
          },
          {
            "fullName": 'Craig Bass',
            "distance": 5,
            "accreditationScheme": 'ECMK',
            "schemeAssessorId": '1234',
            "telephoneNumber": '0792 102 1388',
            "email": 'epbassessor@epb.com'
          }
        ]
      end
    end
  end
end
