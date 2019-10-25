utils = require('not-jquery');

goToHomepageAndSetFocusOnSearchBoxCookie = () => {
  window.location.href = '/';
  utils.setCookie('focusOnSearchBox', true, 1);
};

focusOnSearchBox = () => {
  document.getElementById('query').focus();
};

clickOnSearchHandler = () => {
  if (location.pathname === '/') {
    focusOnSearchBox();
  } else {
    goToHomepageAndSetFocusOnSearchBoxCookie();
  }
};

onHomePageLoadFocusOnSearchBox = () => {
  if (utils.getCookie('focusOnSearchBox')) {
    focusOnSearchBox();
    utils.eraseCookie('focusOnSearchBox');
  }
};

let search = {
  clickOnSearchHandler,
  onHomePageLoadFocusOnSearchBox,
  goToHomepageAndSetFocusOnSearchBoxCookie,
  focusOnSearchBox,
};
module.exports = search;
