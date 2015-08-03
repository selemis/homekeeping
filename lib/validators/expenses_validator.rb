require 'validators/account_category_validation'

class ExpensesValidator < ActiveModel::EachValidator
  extend AccountCategoryValidation

  define_validation(['Expenses'])

end
