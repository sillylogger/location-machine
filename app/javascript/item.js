utils = require('not-jquery');

renderItemsToHomePage = body => {
  document.getElementById('items_container').innerHTML = body;
  utils.hideSpinners();
};

let item = {
  pullLatestItems: () => {
    utils.showSpinners();
    utils.callAjax('/items.js', renderItemsToHomePage);
  },
  pullSearchResults: url => {
    utils.showSpinners();
    utils.callAjax(url, renderItemsToHomePage);
  },
};

module.exports = item;
