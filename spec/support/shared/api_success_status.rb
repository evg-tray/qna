shared_examples_for 'API Successable' do
  it 'returns 200 status code' do
    expect(response).to be_success
  end
end