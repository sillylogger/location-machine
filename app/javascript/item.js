utils = require('not-jquery');

renderSearchItemsToHomePage = body => {
  document.getElementById('items_container').innerHTML = body;
  utils.hideSpinners();
};

appendNewestItemsToHomePage = body => {
  document
    .getElementById('items_container')
    .insertAdjacentHTML('beforeend', body);
  utils.hideSpinners();
};

let item = {
  pullLatestItems: () => {
    utils.showSpinners();
    utils.callAjax('/items.js', appendNewestItemsToHomePage);
  },
  pullSearchResults: url => {
    utils.showSpinners();
    utils.callAjax(url, renderSearchItemsToHomePage);
  },
};

module.exports = item;
