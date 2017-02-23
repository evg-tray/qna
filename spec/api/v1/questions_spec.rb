describe 'Questions API' do
  let(:access_token) { create(:access_token).token }

  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: {format: :json, access_token: '1111'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { question = questions.first }

      before { get '/api/v1/questions', params: {format: :json, access_token: access_token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      it 'match schema' do
        expect(response).to match_response_schema('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:comment) { comments.first }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let(:attachment) { attachments.first }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: '1111'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question' do
          expect(response.body).to have_json_size(2).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/1/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question' do
          expect(response.body).to have_json_size(2).at_path("question/attachments")
        end

        it 'contains id, name, url' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("question/attachments/1/id")
          expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/1/name")
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/1/url")
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions/', params: {question: attributes_for(:question), format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions/', params: {question: attributes_for(:question), format: :json, access_token: '1111'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:valid_params) { {question: attributes_for(:question), format: :json, access_token: access_token} }
      let(:invalid_params) { {question: attributes_for(:question, :invalid), format: :json, access_token: access_token} }
      let!(:create_question) do
        Proc.new do |params = valid_params|
          post '/api/v1/questions/', params: params
        end
      end

      context 'with valid attributes' do
        it 'returns 200 status code' do
          create_question.call
          expect(response).to be_success
        end

        it 'save question in database' do
          expect { create_question.call }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          create_question.call(invalid_params)
          expect(response.status).to eq 422
        end

        it 'not save in database' do
          expect { create_question.call(invalid_params) }.not_to change(Question, :count)
        end
      end
    end
  end
end