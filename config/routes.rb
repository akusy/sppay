Sppay::Application.routes.draw do
  root "queries#index"
  post "queries/create"
  get "queries/:id" => "queries#show", as: :query
end
