RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    before { get :new, params: {question_id: question} }

    it 'Assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'valid attributes' do
      it 'save new answer in db' do
        expect { post :create, params: {answer: attributes_for(:answer),
                                        question_id: question} }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view with question route' do
        post :create, params: {answer: attributes_for(:answer), question_id: question}
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid attributes' do
      it 'dont save new answer' do
        expect { post :create, params: {answer: attributes_for(:answer, :invalid_body),
                                        question_id: question} }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: {answer: attributes_for(:answer, :invalid_body), question_id: question}
        expect(response).to render_template :new
      end
    end
  end
end
