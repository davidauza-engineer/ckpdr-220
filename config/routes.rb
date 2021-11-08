# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :retention_emails, only: %i[new create index]
  post '/rentention_emails/download_csv', to: 'retention_emails#download_csv'
end
