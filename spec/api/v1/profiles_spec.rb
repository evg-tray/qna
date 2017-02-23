describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: {format: :json, access_token: '1111'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:parsed_response) { JSON.parse(response.body) }

      before { get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

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
  end

  describe 'GET /profiles' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: {format: :json, access_token: '1111'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_users) { create_list(:user, 2) }
      let(:parsed_response) { JSON.parse(response.body) }

      before { get '/api/v1/profiles', params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains users' do
        expect(response.body).to be_json_eql(other_users.to_json)
      end

      it 'does no contain me' do
        parsed_response.each do |item|
          expect(item[:id]).to_not eq me.id
        end
      end
    end
  end
end