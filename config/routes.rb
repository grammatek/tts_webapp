Rails.application.routes.draw do
  root "processed_files#index"
  post "processed_files/trigger_job"
  resources :processed_files
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
