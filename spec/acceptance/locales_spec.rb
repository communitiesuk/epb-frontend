# frozen_string_literal: true

describe 'Acceptance::Locales' do
  include RSpecFrontendServiceMixin

  describe '.get /find-an-assessor with different language parameters' do
    let(:response_welsh) { get '/find-an-assessor?lang=cy' }
    let(:response_english) { get '/find-an-assessor?lang=en' }

    it 'shows Welsh: when lang=cy' do
      expect(response_welsh.body).to include('Welsh:')
    end

    it 'does not show Welsh: when lang=en' do
      expect(response_english.body).not_to include('Welsh:')
    end
  end
end
