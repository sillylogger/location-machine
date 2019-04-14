Money.locale_backend = :currency
Monetize.assume_from_symbol = true

Monetize::Parser::CURRENCY_SYMBOLS[
  Money::Currency.table[:vnd][:symbol]
] = 'VND'

Monetize::Parser::CURRENCY_SYMBOLS.delete 'R'

Monetize::Parser::CURRENCY_SYMBOLS[
  Money::Currency.table[:idr][:symbol]
] = 'IDR'

