class Account::QuestionsController < InheritedResources::Base
  belongs_to :quiz
  actions :all, except: [:show]
  before_action :authenticate_user!

  def edit_order
    @questions = collection
  end

  def update_order
    parent.update_attributes!(quiz_params)
    respond_with parent, location: collection_url, notice: "Redoslijed je uspješno izmijenjen"
  end

  private

  def build_resource
    @question ||= begin
      question = resource_class.new(*resource_params)
      question.quiz = parent
      question
    end
  end

  def begin_of_association_chain
    current_user
  end

  def resource_class
    "#{params[:category].camelize}Question".constantize
  end

  def permitted_params
    params.permit!
  end

  def quiz_params
    params.require(:quiz).permit!
  end
end
