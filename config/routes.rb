Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'top#index'
  resources :questions, only: [:new, :create, :destroy]
  resources :articles
  resources :users, only: [:edit, :update, :show]
#   resources :charges
    get 'my_question/:id' => 'users#my_question'
    get 'my_answer/:id' => 'users#my_answer'


    # 決済まわり
    get 'bank/:id' => 'charges#bank'
    get 'point/:id' => 'charges#point'
    get 'payout_confirmation/:id' => 'charges#payout_confirmation'
    get 'identification/:id' => 'charges#identification'
    post 'identification/:id' => 'charges#create_identification'
    post 'bank/:id' => 'charges#create_bank'
    post 'payaout/:id' => 'charges#payout_point'


    # namespace :users do
    #     get :my_question
    #     get :my_answer
    #     get :card
    #     get :bank
    #     get :point
    #   end

   resources :notifications, only: [:index]


  # 検索
  resources :search, only: %i() do
    collection do
      get :search
      get :open
      get :open_pv
      get :open_answer_count
      get :open_point

      get :resolved
      get :resolved_pv
      get :resolved_answer_count
      get :resolved_point
    end
  end

#   ユーザーランク
resources :user_ranking, only: %i() do
  collection do
    get :week
    get :month
    get :total
  end
end


  # カテゴリ
  resources :category, only: %i(index show) do
    member do
      get :pv
      get :answer_count
      get :point
      get :open
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
  post 'articles/confirm' => 'articles#confirm'


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
  get 'company' => 'others#company'
  get 'lp' => 'others#lp'


end
