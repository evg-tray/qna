RSpec.describe Omnitoken, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:authorization) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:token) }
end
