require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    # ログインせずにマイクロポストを投稿
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    # ログインページに飛ぶ
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    # ログインせずにマイクロポストを削除
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    # ログインページに飛ぶ
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    # michaelでログイン
    log_in_as(users(:michael))
    
    # antsのマイクロポストを取得
    micropost = microposts(:ants)
    
    # michaelでantsのマイクロポストをdelete
    assert_no_difference 'Micropost.count' do
      # DELETE /microposts/:id
      delete micropost_path(micropost)
    end
    
    # 失敗時はrootにリダイレクトされるはず
    assert_redirected_to root_url
  end
end
