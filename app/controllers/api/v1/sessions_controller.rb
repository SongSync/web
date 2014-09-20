class Api::V1::SessionsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [:create ]

  skip_before_filter :verify_authenticity_token

  before_filter :ensure_params_exist, except: [:new]

  respond_to :json

  def new
    if current_user
      render json: { success: true, current_user: current_user }
    else
      render json: { success: false }
    end
  end

  def create
    self.resource = User.where(:email=>params[:user_login][:login]).first
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user_login][:password])
      sign_in("user", resource)
      render :json=> { :success=>true, :current_user => resource }
    else
      invalid_login_attempt
    end
  end

  def destroy
    render json: { success: sign_out(:user) }
  end

  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>200
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>200
  end
end