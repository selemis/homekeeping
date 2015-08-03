module AccountCategoryValidation

  def define_validation(categories)
    define_method(:validate_each) do |record, attribute, value| 
      unless value.nil?
        unless  categories.include?(value.category)
          record.errors[attribute] <<  "The #{attribute.to_s} account category is not #{categories.join(' or ')}"
        end
      end
    end
  end

end

