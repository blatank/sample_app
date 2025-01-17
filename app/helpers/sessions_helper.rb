module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      # 一度ログインしている場合はクエリを投げない
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # まずはユーザを取得
      user = User.find_by(id: user_id)
      # userが存在するかどうか確認してから、ログイン復元を試みる
      if user && user.authenticated?(:remember, cookies[:remember_token])
        # ログインする
        log_in user
        
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザがログインしているユーザと同じ？
  def current_user?(user)
    user && current_user == user
  end
  
  def logged_in?
    # current_userがnilならログインしていない
    !current_user.nil?
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end  
  
  def remember(user)
    # remember_token, remember_digest設定
    user.remember
    
    # IDは暗号化して保存
    cookies.permanent.signed[:user_id] = user.id
    
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    # GETリクエストならURL保存
    session[:forwarding_url] = request.original_url if request.get?
  end
end
