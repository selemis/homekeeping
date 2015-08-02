class RevenueValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      #TODO Remove words Assets
      unless  %w(Revenue).include?(value.category)
        record.errors[attribute] <<  'The from account category is not Revenue'
      end
    end

  end

end