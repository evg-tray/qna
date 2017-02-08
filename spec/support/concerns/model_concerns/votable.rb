shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:obj) { create(model.to_s.underscore.to_sym) }
  let!(:votes) { create_list(:vote, 2, votable: obj) }

  it { should have_many(:votes) }
  it { should accept_nested_attributes_for(:votes) }

  it 'has a rating' do
    expect(obj.rating).to eq votes[0].rating + votes[1].rating
  end
end