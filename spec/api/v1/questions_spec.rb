describe 'Questions API' do
  let(:access_token) { create(:access_token).token }

  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { question = questions.first }

      before { get '/api/v1/questions', params: {format: :json, access_token: access_token} }

      it_behaves_like 'API Successable'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: {format: :json}.merge(options)
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:comment) { comments.first }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let(:attachment) { attachments.first }
    let(:path) { 'question' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token} }

      it_behaves_like 'API Successable'

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: {format: :json}.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:valid_params) { {question: attributes_for(:question), format: :json, access_token: access_token} }
      let(:invalid_params) { {question: attributes_for(:question, :invalid), format: :json, access_token: access_token} }
      let!(:create_question) do
        Proc.new do |params = valid_params|
          post '/api/v1/questions/', params: params
        end
      end

      context 'with valid attributes' do
        before { create_question.call }
        it_behaves_like 'API Successable'

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

    def do_request(options = {})
      post '/api/v1/questions/', params: {format: :json}.merge(options)
    end
  end
end