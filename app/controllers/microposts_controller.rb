class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    # before_actionにより、ログインできている前提でコードを書いて良い
    @micropost = current_user.microposts.build(micropost_params)
    
    # 添付ファイルがあれば追加
    @micropost.image.attach(params[:micropost][:image])
    
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      # homeアクションは呼び出されないので@feed_itemsが必要
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  private
    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
