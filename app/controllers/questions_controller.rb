class QuestionsController < ApplicationController

	before_action :redirect_top, only: [:new, :confirm, :create, :destroy]
	before_action :set_open_question, only: [:open, :open_pv, :open_point]
	impressionist unique: [:session_hash]

  def new
    @question = Question.new
    @categories = Category.all
    @title = params[:title]
    @text = params[:text]
    @category_id = params[:category_id]
    @point = params[:point]
    # binding.pry
  end

  def confirm
    @question = Question.new(question_params)
  end

  def create
    @question = Question.new(question_params)
    @categories = Category.all
    if params[:stripeToken] && params[:stripeEmail]
      # stripe決済
      # Amount in cents
      @amount = @question.point #引き落とす金額
      ###この操作で、Stripe から帰ってきた情報を取得します
      customer = Stripe::Customer.create(
          :email => params[:stripeEmail], #emailは暗号化されずに受け取れます
          :source  => params[:stripeToken] #めちゃめちゃな文字列です
      )

      ###この操作で、決済をします
      charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => @amount,
          :description => 'Rails Stripe customer',
          :currency    => 'jpy'
      )
      @question.save
      redirect_to controller: 'questions', action: 'show', id: @question.id
    else
      redirect_to controller: 'questions', action: 'new'
    end
  end

  def show
    @question = Question.find(params[:id])
    impressionist(@question, nil, :unique => [:session_hash])
    @answer = Answer.new
    @all_answers = @question.answers.includes(:user)
    @answers = @all_answers.where(best_answer: nil).order("updated_at DESC")
    @best_answer = @all_answers.find_by(best_answer: true)

    @is_questioner = false
    @answerable = true # TODO: 変数名は後で直す
    if current_user != nil
      @is_questioner = current_user.id == @question.user_id
      @answerable  = @all_answers.exists?(user_id: current_user.id)
    end
    @resolved = @question.done.present?
  end

  # ランキング
  def ranking
    @resolved_questions = Question.where(done: true)
    @questions = @resolved_questions.page(params[:page]).per(10).order('impressions_count DESC')
  end

  def ranking_open
    @open_questions = Question.where(done: nil)
    @questions = @open_questions.page(params[:page]).per(10).order('impressions_count DESC')
  end

  # 回答受付中
  def open
    @questions = @questions.order('updated_at DESC')
  end

  def open_pv
    @questions =  @questions.order('impressions_count DESC')
  end


  def open_point
    @questions =  @questions.order('point DESC')
  end


  private

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :point).merge(user_id: current_user.id)
  end

  def revive_active_record(arr)
    arr.first.class.where(id: arr.map(&:id))
  end

  def set_open_question
    @questions = Question.where(done: nil).page(params[:page]).per(10)
  end

end
