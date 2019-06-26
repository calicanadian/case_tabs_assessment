Rails.application.routes.draw do
  root to: 'components#index'
  post :command_io, to: 'components#command_io'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
