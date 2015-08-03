require 'validators/account_category_validation'

class AssetValidator < ActiveModel::EachValidator
  extend AccountCategoryValidation

  define_validation(['Assets'])

end
