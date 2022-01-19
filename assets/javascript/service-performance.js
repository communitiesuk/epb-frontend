export {translate_welsh, getUrlParameter}

window.addEventListener("load", function() {
  // loaded
  translate_welsh()
}, false);

const cyTexts = {
  open: "Agor pob adran",
  close: "Cau pob adran",
}

const texts = {
  en: {
    open: "Open all",
    close: "Close all",
  },
  cy: {
    open: "Agor pob adran",
    close: "Cau pob adran",
  }
}

function translate_welsh(){
  const lang = getUrlParameter('lang');
  if (lang === 'cy'){
    updateText();

    let openButtonObserver = new MutationObserver((mutationsList, observer) => {
      for(const mutation of mutationsList) {
        if (mutation.target.className.split(" ").includes("govuk-accordion__open-all") && mutation.addedNodes[0] && Object.values(texts.en).includes(mutation.addedNodes[0].textContent)) {
          updateText();
        }
      }
    });
    Array.from(document.getElementsByClassName("govuk-accordion")).forEach(accordion => {
      openButtonObserver.observe(accordion, { childList: true, subtree: true });
    });
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

  button.innerText = isExpanded ? texts.cy.close : texts.cy.open;
}

function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  let regex = new RegExp('[\\?&]' + name + '=([^&#]*)');

  let results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}
