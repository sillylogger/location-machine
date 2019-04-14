module CurrenciesHelper

  def to_currency amount
    Money.from_amount(
      amount.present? ? amount : 0,
      Setting.site_currency
    ).format
  end

end
