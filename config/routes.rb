Billing::Engine.routes.draw do
  resources :issuers

  root to: "issuers#index"
end
