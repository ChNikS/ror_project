require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  #protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exeption|
    redirect_to root_path, alert: exeption.message
  end
  #check_authorization
end
