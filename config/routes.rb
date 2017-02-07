Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'registrations'}
  root 'home#index'

  resources :users

  resources :transfers, only: [:index, :create, :destroy]
  resources :balances, only: :create
end
