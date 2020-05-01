class Micropost < ApplicationRecord
  belongs_to  :user
  has_one_attached :image # マイクロポスト1件につき画像は1件
  default_scope -> { order(created_at: :desc) }
  validates   :user_id, presence: true
  validates   :content, presence: true,
                          length: { maximum: 140 }
end
