RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:title).is_at_most(200) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should belong_to(:best_answer).class_name('Answer') }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for(:attachments) }

  describe 'set best answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'without best answer' do
      it 'set the best answer of this question' do
        question.set_best_answer(answer)
        expect(question.best_answer).to eq answer
      end
    end

    context 'with best answer' do
      let!(:best_answer) { create(:answer, question: question) }
      before { question.set_best_answer(best_answer) }
      it 'set the best answer of this question' do
        question.set_best_answer(answer)
        expect(question.best_answer).to eq answer
      end
    end

    it 'set the best answer of other question to this question' do
      answer2 = create(:answer)
      expect { question.set_best_answer(answer2) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
