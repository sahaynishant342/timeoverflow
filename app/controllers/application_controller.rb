class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :glyph

  helper_method :current_user, :current_organization, :admin?, :superadmin?

  # before_filter do
  #   ap session.keys
  # end

  def index
  end

  before_filter :set_locale

  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
    true
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_organization
    @current_organization ||= current_user.try(:organizations).try(:first)
  end

  def admin?
    current_user.try :manages?, current_organization
  end

  def superadmin?
    current_user.try :superuser?
  end

  alias :superuser? :superadmin?

  def authenticate_superuser!
    superuser? || redirect_to(root_path)
  end
end
