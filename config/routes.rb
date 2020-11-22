Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "restaurants#index"

  resources :restaurants
  get '/restaurants/:id/qrcode', to: "restaurants#qrcode", as: "restaurant_qrcode"
  post "/send-email-qr-code", to: "restaurants#send_email_qr_code"
  post "/purge_item_picture", to: "restaurants#purge_item_picture"

  get 'g/:id', to:"restaurants#generator"

  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
