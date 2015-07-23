class Expenses

  def amount_sign_for_debit
    1
  end

  def calculate_debit
    "sum_positive_filtered_entries"
  end

  def calculate_credit
    "sum_negative_filtered_entries"
  end

end
