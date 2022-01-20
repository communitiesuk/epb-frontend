export {translate_welsh, getUrlParameter}


window.addEventListener("load", function() {
  // loaded
  translate_welsh()
}, false);

const cyTexts = {
  open: "Agor pob adran",
  close: "Cau pob adran",
}

function translate_welsh(){
  const lang = getUrlParameter('lang');
  if (lang === 'cy'){
    updateText();
  }
}

function updateText(){
  let buttons = document.querySelectorAll("button.govuk-accordion__open-all");
  buttons.forEach((button) => {
    refreshButtonText(button);
    button.addEventListener('click', function() {
      refreshButtonText(this);
    });
  });
}

function refreshButtonText(button) {
  let isExpanded = button.getAttribute("aria-expanded") === "true";

  button.innerText = isExpanded ? cyTexts.close : cyTexts.open;
}

function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  let regex = new RegExp('[\\?&]' + name + '=([^&#]*)');

  let results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}
