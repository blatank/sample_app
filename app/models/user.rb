class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                 foreign_key: "follower_id",
                                   dependent: :destroy
  # user.followingの実装
  has_many :following, through: :active_relationships,
                        source: :followed

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true,
                      length: { maximum: 50 } 
                      
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true,
                      length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                  uniqueness: true
  
  has_secure_password
  validates :password, presence: true,
                         length: { minimum: 6 },
                      allow_nil: true

                         
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    
    # validationなしでDB更新
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    # digestを取得
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    self.update_attribute(:remember_digest, nil)
  end
  
  # アカウント有効化
  def activate
    update_attribute(:activated,     true)
    update_attribute(:activated_at,  Time.zone.now)
  end
  
  def create_reset_digest
    self.reset_token  = User.new_token
    self.update_attribute(:reset_digest,  User.digest(reset_token))
    self.update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  # アカウント有効化のメールを送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定期限切れかどうかチェック
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  # ユーザをフォローする
  def follow(other_user)
    following << other_user
  end
  
  # ユーザのフォローを解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  # ユーザがフォローされているか確認する
  def following?(other_user)
    self.following.include?(other_user)
  end
    
  
  private
  
    def downcase_email
      self.email = self.email.downcase
    end
  
    # create前にactivation用のデータを生成する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
