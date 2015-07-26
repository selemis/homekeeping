module AssetAccountBehavior

  def amount_sign_for_debit
    1
  end

  def calculate_debit
    'sum_positive_filtered_entries'
  end

  def calculate_credit
    'sum_negative_filtered_entries'
  end

  def negative_amount_credit
    true
  end

  def positive_amount_credit
    false
  end

  def negative_amount_debit
    false
  end

  def positive_amount_debit
    true
  end

end