module UseCase
  class FetchInterestingNumbers < UseCase::Base
    def execute(report_name = nil)
      report_name ? @gateway.fetch[:data].find { |r| r[:name] == report_name }[:data] : @gateway.fetch
    end
  end
end
