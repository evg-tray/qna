shared_examples_for 'API Attachable' do
  context 'attachments' do
    it 'included in question' do
      expect(response.body).to have_json_size(2).at_path("#{path}/attachments")
    end

    it 'contains id, name, url' do
      expect(response.body).to be_json_eql(attachment.id.to_json).at_path("#{path}/attachments/1/id")
      expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("#{path}/attachments/1/name")
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{path}/attachments/1/url")
    end
  end
end