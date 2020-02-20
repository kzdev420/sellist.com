class Item < ApplicationRecord
  belongs_to :brand_detail
  belongs_to :category, optional: true
  belongs_to :sub_category, class_name: "Category", foreign_key: :sub_category_id, optional: true
  belongs_to :product_category, optional: true
  belongs_to :shopify_shop, optional: true

  has_many :images, :as => :parent, dependent: :destroy
  has_many :seller_items, dependent: :destroy
  has_many :sellers, through: :seller_items

  validates_uniqueness_of :item_number, scope: [:product_category_id, :brand_detail_id, :shopify_shop_id, :sku]
  after_touch :index

  searchable auto_index: true, auto_remove: true do
    text :name, :title, :upc, :item_number, :description, :style

    text :brand_name do
      brand_detail.company_name
    end

    integer :seller_id, :multiple => true do
      seller_items.map(&:seller_id)
    end

    boolean :discontinued, :multiple => true do
      seller_items.map(&:discontinued)
    end

    boolean :enabled_for_sale
    integer :brand_detail_id, :multiple => true
    integer :category_id
    integer :sub_category_id
    integer :product_category_id
    time    :created_at
  end

  def self.enabled
    where("enabled_for_sale = ?", true)
  end

  def self.filter(params, session, per_page = 40)
    search do
      unless params[:search_term].blank?
        fulltext "#{params[:search_term]}" do
          fields(:name, :title, :item_number, :style)
          #boost_fields(:name => 2.0, :title => 3.0)
        end
      end
      #fulltext params[:search_term] unless params[:search_term].blank?
      all_of do
        with(:enabled_for_sale, true)
        with(:brand_detail_id, params[:brands]) unless params[:brands].blank?
        with(:seller_id, params[:seller_id]) unless params[:seller_id].blank?
        with(:discontinued, params[:discontinued]) unless params[:discontinued].to_s.blank?
        #with(:brand_detail_id, params[:brand_detail_id]) unless params[:brand_detail_id].blank?
        with(:category_id, session[:catg_id]) unless session[:catg_id].blank?
        with(:sub_category_id, session[:sub_catg_id]) unless session[:sub_catg_id].blank?
        with(:product_category_id, session[:prod_catg_id]) unless session[:prod_catg_id].blank?
      end
      order_by :created_at, :desc
      paginate page: params[:page], per_page: per_page
    end
  end

  def brand
    self.brand_detail.company_name
  end

  def display_desc
    (self.description.blank? ? '' : self.description.html_safe)
  end
end
