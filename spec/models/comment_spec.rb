RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should validate_presence_of(:commentable_id) }
  it { should validate_presence_of(:commentable_type) }
  it { should validate_inclusion_of(:commentable_type).in_array(Comment.types) }
end
