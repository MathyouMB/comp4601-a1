# frozen_string_literal: true

Rails.application.routes.draw do
  get '/crawls', to: 'crawls#index'
  get '/crawls/:id/pages', to: 'crawls#pages'
  post '/crawls', to: 'crawls#create'

  get '/pages/:id', to: 'pages#get'
end
