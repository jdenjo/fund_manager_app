Rails.application.routes.draw do
  resources :stocks
  get '/' , to: 'welcome#home', as: 'home'
  resources :transactions
  resources :positions
  resources :funds
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
