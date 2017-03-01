describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Vote }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true)}

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_other_user) { create(:question) }
    let(:answer) { create(:answer, user: user) }
    let(:answer_other_user) { create(:answer) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:attachment_other_user) { create(:attachment, attachable: question_other_user) }
    let(:vote) { create(:vote, votable: question_other_user, user: user) }
    let(:vote_other_user) { create(:vote, votable: question_other_user) }
    let(:best_answer) { create(:answer, question: question) }
    let(:best_answer_other_user) { create(:answer, question: question_other_user) }
    let(:subscription) { create(:subscription, user: user) }
    let(:subscription_other_user) { create(:subscription) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, question_other_user, user: user }

      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, question_other_user, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, answer_other_user, user: user }

      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, answer_other_user, user: user }

      it { should be_able_to :set_best_answer, best_answer, user: user }
      it { should_not be_able_to :set_best_answer, best_answer_other_user, user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, attachment, user: user }
      it { should_not be_able_to :destroy, attachment_other_user, user: user }
    end

    context 'Vote' do
      it { should be_able_to :create, Vote.new(votable: question_other_user) }
      it { should_not be_able_to :create, Vote.new(votable: question) }

      it { should be_able_to :create, Vote.new(votable: answer_other_user) }
      it { should_not be_able_to :create, Vote.new(votable: answer) }

      it { should be_able_to :destroy, vote, user: user }
      it { should_not be_able_to :destroy, vote_other_user, user: user }
    end

    context 'API' do
      it { should be_able_to :me, User }
    end

    context 'Subscription' do
      it { should be_able_to :create, Subscription }

      it { should be_able_to :destroy, subscription, user: user }
      it { should_not be_able_to :destroy, subscription_other_user, user: user }
    end
  end
end