module CurrenciesHelper
  def to_currency(amount)
    Money.from_amount(amount, Setting.site_currency).format
  end
end
