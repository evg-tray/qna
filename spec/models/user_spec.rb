RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  describe 'methods' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:question_another_user) { create(:question) }
    let!(:answer) { create(:answer, user: user) }
    let!(:answer_another_user) { create(:answer) }
    let!(:vote_question) { create(:vote, user: user, votable: question) }
    let!(:vote_question_another_user) { create(:vote, votable: question) }
    let!(:vote_answer) { create(:vote, user: user, votable: answer) }
    let!(:vote_answer_another_user) { create(:vote, votable: answer) }

    context 'author of' do
      context 'question' do
        it 'return true if user is an author of question' do
          expect(user.author_of?(question)).to eq true
        end

        it 'return false if user is not an author of question' do
          expect(user.author_of?(question_another_user)).to eq false
        end
      end

      context 'answer' do
        it 'return true if user is an author of question' do
          expect(user.author_of?(answer)).to eq true
        end
        it 'return false if user is not an author of question' do
          expect(user.author_of?(answer_another_user)).to eq false
        end
      end
    end

    context 'voted of' do
      context 'question' do
        it 'return true if user voted to question' do
          expect(user.voted_of?(question)).to eq true
        end

        it 'return false if user not voted to question' do
          expect(user.voted_of?(question_another_user)).to eq false
        end
      end

      context 'answer' do
        it 'return true if user voted to answer' do
          expect(user.voted_of?(answer)).to eq true
        end

        it 'return false if user not voted to answer' do
          expect(user.voted_of?(answer_another_user)).to eq false
        end
      end
    end

    context 'find vote' do
      context 'question' do
        it 'return Vote if user voted to question' do
          expect(user.find_vote(question)).to eq vote_question
        end

        it 'return nil if user not voted to question' do
          expect(user.find_vote(question_another_user)).to eq nil
        end
      end

      context 'answer' do
        it 'return Vote if user voted to answer' do
          expect(user.find_vote(answer)).to eq vote_answer
        end

        it 'return nil if user not voted to answer' do
          expect(user.find_vote(answer_another_user)).to eq nil
        end
      end
    end
  end
end
