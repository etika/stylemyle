require 'rails_helper'

RSpec.describe 'Verticals' do
  let(:user) { create :user }
  let(:token) { token_for(user.username, 'password') }
  let!(:verticals_list) { create_list :vertical, 20 }
  let(:vertical) { verticals_list.first }

  it 'Shows all stored verticals' do
    api_request_get '/verticals', token: token
    all_verticals = JSON.parse(response.body)
    expect(first_page['verticals'].count).to eq(20)
  end

  it 'shows a single vertical' do
    api_request_get "/verticals/#{vertical.id}", token: token
    json_res = JSON.parse(response.body)

    expect(json_res['vertical']['id']).to eq(vertical.id)
  end

  context 'with valid params' do
    let(:params) { { name: 'Comedy Writing' } }

    it 'creates a new vertical' do
      api_request_post '/verticals', params: { vertical: params }, token: token
      json_res = JSON.parse(response.body)
      expect(json_res['vertical']['name']).to eq(params[:name])
    end

    it 'updates an existing vertical' do
      api_request_put "/verticals/#{vertical.id}", params: { vertical: params }, token: token
      json_res = JSON.parse(response.body)

      expect(json_res['vertical']['name']).to eq(params[:name])
      expect(vertical.reload.name).to eq(params[:name])
    end

    it 'deletes a vertical' do
      expect {
        api_request_delete "/verticals/#{vertical.id}", token: token
      }.to change {
        Vertical.count
      }.by(-1)
    end
  end

  context 'without valid params' do
    let(:name) { 'TAKEN' }
    let!(:category) { create :category, name: name }
    let(:params) { { name: name } }

    it 'returns an error instead of creating' do
      api_request_post '/verticals', params: { vertical: params }, token: token
      json_res = JSON.parse(response.body)

      expect(response).to be_bad_request
      expect(json_res.keys).to include('errors')
    end

    it 'returns an error instead of updating' do
      api_request_put "/verticals/#{vertical.id}", params: { vertical: params }, token: token
      json_res = JSON.parse(response.body)

      expect(response).to be_bad_request
      expect(json_res.keys).to include('errors')
    end
  end
end
