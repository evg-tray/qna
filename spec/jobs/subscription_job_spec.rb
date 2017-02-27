RSpec.describe SubscriptionJob, type: :job do
  let!(:user_author) { create(:user) }
  let!(:question) { create(:question, user: user_author) }
  let!(:subsriber1) { create(:user) }
  let!(:subsriber2) { create(:user) }
  let!(:subscription1) { create(:subscription, question: question, user: subsriber1) }
  let!(:subscription2) { create(:subscription, question: question, user: subsriber2) }
  let!(:users_not_subsribers) { create_list(:user, 2) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends email with a new answer to subsribers' do
    [user_author, subsriber1, subsriber2].each do |user|
      expect(SubscriptionMailer).to receive(:notify).with(user, answer).and_call_original
    end

    users_not_subsribers.each do |user|
      expect(SubscriptionMailer).not_to receive(:notify).with(user, answer).and_call_original
    end
    SubscriptionJob.perform_now(answer)
  end
end
