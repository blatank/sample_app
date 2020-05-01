require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # michaelでログイン
    log_in_as(@user)
    
    # rootにアクセス
    get root_path
    
    # これまでの投稿がpaginationされているはず
    assert_select 'div.pagination'
    
    # 無効な送信してもマイクロポスト数がかわらない事を確認
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    
    # エラーが出ていることを確認
    assert_select 'div#error_explanation'
    
    # エラーが出た後も正しいpaginationリンクが貼れていることを確認
    assert_select 'a[href=?]', '/?page=2'  # 正しいページネーションリンク
    
    # 有効な送信
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    
    # 正しい送信の後はリダイレクトされること
    assert_redirected_to root_url
    follow_redirect!
    
    # 送った投稿があることを確認
    assert_match content, response.body
    
    # deleteがあることを確認
    assert_select 'a', text: 'delete'
    
    # 最新のマイクロポストを削除
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
