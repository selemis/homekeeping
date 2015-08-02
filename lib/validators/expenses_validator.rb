class ExpensesValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.nil?
      #TODO Remove words Expenses
      unless  %w(Expenses).include?(value.category)
        record.errors[attribute] <<  'The to account category is not Expenses'
      end
    end

  end


end