class RelationshipsController < ApplicationController
  # ログインを事前に確認
  before_action :logged_in_user
  
  # POST /relationships
  def create
    # フォローするユーザを取得
    @user = User.find(params[:followed_id])
    
    # current_userがuserをフォロー
    current_user.follow(@user)
    
    respond_to do |format|
      format.html { redirect_to @user }  # フォローしたユーザのページに戻る
      format.js
    end
  end
  
  # DELETE /relationships/:id
  def destroy
    # アンフォローするユーザをRelationshipから取得
    @user = Relationship.find(params[:id]).followed
    
    # current_userがuserをアンフォロー
    current_user.unfollow(@user)
    
    respond_to do |format|
      format.html { redirect_to @user }  # アンフォローしたユーザのページに戻る
      format.js
    end
  end
end
