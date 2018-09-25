Rails.application.routes.draw do
  root 'progress_summary#new'
  resources :progress_summary
end
