Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'conversations#index'
  post 'conversations/webhook',to: "conversations#get_conversation"
  get 'conversations/search', to: 'conversations#search'
  get '/auth/intercom/callback', to: 'sessions#create'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  resources :conversations, only: [:index, :show]
  get '/elb-ping', to: 'conversations#ping'
  namespace :api do
    get 'populate', to: "populate_conversations#populate"
  end


end
