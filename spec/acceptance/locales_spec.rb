require 'app'

describe FrontendService, 'internationalisation' do
  describe '.get / with different language parameters' do
    let(:response_welsh) { get '/?lang=cy' }
    let(:response_english) { get '/?lang=en' }

    it 'shows Welsh: when lang=cy' do
      expect(response_welsh.body).to include('Welsh:')
    end

    it 'does not show Welsh: when lang=en' do
      expect(response_english.body).not_to include('Welsh:')
    end
  end
end
