Rails.application.routes.draw do
  root to: "restaurants#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :restaurants
  get '/restaurants/:id/qrcode', to: "restaurants#qrcode", as: "restaurant_qrcode"
  post "/send-email-qr-code", to: "restaurants#send_email_qr_code"

  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
