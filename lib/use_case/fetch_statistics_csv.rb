# frozen_string_literal: true

module UseCase
  class FetchStatisticsCsv < UseCase::FetchStatisticsBase
    def execute(country = "all")
      register_data = @statistics_gateway.fetch[:data]
      warehouse_data = @co2_gateway.fetch[:data]
      @domain = Domain::StatisticsResults.new(register_data: register_data[:assessments], warehouse_data:)
      @domain.set_results unless warehouse_data.empty?
      @domain.to_csv_hash(country:)
    end
  end
end
