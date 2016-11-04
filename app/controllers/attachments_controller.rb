class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  authorize_resource
  
  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    respond_with(@attachment.destroy)
  end
end
