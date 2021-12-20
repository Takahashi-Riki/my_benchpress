Rails.application.routes.draw do
  root "microposts#index"
  get "/login" => "session#new"
  post "/login" => "session#create"
  delete "/logout" => "session#destroy"
  resources :microposts, only: [:index, :create, :new, :destroy] do
    member do
      patch "/:direction" => "microposts#update"
    end
  end
end
