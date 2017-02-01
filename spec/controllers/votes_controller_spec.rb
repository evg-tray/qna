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
        it 'save vote in db' do
          expect { create_vote.call }.to change(question.votes, :count).by(1)
        end

        it 'render success json with params' do
          create_vote.call
          expect(response).to have_http_status :success

          json = JSON.parse(response.body)
          question.reload

          expect(json['rating']).to eq question.rating
          expect(json['name']).to eq question.class.name.underscore
          expect(json['id']).to eq question.id
          expect(json['vote_id']).to eq assigns(:vote).id
          expect(json['action']).to eq 'create'
        end
      end

      context 'answer vote' do
        it 'save vote in db' do
          expect { create_vote.call(answer_params) }.to change(answer.votes, :count).by(1)
        end

        it 'render success json with params' do
          create_vote.call(answer_params)
          expect(response).to have_http_status :success

          json = JSON.parse(response.body)
          answer.reload

          expect(json['rating']).to eq answer.rating
          expect(json['name']).to eq answer.class.name.underscore
          expect(json['id']).to eq answer.id
          expect(json['vote_id']).to eq assigns(:vote).id
          expect(json['action']).to eq 'create'
        end
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
      before { create_vote.call }
      it 'delete vote' do
        expect { delete :destroy, params: { id: assigns(:vote), format: :json } }.to change(question.votes, :count).by(-1)
      end

      it 'render success json with params' do
        delete :destroy, params: { id: assigns(:vote), format: :json }
        expect(response).to have_http_status :success

        json = JSON.parse(response.body)
        question.reload

        expect(json['rating']).to eq question.rating
        expect(json['name']).to eq question.class.name.underscore
        expect(json['id']).to eq question.id
        expect(json['vote_id']).to eq assigns(:vote).id
        expect(json['action']).to eq 'delete'
      end
    end

    context 'answer vote' do
      before { create_vote.call(answer_params) }
      it 'delete vote' do
        expect { delete :destroy, params: { id: assigns(:vote), format: :json } }.to change(answer.votes, :count).by(-1)
      end

      it 'render success json with params' do
        delete :destroy, params: { id: assigns(:vote), format: :json }
        expect(response).to have_http_status :success

        json = JSON.parse(response.body)
        answer.reload

        expect(json['rating']).to eq answer.rating
        expect(json['name']).to eq answer.class.name.underscore
        expect(json['id']).to eq answer.id
        expect(json['vote_id']).to eq assigns(:vote).id
        expect(json['action']).to eq 'delete'
      end
    end
  end
end