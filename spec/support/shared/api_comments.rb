shared_examples_for 'API Commentable' do
  context 'comments' do
    it 'included in object' do
      expect(response.body).to have_json_size(2).at_path("#{path}/comments")
    end

    %w(id body created_at updated_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{path}/comments/1/#{attr}")
      end
    end
  end
end