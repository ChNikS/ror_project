class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_user
  before_action :build_answer, only: [:show]
  after_action :publish, only: [:create]
  
  authorize_resource

  respond_to :html
  respond_to :json, only: :create
  respond_to :js, only: [:subscribe, :unsubscribe]
  
  include Voted
  
  def index
    respond_with(@questions = Question.all)

  end

  def show
    @answers = @question.answers      
  end

  def new
    respond_with(@question = Question.new)    
  end

  def edit
  end
  
  def create
    respond_with(@question = Question.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) 
  end

  def subscribe
    respond_with(current_user.subscribe_to(@question))
  end

  def unsubscribe
    respond_with(current_user.unsubscribe_from(@question))
  end

  private

  def publish
    PrivatePub.publish_to("/questions", question: @question.to_json, action: "create") if @question.valid?
  end

  def build_answer
    @answer = @question.answers.build
  end

  def load_user
    if current_user.present?
      gon.user = current_user.id
    end
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy]).merge(user: current_user)
  end
end