Rails.application.routes.draw do
  
  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    resources :end_users, only: [:index, :edit, :update]
  end
  
  # 顧客用
  devise_for :end_users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  
  scope module: :public do
    root to: "homes#top"
    resources :spots do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
      
    resources :end_users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      
      member do
        get :followings
        get :followers
        get :collection
      end
      
      collection do
        get :unsubscribe
        patch :withdraw
      end
    end
    resources :tags, only: [:show]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
