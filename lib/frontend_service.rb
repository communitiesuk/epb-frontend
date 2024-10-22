# frozen_string_literal: true

class FrontendService  < Controller::BaseController

  get "/healthcheck" do
    status 200
  end

  get "/accessibility-statement" do
    status 200
    @page_title =
      "#{t('accessibility_statement.top_heading')} – #{t('layout.body.govuk')}"
    erb :accessibility_statement
  end

  get "/cookies" do
    @page_title = "#{t('cookies.title')} – #{t('layout.body.govuk')}"
    status 200
    erb :cookies, locals: { is_success: params[:success] == "true" }
  end

  post "/cookies" do
    cookie_value = params[:cookies_setting] == "false" ? "false" : "true"
    response.set_cookie("cookie_consent", { value: cookie_value, path: "/", same_site: :strict })

    redirect localised_url("/cookies?success=true")
  end

  get "/heat-pump-counts" do
    if Helper::Toggles.enabled?("frontend-show-heat-pump-counts")
      # moved from container to ensure prod task deploys without the EPB_DATA_WAREHOUSE_API_URL being in the ENV
      api_url =  ENV["EPB_DATA_WAREHOUSE_API_URL"] || ENV["EPB_API_URL"]
      api_client =
        Auth::HttpClient.new ENV["EPB_AUTH_CLIENT_ID"],
                             ENV["EPB_AUTH_CLIENT_SECRET"],
                             ENV["EPB_AUTH_SERVER"],
                             api_url,
                             OAuth2::Client,
                             faraday_connection_opts: { request: { timeout: 60 } }

      use_case = UseCase::FetchHeatPumpCountsByFloorArea.new(Gateway::HeatPumpGateway.new(api_client))

      use_case.execute
    else
      status 404
    end
  end

  get "/service-performance" do
    @page_title = "#{t('service_performance.heading')} – #{t('layout.body.govuk')}"
    status 200
    erb_template = :service_performance
    use_case = @container.get_object(:fetch_statistics_use_case)
    data = use_case.execute
    data[:show_avg_co2] = Helper::Toggles.enabled?("frontend-show-average-co2-emission")
    show(erb_template, data)
  rescue StandardError => e
    return server_error(e)
  end

  get "/service-performance/download-csv" do
    use_case = @container.get_object(:fetch_statistics_csv_use_case)
    data = params["country"] ? use_case.execute(params["country"]) : use_case.execute

    content_type "application/csv"
    attachment params["country"] ? "service-performance-#{params['country']}.csv" : "service-performance-all-regions.csv"

    to_csv(data)
  end

  use Controller::FindEnergyCertificateController
  use Controller::GettingNewEnergyCertificateController
end
