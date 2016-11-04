class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :best, :destroy]
  before_action :load_question, only: [:create, :update, :destroy, :best]
  before_action :load_user
  after_action :publish, only: [:create, :update, :destroy]
  after_action :notice, only: [:create]

  authorize_resource
    
  respond_to :js, :json

  
  include Voted
  
  def create
    @method = "create"
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def edit
  end

  def update
    @method = "update"
    @answer.update(answer_params)
    respond_with(@answer)
  end
  
  def best
    @answer.best!
  end

  def destroy
    @method = "delete"
    respond_with(@answer.destroy)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
  def load_question
    if params[:question_id].present?
      @question = Question.find(params[:question_id])
    else
      @question = @answer.question
    end
  end

  def load_user
    if current_user.present?
      gon.user = current_user.id
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy]).merge(user: current_user)
  end

  def publish
    PrivatePub.publish_to "/questions/#{@answer.question_id}/answers",
                          answer: @answer.to_builder, 
                          method: @method
  end

  def notice
    NoticeJob.perform_later(@answer) if @answer.valid?
  end
end
