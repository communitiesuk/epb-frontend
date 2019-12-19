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

      def localised_url(url)
        if I18n.locale != I18n.available_locales[0]
          url = url_for(url, lang: I18n.locale.to_s)
        end

        url
      end

      def assessors
        [
          {
            "name": 'William Turner',
            "distance": 0.2,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'CIBSIE',
            "assessor_ID": '1234'
          },
          {
            "name": 'Gregg Sellen',
            "distance": 0.6,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'Sterling',
            "assessor_ID": '1234'
          },
          {
            "name": 'Juliet Montague',
            "distance": 0.6,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'ECMK',
            "assessor_ID": '1234'
          },
          {
            "name": 'Wallace Gromit',
            "distance": 0.6,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'ECMK',
            "assessor_ID": '1234'
          },
          {
            "name": 'Martha Stewart',
            "distance": 0.9,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'CIBSIE',
            "assessor_ID": '1234'
          },
          {
            "name": 'Donald Duck',
            "distance": 1,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'ECMK',
            "assessor_ID": '1234'
          },
          {
            "name": 'John Doe',
            "distance": 2,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'CIBSIE',
            "assessor_ID": '1234'
          },
          {
            "name": 'Harald Anderson',
            "distance": 2,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'Elmhurst Energy',
            "assessor_ID": '1234'
          },
          {
            "name": 'Daniel Adams',
            "distance": 4,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'Elmhurst Energy',
            "assessor_ID": '1234'
          },
          {
            "name": 'Craig Bass',
            "distance": 5,
            "phone": '0792 102 1368',
            "email_address": 'epbassessor@epb.com',
            "website": 'epbassessments.com',
            "accreditation_scheme": 'ECMK',
            "assessor_ID": '1234'
          }
        ]
      end
    end
  end
end
