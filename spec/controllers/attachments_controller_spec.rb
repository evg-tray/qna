RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author delete his attachment' do
      let!(:question) { create(:question, user: @user) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:answer) { create(:answer, user: @user) }
      let!(:attachment2) { create(:attachment, attachable: answer) }

      context 'question' do
        it 'delete attachment of question' do
          expect { delete :destroy, params: {id: attachment, format: :js} }.to change(question.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: {id: attachment, format: :js}
          expect(response).to render_template :destroy
        end
      end

      context 'answer' do
        it 'delete attachment of answer' do
          expect { delete :destroy, params: {id: attachment2, format: :js} }.to change(answer.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: {id: attachment2, format: :js}
          expect(response).to render_template :destroy
        end
      end
    end

    context 'User tries delete attachment of another author' do
      let(:user2) { create(:user) }
      let!(:question) { create(:question, user: user2) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:answer) { create(:answer, user: user2) }
      let!(:attachment2) { create(:attachment, attachable: answer) }

      it 'try to delete attachment of question' do
        expect { delete :destroy, params: {id: attachment, format: :js} }.to_not change(question.attachments, :count)
      end

      it 'try to delete attachment of answer' do
        expect { delete :destroy, params: {id: attachment2, format: :js} }.to_not change(answer.attachments, :count)
      end
    end
  end
end