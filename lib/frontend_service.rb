# frozen_string_literal: true

class FrontendService < Controller::BaseController
  use Controller::HomeController
  use Controller::CookieController
  use Controller::EnergyCertificateController
  use Controller::FindEnergyCertificateController
  use Controller::GettingNewEnergyCertificateController
  use Controller::ServicePerformanceController
end
