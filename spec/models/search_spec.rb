RSpec.describe Search do
  it '.results' do
    expect(Search).to receive(:results).with('some text', ['question'], 1)
    Search.results('some text', ['question'], 1)
  end
end