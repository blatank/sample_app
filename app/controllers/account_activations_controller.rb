class AccountActivationsController < ApplicationController
  def edit
    # emailからユーザを取得
    user = User.find_by(email: params[:email])
    
    # :idはトークン
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # activate関係のDB更新
      user.activate
      
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
    
  end
end
