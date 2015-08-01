class AssetOrLiabilitiesValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      unless  %w(Assets Liabilities).include?(value.category)
        record.errors[attribute] <<  'The from account category is not Liabilities or Assets'
      end
    end

  end

end