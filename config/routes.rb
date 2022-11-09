Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match 'login' => 'users#login', via: [:post]
  match 'logout' => 'users#logout', via: [:post]
  match 'register' => 'users#create', via: [:post]

  resources :users, defaults: {format: :json} do
  end

  resources :products, defaults: {format: :json} do
  end

  resources :custom_fields, defaults: {format: :json}, only: [:index] do
    collection do
      post :create
      patch :update
      delete :destroy
    end
  end
end
