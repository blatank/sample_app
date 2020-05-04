class RelationshipsController < ApplicationController
  # ログインを事前に確認
  before_action :logged_in_user
  
  # POST /relationships
  def create
    # フォローするユーザを取得
    user = User.find(params[:followed_id])
    
    # current_userがuserをフォロー
    current_user.follow(user)
    
    # フォローしたユーザのページに戻る
    redirect_to user
  end
  
  # DELETE /relationships/:id
  def destroy
    # アンフォローするユーザをRelationshipから取得
    user = Relationship.find(params[:id]).followed
    
    # current_userがuserをアンフォロー
    current_user.unfollow(user)
    
    # アンフォローしたユーザのページに戻る
    redirect_to user
  end
end
