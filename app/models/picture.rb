class Picture < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :content, presence: true
  validates :content, length: {in: 1..140}
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorites, through: :favorites, source: :user
end
