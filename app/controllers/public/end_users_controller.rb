class Public::EndUsersController < ApplicationController
  def withdraw
  end_user = current_end_user
  end_user.update(is_deleted: true)
  reset_session
  redirect_to root_path
  end
end
