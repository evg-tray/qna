RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(20) }
  it { should belong_to(:question) }
  it { should validate_presence_of(:question_id) }
  it { should belong_to(:user) }
  it { should have_one(:best_for_question).class_name('Question').dependent(:nullify).with_foreign_key(:best_answer_id) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for(:attachments) }
end
