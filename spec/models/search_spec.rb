RSpec.describe Search do
  context '.results' do
    let(:query) { 'some query' }
    let(:params) { {classes: [Question], page: '1', per_page: 5} }

    it 'calls escape request' do
      expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
      Search.results(query, ['question'], '1')
    end

    it 'calls ThinkingSphinx.search' do
      expect(ThinkingSphinx).to receive(:search).with(query, params).and_call_original
      Search.results(query, ['question'], '1')
    end
  end
end
