Rails.application.routes.draw do
  get '/web_view' => 'exceptions#index'
  get '/web_view/:id' => 'exceptions#show'
end
