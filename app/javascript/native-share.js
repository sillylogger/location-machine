utils = require('not-jquery');

utils.ready(function () {
    let shareButton = document.getElementById('share_location');
    if (navigator.share && shareButton) {
        document.getElementById('create_location').hidden = true;
        shareButton.hidden = false;
        shareButton.addEventListener('click', function () {
            const title = document.title;
            const url = document.querySelector('link[rel=canonical]') ? document.querySelector('link[rel=canonical]').href : document.location.href;

            navigator.share({
                title: title,
                url: url
            }).then(() => {
                console.log('Thanks for sharing!');
            }).catch(console.error);
        })
    }
});
