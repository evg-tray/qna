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
end
