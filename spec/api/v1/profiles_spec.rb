describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:parsed_response) { JSON.parse(response.body) }

      before { get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token} }

      it_behaves_like 'API Successable'

      it'contains attributes' do
        expect(parsed_response['id']).to eq me.id
        expect(parsed_response['email']).to eq me.email
        expect(parsed_response['created_at'].to_json).to eq me.created_at.to_json
        expect(parsed_response['updated_at'].to_json).to eq me.updated_at.to_json
        expect(parsed_response['admin']).to eq me.admin
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: {format: :json}.merge(options)
    end
  end

  describe 'GET /profiles' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_users) { create_list(:user, 2) }
      let(:parsed_response) { JSON.parse(response.body) }

      before { get '/api/v1/profiles', params: {format: :json, access_token: access_token.token} }

      it_behaves_like 'API Successable'

      it 'contains users' do
        expect(response.body).to be_json_eql(other_users.to_json)
      end

      it 'does no contain me' do
        parsed_response.each do |item|
          expect(item[:id]).to_not eq me.id
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: {format: :json}.merge(options)
    end
  end
end