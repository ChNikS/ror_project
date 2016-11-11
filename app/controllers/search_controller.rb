class SearchController < ApplicationController
  authorize_resource
  respond_to :html
  
  def index
    respond_with(@results = Search.search_for(params))
  end
end
