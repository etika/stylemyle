Rails.application.routes.draw do
  use_doorkeeper do
  skip_controllers :authorizations, :applications,
    :authorized_applications
end

  scope '/api', defaults: { format: :json } do
    scope '/v1' do
         devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
      }, skip: [:sessions, :password]

      resources :verticals do
        resources :categories do
          resources :courses
        end
      end
    end
  end
end
