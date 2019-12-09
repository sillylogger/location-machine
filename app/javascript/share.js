let shareLink;
let createLocationLink;

class Share {

  constructor(shareId, createId) {
    shareLink = document.getElementById(shareId);
    createLocationLink = document.getElementById(createId);

    if (!shareLink) {
      console.log('share.constructor - no share link');
      return false;
    }

    if (!navigator.share) {
      console.log('share.constructor - navigator.share not supported');
      return false;
    }

    this.swapCreateToShare();
    shareLink.addEventListener('click', this.run);
  }

  swapCreateToShare() {
    createLocationLink.hidden = true;
    shareLink.hidden = false;
  }

  run() {
    const title = document.title;

    let url = document.location.href;
    const canonicalElement = document.querySelector('link[rel=canonical]');
    if (canonicalElement !== null) {
        url = canonicalElement.href;
    }

    navigator.share({
        title: title,
        url: url
    }).then(() => {
        console.log('share.run - success');
    }).catch(console.error);
  }
}

module.exports = Share;
