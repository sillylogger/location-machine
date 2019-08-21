utils = require('not-jquery');

appendNewestItemsToHomePage = body => {
  document
    .getElementById('items_container')
    .insertAdjacentHTML('beforeend', body);
  utils.hideSpinners();
};

let item = {
  pullLatestItems: () => {
    utils.callAjax('/items.js', appendNewestItemsToHomePage);
  },
};

module.exports = item;
