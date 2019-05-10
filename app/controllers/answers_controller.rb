class AnswersController < ApplicationController

  # def create
  #   @answers = Answer.create(create_params)
  #   redirect_to "/questions/#{@answers.question.id}"
  # end

  def confirm
    @answer = Answer.new(create_params)
    @question = Question.find(@answer.question_id)
    render template: "questions/show" if @answer.invalid?
  end

  def create
    @answer = Answer.new(create_params)
    respond_to do |format|
        if params[:back]
          format.html { render template: "questions/show" }
        elsif @answer.save
          format.html { redirect_to root_path }
        else
          format.html { render template: "questions/show" }

        end
    end
  end

  # def back
  #   @answer = Answer.new(create_params)
  #   render template: "questions/show"
  # end

  private
  def create_params
    params.require(:answer).permit(:text).merge(question_id: params[:question_id], user_id: current_user.id)
  end

end
