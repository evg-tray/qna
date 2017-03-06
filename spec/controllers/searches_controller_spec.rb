RSpec.describe SearchesController, type: :controller do
  describe 'GET #search' do
    context 'without params' do
      before { get :show }
      it 'renders show template' do
        expect(response).to render_template :show
      end
    end

    context 'with params' do
      let!(:get_show) do
        Proc.new do
          get :show, params: {text: 'some text', scopes: ['question'], page: '1'}
        end
      end

      it 'renders show template' do
        get_show.call
        expect(response).to render_template :show
      end

      it 'call Search.results' do
        expect(Search).to receive(:results).with('some text', ['question'], '1')
        get_show.call
      end
    end
  end
end
