class Search < ApplicationRecord
  AREAS = ['Question', 'Answer', 'Comment', 'User']
  AREAS_FOR_SELECT = ['Everywhere'] | AREAS

  def self.search_for(params)
    classes = []
    classes << params[:a].constantize if AREAS.include?(params[:a])
    
    ThinkingSphinx.search(Riddle::Query.escape(params[:q]), classes: classes)
  end
end
