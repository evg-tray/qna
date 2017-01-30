RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'Assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: {id: question} }

    it 'Assigns a requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'Assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user
    let!(:create_post_params) { {question: attributes_for(:question)} }
    let!(:create_post_invalid_params) { {question: attributes_for(:question, :invalid)} }
    let!(:create_post) do
      Proc.new do |params = create_post_params|
        post :create, params: params
      end
    end

    context 'valid attributes' do
      it 'save new question in db' do
        expect { create_post.call }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        create_post.call
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid attributes' do
      it 'dont save new question' do
        expect { create_post.call(create_post_invalid_params) }.to_not change(Question, :count)
      end

      it 'render new view' do
        create_post.call(create_post_invalid_params)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }

    context 'Author edit his answer' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(assigns(:question)).to eq question
      end

      it 'render update template' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(response).to render_template :update
      end
    end

    context 'User tries edit question of another author' do
      let!(:question2) { create(:question) }
      it 'dont change title and body of question after update' do
        title = Faker::Lorem.characters(30)
        body = Faker::Lorem.characters(50)
        patch :update, params: {id: question2, question: { title: title, body: body }, format: :js}
        question2.reload
        expect(question2.title).not_to eq title
        expect(question2.body).not_to eq body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }
    it 'delete question' do
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end
end
