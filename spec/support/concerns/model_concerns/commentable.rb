shared_examples_for 'commentable' do
  it { should have_many(:comments) }
  it { should accept_nested_attributes_for(:comments) }
end