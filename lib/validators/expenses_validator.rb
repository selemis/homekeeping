class ExpensesValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      #TODO Remove words Expenses
      category = 'Expenses'
      unless  [category].include?(value.category)
        record.errors[attribute] <<  "The #{attribute.to_s} account category is not #{category}"
      end
    end

  end


end