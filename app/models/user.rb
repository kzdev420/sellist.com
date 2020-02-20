class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :email, :first_name, :last_name
  has_one :seller_detail, dependent: :destroy
  has_one :brand_detail, dependent: :destroy

  has_many :seller_items, class_name: "SellerItem", foreign_key: :seller_id, dependent: :destroy
  has_many :items, through: :seller_items
  has_many :recommended_apps

  mount_uploader :profile_pic, ImageUploader

  def self.roles
    return [['Seller', 'seller'], ['Manufacturer/Brand', 'brand']]
  end

  def brand
    self.account_type == "brand"
  end

  def seller
    self.account_type == "seller"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
