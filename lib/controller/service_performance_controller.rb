# frozen_string_literal: true

module Controller
  class ServicePerformanceController < BaseController
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
  end
end
