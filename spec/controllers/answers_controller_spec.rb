RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST #create' do
    sign_in_user
    let!(:create_post_params) { {answer: attributes_for(:answer), question_id: question} }
    let!(:create_post_invalid_params) { {answer: attributes_for(:answer, :invalid_body), question_id: question} }
    let!(:create_post) do
      Proc.new do |params = create_post_params|
        post :create, params: params
      end
    end

    context 'valid attributes' do
      it 'save new answer in db' do
        expect { create_post.call }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view with question route' do
        create_post.call
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid attributes' do
      it 'dont save new answer' do
        expect { create_post.call(create_post_invalid_params) }.to_not change(Answer, :count)
      end

      it 'redirect to show view with question route' do
        create_post.call(create_post_invalid_params)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
