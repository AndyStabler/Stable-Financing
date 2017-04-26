Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'registrations'}
  root 'home#index'

  resources :users

  resources :transfers, only: [:index, :create, :destroy]
  resources :balances, only: [:new, :index, :create]
  resources :balance_forecasts, only: [:show]
end
