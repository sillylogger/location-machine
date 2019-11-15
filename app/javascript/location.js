let location = {
  validateAddress: () => {
    addressEle = document.getElementById('location_address');
    const isError =
      addressEle.value != '' &&
      document.getElementById('location_latitude').value == '';
    if (isError) {
      addressEle.setCustomValidity(lm.messages.location.errors.address);
    } else {
      addressEle.setCustomValidity('');
    }
  },
};

module.exports = location;
