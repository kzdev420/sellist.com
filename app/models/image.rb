class Image < ApplicationRecord
  belongs_to :parent, :polymorphic => true
  mount_uploader :file, ImageUploader
end
