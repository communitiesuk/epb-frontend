describe "config.ru" do
  let(:rack_builder) do
    instance_double(Rack::Builder)
  end

  before do
    allow(Rack::Builder).to receive(:new).and_return(rack_builder)
    allow(rack_builder).to receive(:use)
    allow(rack_builder).to receive(:to_app)
    allow(rack_builder).to receive(:run)
  end

  it "starts the frontend service" do
    Rack::Builder.parse_file("#{__dir__}/../../config.ru")
    expect(rack_builder).to have_received(:run).at_least(1).times
  end
end
