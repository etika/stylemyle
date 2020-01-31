require 'rails_helper'

RSpec.describe 'Courses' do
  let(:user) { create :user }
  let(:token) { token_for(user.username, 'password') }
  let(:vertical) { create :vertical }
  let(:category) { create :category, vertical: vertical }
  let!(:courses_list) { create_list :course, 20, category: category }
  let(:course) { courses_list.first }

  it 'shows stored courses' do
    api_request_get "/verticals/#{vertical.id}/categories/#{category.id}/courses", token: token
    all_courses = JSON.parse(response.body)
    expect(first_page['courses'].count).to eq(20)
  end

  it 'shows a single course' do
    api_request_get "/verticals/#{vertical.id}/categories/#{category.id}/courses/#{course.id}", token: token
    json_res = JSON.parse(response.body)

    expect(json_res['course']['id']).to eq(course.id)
  end

  context 'with valid params' do
    let(:params) { { name: 'Hello', state: 'active', author: 'Abc' } }

    it 'creates a new course' do
      api_request_post "/verticals/#{vertical.id}/categories/#{category.id}/courses",
               params: { course: params },
               token: token
      json_res = JSON.parse(response.body)

      expect(json_res['course']['name']).to eq(params[:name])
      expect(json_res['course']['state']).to eq(params[:state])
      expect(json_res['course']['author']).to eq(params[:author])
    end

    it 'updates an existing course' do
      api_request_put "/verticals/#{vertical.id}/categories/#{category.id}/courses/#{course.id}",
              params: { course: params },
              token: token
      json_res = JSON.parse(response.body)

      expect(json_res['course']['name']).to eq(params[:name])
      expect(course.reload.name).to eq(params[:name])
    end

    it 'deletes a course' do
      expect {
        api_request_delete "/verticals/#{vertical.id}/categories/#{category.id}/courses/#{course.id}", token: token
      }.to change {
        Course.count
      }.by(-1)
    end
  end

  context 'without valid params' do
    let(:name) { 'TAKEN' }
    let!(:category) { create :category, name: name }
    let(:params) { { name: name } }

    it 'returns an error instead of creating' do
      api_request_post "/verticals/#{vertical.id}/categories/#{category.id}/courses",
               params: { course: params },
               token: token
      json_res = JSON.parse(response.body)

      expect(response).to be_bad_request
      expect(json_res.keys).to include('errors')
    end
  end
end
