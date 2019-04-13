module CurrenciesHelper
  def to_currency(amount)
    number_to_currency(amount, { unit: '$' })
  end
end
