RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:title).is_at_most(200) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  describe 'best answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it 'set the best answer of this question' do
      question.set_best_answer(answer)
      expect(question.best_answer).to eq answer.id
    end

    it 'set the best answer of other question' do
      answer2 = create(:answer)
      expect { question.set_best_answer(answer2) }.to raise_error
    end
  end
end
