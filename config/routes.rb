Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'top#index'
  resources :questions, only: [:new, :create, :destroy]
  resources :users, only: [:edit, :update]
  resources :users, only: [:show]
    get 'my_question/:id' => 'users#my_question'
    get 'my_answer/:id' => 'users#my_answer'
    get 'identification/:id' => 'users#identification'
    get 'card/:id' => 'users#card'
    get 'bank/:id' => 'users#bank'

  # 検索
  namespace :questions do
    get :search
    get :search_open
    get :search_resolved
  end

  # カテゴリ
  resources :category, only: %i(index show) do
    member do
      get :category_pv
      get :category_answer_count
      get :category_point
      get :category_open
      get :open_pv
      get :open_answer_count
      get :open_point
    end
  end

  # ランキング
  namespace :questions do
    get :ranking
    get :ranking_open
    get :open_answer_count
    get :open_point
  end

  # 回答受付中
  namespace :questions do
    get :open
    get :open_pv
    get :open_answer_count
    get :open_point
  end

  post 'questions/confirm' => 'questions#confirm'

  # QA詳細
  resources :questions, only: :show do
    resources :answers, only: %i(create update destroy)
    post 'confirm' => 'answers#confirm'
    get 'answers/:id/ba_confirm' => 'answers#ba_confirm'
  end

  # フッター
  get 'privacy_policy' => 'others#privacy_policy'
  get 'rule' => 'others#rule'
  get 'help' => 'others#help'
  get 'contact' => 'others#contact'

end
