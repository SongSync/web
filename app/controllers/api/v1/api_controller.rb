class Api::V1::ApiController < ActionController::Base
  before_filter :load_user

  def load_user
    @user ||= current_user
    @user ||= User.where(api_key: params[:api_key]).first if params[:api_key]

    if !@user
      render json: {
        success: false,
        message: 'Could not authenticate API key.'
      }
    end
  end
end