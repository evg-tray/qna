RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  describe 'POST #create' do
    sign_in_user
    let!(:create_post_params) { {answer: attributes_for(:answer), question_id: question, format: :js} }
    let!(:create_post_invalid_params) { {answer: attributes_for(:answer, :invalid_body), question_id: question, format: :js} }
    let!(:create_post) do
      Proc.new do |params = create_post_params|
        post :create, params: params
      end
    end

    context 'valid attributes' do
      it 'save new answer in db' do
        expect { create_post.call }.to change(Answer, :count).by(1)
      end

      it 'render create template' do
        create_post.call
        expect(response).to render_template :create
      end
    end

    context 'invalid attributes' do
      it 'dont save new answer' do
        expect { create_post.call(create_post_invalid_params) }.to_not change(Answer, :count)
      end

      it 'render create template' do
        create_post.call(create_post_invalid_params)
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: {id: answer, answer: attributes_for(:answer), question_id: question, format: :js}
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the @question' do
      patch :update, params: {id: answer, answer: attributes_for(:answer), question_id: question, format: :js}
      expect(assigns(:question)).to eq question
    end

    it 'render update template' do
      patch :update, params: {id: answer, answer: attributes_for(:answer), question_id: question, format: :js}
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'deletes question' do
      expect { delete :destroy, params: { id: answer, question_id: question, format: :js } }.to change(Answer, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params: { id: answer, question_id: question, format: :js }
      expect(response).to render_template :destroy
    end
  end

  describe 'POST #set_best_answer' do
    sign_in_user
    let!(:question2) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: question2) }

    it 'set an answer as a best' do
      post :set_best_answer, params: { question_id: question2.id, answer_id: answer.id, format: :js }
      question2.reload
      expect(question2.best_answer).to eq answer
    end

    it 'render set_best_answer template' do
      post :set_best_answer, params: { question_id: question2.id, answer_id: answer.id, format: :js }
      expect(response).to render_template :set_best_answer
    end
  end
end
