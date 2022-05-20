# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :captions
  resources :images, only: [:show]

  resources :users do
    collection do
      post 'sign_up'
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
