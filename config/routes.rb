Billing::Engine.routes.draw do
  resources :invoices
  resources :recipients
  resources :issuers

  root to: "issuers#index"
end
