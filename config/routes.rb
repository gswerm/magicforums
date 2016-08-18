Rails.application.routes.draw do

  root to: 'landing#index'
  get :about, to: 'static_pages#about'

  mount ActionCable.server => '/cable'

  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :edit, :create, :update, :destroy]

  post :upvote, to: 'votes#upvote'
  post :downvote, to: 'votes#downvote'

  resources :topics, except: [:show] do
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end


end
