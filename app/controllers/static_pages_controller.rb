class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログインしていたらマイクロポストのインスタンス(空)を取得する
      @micropost  = current_user.microposts.build 
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
