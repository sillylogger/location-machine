
beforeEach( () => {
  window.root = document.getElementById('root');

  if(!root) {
    root = document.createElement("div");
    root.id = "root";
    document.body.appendChild(root);
  } else {
    while(root.hasChildNodes()) {
      root.removeChild(root.lastChild);
    }
  }

});

