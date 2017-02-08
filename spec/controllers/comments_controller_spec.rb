RSpec.describe CommentsController, type: :controller do

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let!(:question_params) { {comment: attributes_for(:comment).merge(commentable_id: question.id,
                                                                     commentable_type: question.class.name), format: :json} }
  let!(:answer_params) { {comment: attributes_for(:comment).merge(commentable_id: answer.id,
                                                                  commentable_type: answer.class.name), format: :json} }
  let!(:invalid_params) { {comment: attributes_for(:comment).merge(commentable_id: question.id,
                                                                   commentable_type: 'InvalidType'), format: :json} }
  let!(:create_comment) do |params|
    Proc.new do |params = question_params|
      post :create, params: params
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'valid attributes' do
      context 'question comment' do
        it 'save comment in db' do
          expect { create_comment.call }.to change(question.comments, :count).by(1)
        end

        it 'render success json with params' do
          create_comment.call
          expect(response).to have_http_status :success

          json = JSON.parse(response.body)
          question.reload

          expect(json['body']).to eq assigns(:comment).body
          expect(json['css_path']).to eq '.question'
        end
      end

      context 'answer comment' do
        it 'save comment in db' do
          expect { create_comment.call(answer_params) }.to change(answer.comments, :count).by(1)
        end

        it 'render success json with params' do
          create_comment.call(answer_params)
          expect(response).to have_http_status :success

          json = JSON.parse(response.body)
          answer.reload

          expect(json['body']).to eq assigns(:comment).body
          expect(json['css_path']).to eq ".answer-#{answer.id}"
        end
      end
    end

    context 'invalid attributes' do
      it 'dont save comment' do
        expect { create_comment.call(invalid_params) }.to_not change(Comment, :count)
      end

      it 'render error json' do
        create_comment.call(invalid_params)
        expect(response).to have_http_status :unprocessable_entity

        json = JSON.parse(response.body)

        expect(json['error_text']).to eq 'Error to comment.'
      end
    end
  end
end