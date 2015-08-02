class AssetValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      #TODO Remove words Assets
      unless  %w(Assets).include?(value.category)
        record.errors[attribute] <<  'The to account category is not Assets'
      end
    end

  end

end