describe 'Answers API' do
  let(:access_token) { create(:access_token).token }

  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:answer) { answers.first }
    before { question.set_best_answer(answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: access_token} }

      it_behaves_like 'API Successable'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/1/#{attr}")
        end
      end

      it 'answer object contains is_best attr' do
        expect(response.body).to be_json_eql(false.to_json).at_path("answers/0/is_best")
        expect(response.body).to be_json_eql(true.to_json).at_path("answers/1/is_best")
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: {format: :json}.merge(options)
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let(:comment) { comments.first }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
    let(:attachment) { attachments.first }
    let(:path) { 'answer' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token} }

      it_behaves_like 'API Successable'

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it 'contains is_best attr' do
        expect(response.body).to be_json_eql(false.to_json).at_path("answer/is_best")
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: {format: :json}.merge(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:valid_params) { {answer: attributes_for(:answer), format: :json, access_token: access_token} }
      let(:invalid_params) { {answer: attributes_for(:answer, :invalid_body), format: :json, access_token: access_token} }
      let!(:create_answer) do
        Proc.new do |params = valid_params|
          post "/api/v1/questions/#{question.id}/answers", params: params
        end
      end

      context 'with valid attributes' do
        before { create_answer.call }
        it_behaves_like 'API Successable'

        it 'save answer in database' do
          expect { create_answer.call }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          create_answer.call(invalid_params)
          expect(response.status).to eq 422
        end

        it 'not save in database' do
          expect { create_answer.call(invalid_params) }.not_to change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: {question: attributes_for(:question), format: :json}.merge(options)
    end
  end
end