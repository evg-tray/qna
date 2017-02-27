shared_examples_for 'Create Vote' do
  it 'save vote in db' do
    expect { create_vote.call(current_params) }.to change(object.votes, :count).by(1)
  end

  it 'render success json with params' do
    create_vote.call(current_params)
    expect(response).to have_http_status :success

    json = JSON.parse(response.body)
    object.reload

    expect(json['rating']).to eq object.rating
    expect(json['name']).to eq object.class.name.underscore
    expect(json['id']).to eq object.id
    expect(json['vote_id']).to eq assigns(:vote).id
    expect(json['action']).to eq 'create'
  end
end

shared_examples_for 'Delete Vote' do
  before { create_vote.call(current_params) }
  it 'delete vote' do
    expect { delete :destroy, params: { id: assigns(:vote), format: :json } }.to change(object.votes, :count).by(-1)
  end

  it 'render success json with params' do
    delete :destroy, params: { id: assigns(:vote), format: :json }
    expect(response).to have_http_status :success

    json = JSON.parse(response.body)
    object.reload

    expect(json['rating']).to eq object.rating
    expect(json['name']).to eq object.class.name.underscore
    expect(json['id']).to eq object.id
    expect(json['vote_id']).to eq assigns(:vote).id
    expect(json['action']).to eq 'delete'
  end
end