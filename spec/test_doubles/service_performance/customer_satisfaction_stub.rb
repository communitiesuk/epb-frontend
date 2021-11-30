module ServicePerformance
  class CustomerSatisfactionStub
    def self.body
      [
        {
          "month" => "2021-10",
          "verySatisfied" => 20,
          "satisfied" => 14,
          "neither" => 10,
          "dissatisfied" => 21,
          "veryDissatisfied" => 32,
        },
        {
          "month" => "2021-09",
          "verySatisfied" => 21,
          "satisfied" => 13,
          "neither" => 7,
          "dissatisfied" => 20,
          "veryDissatisfied" => 44,
        },
        {
          "month" => "2021-08",
          "verySatisfied" => 15,
          "satisfied" => 17,
          "neither" => 11,
          "dissatisfied" => 20,
          "veryDissatisfied" => 35,
        },
      ]
    end
  end
end
