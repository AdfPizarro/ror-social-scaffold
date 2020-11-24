class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :post_id }
  validates :post_id, presence: true
  belongs_to :user
  belongs_to :post
end
