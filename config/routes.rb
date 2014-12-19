Rails.application.routes.draw do
  root 'home#index'
  resource 'calendar', only: :show
end
