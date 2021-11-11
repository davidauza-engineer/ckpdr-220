# frozen_string_literal: true

Rails.application.routes.draw do
  post 'csvs/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :retention_emails, only: %i[new create index]
end
