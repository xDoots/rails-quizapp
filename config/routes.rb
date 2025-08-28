Rails.application.routes.draw do
  devise_for :users
  resources :questions
  resources :quizzes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "all_quizzes", to: "quizzes#all_quizzes", as: "all_quizzes"
  get "take_quiz/:id", to: "quizzes#take", as: "take_quiz"
  get "quiz_results/:id", to: "quizzes#results", as: "quiz_results"
  get "quiz_completed/:id", to: "quizzes#completed", as: "quiz_completed"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "dashboard#show"
  root to: redirect("/quizzes")

  resources :quizzes, shallow: true do
    resources :questions, only: [ :new, :create, :edit, :update, :destroy ]
    resources :quiz_attempts, only: [ :new, :create, :show ]
  end
end
