class Public::EndUsers::SessionsController < Devise::SessionsController
  def guest_sign_in
    end_user = EndUser.guest
    sign_in end_user
    redirect_to spots_path, notice: 'ゲストでログインしました'
  end
end
