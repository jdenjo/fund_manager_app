Rails.application.routes.draw do
  resources :stocks

  get "/", to: "welcome#home", as: "home"

  get "/transactions/addtrim", to: "transactions#addTrim", as: "addtrim"

  resource :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :transactions
  resources :positions
  resources :funds

  resources :users
  # resources :users, only: [ :new, :create, :update, :edit ]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
