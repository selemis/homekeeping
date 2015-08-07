require 'validators/account_category_validation'

class LiabilitiesValidator < ActiveModel::EachValidator
  extend AccountCategoryValidation

  define_validation(['Liabilities'])

end
