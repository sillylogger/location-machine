// let's not jquery..
// http://youmightnotneedjquery.com/

module.exports = {

  ready: function ready(fn) {
    if (document.readyState != 'loading'){
      fn();
    } else {
      document.addEventListener('DOMContentLoaded', fn);
    }
  }

}
