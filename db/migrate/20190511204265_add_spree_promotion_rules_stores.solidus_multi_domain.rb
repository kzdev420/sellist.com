# frozen_string_literal: true
# This migration comes from solidus_multi_domain (originally 20130412212659)

class AddSpreePromotionRulesStores < SolidusSupport::Migration[4.2]
  def self.up
    return if table_exists?(:spree_promotion_rules_stores)

    create_table :spree_promotion_rules_stores, :id => false do |t|
      t.references :promotion_rule
      t.references :store
    end
  end

  def self.down
    drop_table :spree_promotion_rules_stores
  end
end
