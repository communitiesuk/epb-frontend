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
  let buttons =  document.querySelectorAll("button.govuk-accordion__open-all");
  buttons.forEach((button) => {
    button.innerText = "Agor pob un";
  });
}


function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  let regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
  let results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}
