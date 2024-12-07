Billing::Engine.routes.draw do
  resources :recipients
  resources :issuers

  root to: "issuers#index"
end
