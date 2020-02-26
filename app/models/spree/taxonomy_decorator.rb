Spree::Taxonomy.class_eval do
  # validates :store_id, :absense => true

  private

  # In order to use our custom validations we have to remove Spree's native validations first
  # Otherwise they'd be combined, not replaced
  def erase_validations
    validations = { store: ActiveRecord::Validations::PresenceValidator }

    validations.each do |field, validation_type|
      _validators[field]
        .find { |v| v.is_a? validation_type }
        .attributes
        .delete(field)
    end
  end
end
