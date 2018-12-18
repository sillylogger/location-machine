// let's not jquery..
// http://youmightnotneedjquery.com/

let notJquery = {

  ready: function ready(fn) {
    if (document.readyState != 'loading'){
      fn();
    } else {
      document.addEventListener('DOMContentLoaded', fn);
    }
  }

}

module.exports = notJquery;

