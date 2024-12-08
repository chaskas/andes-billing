Billing::Engine.routes.draw do
  resources :invoices
  resources :invoice_items
  resources :recipients
  resources :issuers

  root to: "issuers#index"
end
