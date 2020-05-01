class Micropost < ApplicationRecord
  belongs_to  :user
  has_one_attached :image # マイクロポスト1件につき画像は1件
  default_scope -> { order(created_at: :desc) }
  validates   :user_id, presence: true
  validates   :content, presence: true,
                          length: { maximum: 140 }
  # 画像のvalidation
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 1.megabytes,
                                      message: "should be less than 1MB" }
                                      
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
