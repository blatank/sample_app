class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
    
    # ここに置かないとMicropostControllerから呼べない
    # ログインしているかどうかチェック
    def logged_in_user
      unless logged_in?
        # リクエストしていたURL保存
        store_location
        
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
end
