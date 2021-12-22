export {translate_welsh, getUrlParameter}


window.addEventListener("load", function() {
  // loaded
  translate_welsh()
}, false);



function translate_welsh(){
  const lang = getUrlParameter('lang');
  if (lang === 'cy'){
    updateText();
  }
}

function updateText(){
  let buttons = document.querySelectorAll("button.govuk-accordion__open-all");
  buttons.forEach((button) => {
    button.innerText = "Agor pob adran";
    button.addEventListener('click', function() {
      let is_expanded = this.ariaExpanded;

      let text = "Agor pob adran";
      if (is_expanded == "true") { text = "Cau pob adran" };

      this.innerText = text;
    })
  });
}

function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  let regex = new RegExp('[\\?&]' + name + '=([^&#]*)');

  let results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}
