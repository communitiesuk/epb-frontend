export { initButtons, getUrlParameter }

window.addEventListener('load', function () {
  initButtons()
}, false)

const texts = {
  en: {
    open: 'Open all',
    close: 'Close all',
    relation: 'sections related to'
  },
  cy: {
    open: 'Agor pob adran',
    close: 'Cau pob adran',
    relation: "sy'n ymwneud â"
  }
}

function initButtons () {
  updateText()

  const openButtonObserver = new MutationObserver((mutationsList, observer) => {
    for (const mutation of mutationsList) {
      if (mutation.target.className.split(' ').includes('govuk-accordion__open-all') && mutation.addedNodes[0] && Object.values(texts.en).includes(mutation.addedNodes[0].textContent)) {
        updateText()
      }
    }
  })
  Array.from(document.getElementsByClassName('govuk-accordion')).forEach(accordion => {
    openButtonObserver.observe(accordion, { childList: true, subtree: true })
  })
}

function updateText () {
  const buttons = document.querySelectorAll('button.govuk-accordion__open-all')
  buttons.forEach((button) => {
    refreshButtonText(button)
  })
}

function refreshButtonText (button) {
  const lang = getUrlParameter('lang') || 'en'
  const isExpanded = button.getAttribute('aria-expanded') === 'true'
  const sectionHeading = button.closest('div.govuk-accordion').previousElementSibling?.innerHTML

  button.innerHTML = `${isExpanded ? texts[lang].close : texts[lang].open} <span class="govuk-visually-hidden">${texts[lang].relation} ${sectionHeading}</span>`
}

function getUrlParameter (name) {
  name = name.replace(/\[/, '\\[').replace(/]/, '\\]')
  const regex = new RegExp('[\\?&]' + name + '=([^&#]*)')

  const results = regex.exec(location.search)
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '))
}
