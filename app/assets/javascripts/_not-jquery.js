// let's not jquery..
// http://youmightnotneedjquery.com/

function ready(fn) {
  if (document.readyState != 'loading'){
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

function addEventListener(el, eventName, handler) {
  if (el.addEventListener) {
    el.addEventListener(eventName, handler);
  } else {
    // IE8 support
    el.attachEvent('on' + eventName, function(){
      handler.call(el);
    });
  }
}

