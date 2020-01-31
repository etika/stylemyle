require 'rails_helper'

RSpec.describe 'Categories' do
  let(:user) { create :user }
  let(:token) { token_for(user.username, 'password') }
  let(:vertical) { create :vertical }
  let!(:categories_list) { create_list :category, 20, vertical: vertical }
  let(:category) { categories_list.first }

  it 'shows stored categories' do
    api_get "/verticals/#{vertical.id}/categories", token: token
    all_categories = JSON.parse(response.body)
    expect(first_page['categories'].count).to eq(20)
  end

  it 'shows a single category' do
    api_get "/verticals/#{vertical.id}/categories/#{category.id}", token: token
    json_res = JSON.parse(response.body)

    expect(json_res['category']['id']).to eq(category.id)
  end

  context 'with valid params' do
    let(:params) { { name: 'Wo Play', state: 'archived' } }

    it 'creates a new category' do
      api_post "/verticals/#{vertical.id}/categories", params: { category: params }, token: token
      json_res = JSON.parse(response.body)

      expect(json_res['category']['name']).to eq(params[:name])
      expect(json_res['category']['state']).to eq(params[:state])
    end

    it 'updates an existing category' do
      api_put "/verticals/#{vertical.id}/categories/#{category.id}", params: { category: params }, token: token
      json_res = JSON.parse(response.body)

      expect(json_res['category']['name']).to eq(params[:name])
      expect(category.reload.name).to eq(params[:name])
    end

    it 'deletes a category' do
      expect {
        api_delete "/verticals/#{vertical.id}/categories/#{category.id}", token: token
      }.to change {
        Category.count
      }.by(-1)
    end
  end

  context 'without valid params' do
    let(:name) { 'TAKEN' }
    let!(:category) { create :category, name: name }
    let(:params) { { name: name } }

    it 'returns an error instead of creating' do
      api_post "/verticals/#{vertical.id}/categories", params: { category: params }, token: token
      json_res = JSON.parse(response.body)

      expect(response).to be_bad_request
      expect(json_res.keys).to include('errors')
    end

    it 'returns an error instead of updating' do
      api_put "/verticals/#{category.vertical_id}/categories/#{category.id}",
              params: { category: params },
              token: token
      json_res = JSON.parse(response.body)

      expect(response).to be_bad_request
      expect(json_res.keys).to include('errors')
    end
  end
end
