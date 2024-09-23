# frozen_string_literal: true

module UseCase
  class FetchStatistics < UseCase::FetchStatisticsBase
    def execute
      register_data = @statistics_gateway.fetch[:data]
      warehouse_data = @co2_gateway.fetch[:data]
      @domain = Domain::StatisticsResults.new(register_data: register_data[:assessments], warehouse_data:)
      @domain.set_results unless warehouse_data.empty?
      @domain.get_results
    end
  end
end
