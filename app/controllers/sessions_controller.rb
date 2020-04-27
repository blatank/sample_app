class SessionsController < ApplicationController
  # GET /login
  def new
    # Session.newは不要
  end
  
  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    # パスワード確認
    if user && user.authenticate(params[:session][:password])
      # パスワードOK、ログインする
      log_in user
      
      # remember_me(チェックされていないときはforgetする)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      
      # ユーザのページにリダイレクト
      redirect_back_or user
    else
      # まちがっている場合
      flash.now[:danger] = "Invalid email/password conbination"
      render 'new'
    end
  end
  
  # DELETE /logout
  def destroy
    # ログインしているならログアウトする
    if logged_in?
      log_out
    end

    redirect_to root_url
  end
end
