RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable).touch(true) }
  it { should validate_presence_of(:votable_id) }
  it { should validate_presence_of(:votable_type) }
  it { should validate_presence_of(:rating) }
  it { should validate_inclusion_of(:votable_type).in_array(Vote.types) }
  it { should validate_inclusion_of(:rating).in_array([1, -1]) }
end
