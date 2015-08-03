require 'validators/account_category_validation'

class RevenueValidator < ActiveModel::EachValidator
  extend AccountCategoryValidation

  define_validation(['Revenue'])

end
