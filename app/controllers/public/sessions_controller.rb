# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :end_user_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    spots_path
  end

  # 退会しているかを判断するメソッド
  def end_user_state
    end_user = EndUser.find_by(email: params[:end_user][:email])
    return if !end_user
    if end_user.valid_password?(params[:end_user][:password]) && end_user.is_deleted == true
      flash[:notice] = "退会済みです。新規登録を行なってください。"
      redirect_to new_end_user_registration_path
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
