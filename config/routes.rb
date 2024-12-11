Billing::Engine.routes.draw do
  resources :invoices do
    resources :invoice_items
  end
  resources :recipients
  resources :issuers

  root to: "issuers#index"
end
