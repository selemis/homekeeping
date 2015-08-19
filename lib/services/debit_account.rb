require 'services/perform_on_account'

class DebitAccount < PerformOnAccount

  def amount_sign
    category_object.amount_sign_for_debit
  end

end