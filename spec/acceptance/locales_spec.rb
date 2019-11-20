require 'app'

  describe FrontendService do
    describe 'Given the server displaying html' do
      context 'When we compare the text on index' do
        let(:response) { get '/' }

        it 'Then it does display the page title' do
          expect(response.body).to include('Find an energy assessor for a residential property')
        end
      end

      context 'When we compare the text on schemes' do
        let(:response) { get '/schemes' }

        it 'Then it does display the page title' do
          expect(response.body).to include('Contact an energy assessor accreditation scheme')
        end
      end

      context 'When we compare the text in head' do
        let(:response) { get '/' }

        it 'Then it does display the title with tags around it' do
          expect(response.body).to include('<title>Energy performance of buildings register</title>')
        end
      end

      context 'When we switch languages' do
        let(:response_welsh) { get '/?lang=cy' }
        let(:response_english) { get '/?lang=en' }

        it 'Then it does show Welsh: on cy' do
          expect(response_welsh.body).to include('Welsh:')
        end

        it 'Then it does not show Welsh: on en' do
          expect(response_english.body).not_to include('Welsh:')
        end
      end
    end
  end