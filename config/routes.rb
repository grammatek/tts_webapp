Rails.application.routes.draw do
  root "processed_files#new"
  post "processed_files/trigger_job"
  post "processed_files/play"
  resources :processed_files
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
