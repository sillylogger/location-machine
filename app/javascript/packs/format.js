import Globalize from 'globalize';
import likelySubtags from 'cldr-data/supplemental/likelySubtags.json';
import currencyData from 'cldr-data/supplemental/currencyData.json';

Globalize.load(likelySubtags);
Globalize.load(currencyData);

const locales = ['vi', 'en'];

const load_locale = locale => {
  Globalize.load(require(`cldr-data/main/${locale}/currencies.json`));
  Globalize.load(require(`cldr-data/main/${locale}/numbers.json`));
};

locales.map(locale => load_locale(locale));

const getCookie = cname => {
  const name = cname + '=';
  const ca = document.cookie.split(';');
  for (let i = 0; i < ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return null;
};

const formatterByCurrency = currency =>
  Globalize(getCookie('locale') || 'en').currencyFormatter(currency);

export const formatPrice = () => {
  const elements = document.getElementsByClassName('js-price');
  const currency = document.head.querySelector('[name~=site_currency][content]')
    .content;
  const formatter = formatterByCurrency(currency);
  Array.from(elements).forEach(element => {
    element.innerHTML = formatter(parseFloat(element.innerText));
  });
};
