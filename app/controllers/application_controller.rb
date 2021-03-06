require 'custom_errors'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Errors::WentWrong, :with => :respond_with_notice
  rescue_from Errors::MissingParameters, :with => :respond_missing_param

  def respond_with_notice
    redirect_to root_path, flash[:error] => 'Not able to view results.'
  end

  def respond_missing_param
    redirect_to root_path, flash[:error] => 'Some paramaters are missing, Please check and try again.'
  end

  def static_params
    { currency:'USD', page_size: 10, tracker:'ABC123',rooms:"rooms[][adults]=2" }
  end
end
