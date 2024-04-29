module UseCase
  class FetchHeatPumpCountsByFloorArea < UseCase::Base
    def execute
      @gateway.count_by_floor_area
    end
  end
end
