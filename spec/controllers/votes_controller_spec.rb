RSpec.describe VotesController, type: :controller do

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let!(:question_params) { {votable_id: question.id, votable_type: question.class.name, up: true, format: :json} }
  let!(:answer_params) { {votable_id: answer.id, votable_type: answer.class.name, up: true, format: :json} }
  let!(:invalid_params) { {votable_id: question.id, votable_type: 'InvalidType', up: true, format: :json} }
  let!(:create_vote) do |params|
    Proc.new do |params = question_params|
      post :create, params: params
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'valid attributes' do
      context 'question vote' do
        let(:current_params) { question_params }
        let(:object) { question }
        it_behaves_like 'Create Vote'
      end

      context 'answer vote' do
        let(:current_params) { answer_params }
        let(:object) { answer }
        it_behaves_like 'Create Vote'
      end
    end

    context 'invalid attributes' do
      it 'dont save vote' do
        expect { create_vote.call(invalid_params) }.to_not change(Vote, :count)
      end

      it 'render error json' do
        create_vote.call(invalid_params)
        expect(response).to have_http_status :unprocessable_entity

        json = JSON.parse(response.body)

        expect(json['error_text']).to eq 'Error to vote.'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'question vote' do
      let(:current_params) { question_params }
      let(:object) { question }
      it_behaves_like 'Delete Vote'
    end

    context 'answer vote' do
      let(:current_params) { answer_params }
      let(:object) { answer }
      it_behaves_like 'Delete Vote'
    end
  end
end