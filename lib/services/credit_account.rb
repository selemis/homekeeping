require 'services/perform_on_account'

class CreditAccount < PerformOnAccount

  def amount_sign
    category_object.amount_sign_for_debit * (-1)
  end

end