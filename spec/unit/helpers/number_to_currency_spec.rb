# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context 'given valid number' do
    it 'returns single digit formatted currency' do
      expect(HelpersStub.new.number_to_currency(0.50)).to eq('£0.50')
    end

    it 'returns four digit formatted currency' do
      expect(HelpersStub.new.number_to_currency(7334.00)).to eq('£7,334')
    end

    it 'returns five digit formatted currency' do
      expect(HelpersStub.new.number_to_currency(25000.90)).to eq('£25,000.90')
    end

    it 'returns seven digit formatted currency' do
      expect(HelpersStub.new.number_to_currency(1250600.99)).to eq(
        '£1,250,600.99'
      )
    end

    context 'given valid number in string format' do
      it 'returns formatted currency' do
        expect(HelpersStub.new.number_to_currency('123.90')).to eq('£123.90')
      end
    end
  end
end
