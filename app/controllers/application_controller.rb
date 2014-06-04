class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :avatar, :profile_name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :avatar, :profile_name, :email, :password, :password_confirmation, :current_password) }
  end
  
  def document_permitted_attributes
    [:id, :attachment, :document, :attachment_file_name, :document_fields, :build_document, :remove_attachment]
  end
  
  def asset_permitted_attributes
    [:id, :picture, :album_id, :user_id, :asset, :asset_file_name, :asset_content_type, :asset_file_size, :asset_updated_at]
  end
  
  private
  def render_permission_error
    render file: 'public/permission_error', status: :error, layout: false
  end
end
