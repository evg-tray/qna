RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  describe 'POST #create' do
    sign_in_user
    let!(:create_params) { {question_id: question, format: :js} }
    let!(:create_subscription) do
      Proc.new do |params = create_params|
        post :create, params: params
      end
    end

    it 'save new subscription in db' do
      expect { create_subscription.call }.to change(Subscription, :count).by(1)
    end

    it 'render create template' do
      create_subscription.call
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:subscription) { create(:subscription, question: question) }
    let!(:destroy_params) { {id: subscription, question_id: question, format: :js} }
    let!(:destroy_subscription) do
      Proc.new do |params = destroy_params|
        delete :destroy, params: params
      end
    end
    it 'deletes subscription' do
      expect { destroy_subscription.call }.to change(Subscription, :count).by(-1)
    end

    it 'render destroy template' do
      destroy_subscription.call
      expect(response).to render_template :destroy
    end
  end
end