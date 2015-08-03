require 'validators/account_category_validation'

class AssetOrLiabilitiesValidator < ActiveModel::EachValidator
  extend AccountCategoryValidation

  define_validation(%w(Assets Liabilities))

end
