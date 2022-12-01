export { initButtons, getUrlParameter }

window.addEventListener('load', function () {
  initButtons()
}, false)

const texts = {
  en: {
    relation: 'related to'
  },
  cy: {
    relation: 'sy’n ymwneud â'
  }
}

function initButtons () {
  updateAllSectionsText()
  setUpAccordionClickHandler()

  const openButtonObserver = new MutationObserver((mutationsList, observer) => {
    let shouldUpdateAllSectionLinks = false
    const processedAccordions = new Set()
    for (const mutation of mutationsList) {
      const mutationAccordion = mutation.target.closest('.govuk-accordion')
      if (!mutationAccordion || !hasUnprocessedClick(mutationAccordion)) {
        continue
      }
      let shouldClearAccordion = true
      if (mutation.target.closest('.govuk-accordion__show-all')) {
        shouldUpdateAllSectionLinks = true
      } else if (!mutation.target.closest('.govuk-accordion__section-button')) {
        shouldClearAccordion = false
      }
      if (shouldClearAccordion) {
        processedAccordions.add(mutationAccordion)
      }
    }
    if (shouldUpdateAllSectionLinks) {
      processedAccordions.forEach(updateTextsForAccordion)
    }
    processedAccordions.forEach(clearUnprocessedClick)
  })
  Array.from(document.getElementsByClassName('govuk-accordion')).forEach(accordion => {
    openButtonObserver.observe(accordion, { childList: true, subtree: true })
  })
}

function updateAllSectionsText () {
  Array.from(document.getElementsByClassName('govuk-accordion')).forEach(updateTextsForAccordion)
}

function updateTextsForAccordion (accordion) {
  Array.from(accordion.getElementsByClassName('govuk-accordion__show-all')).forEach(refreshAllSectionsButtonText)
}

function refreshAllSectionsButtonText (button) {
  const lang = currentLanguage()
  const sectionHeading = button.closest('div.govuk-accordion').previousElementSibling?.innerHTML
  const showAllTextSpan = button.querySelector('.govuk-accordion__show-all-text')

  const oldInnerHtml = showAllTextSpan.innerHTML

  if (!showAllTextSpan) {
    return
  }

  showAllTextSpan.innerHTML = `${oldInnerHtml} <span class="govuk-visually-hidden">${texts[lang].relation} ${sectionHeading}</span>`
}

function currentLanguage () {
  return getUrlParameter('lang') || 'en'
}

function getUrlParameter (name) {
  name = name.replace(/\[/, '\\[').replace(/]/, '\\]')
  const regex = new RegExp('[\\?&]' + name + '=([^&#]*)')

  const results = regex.exec(location.search)
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '))
}

function setUpAccordionClickHandler () {
  Array.from(document.getElementsByClassName('govuk-accordion')).forEach(accordion => {
    accordion.addEventListener('click', () => addUnprocessedClick(accordion), { capture: true })
  })
}

function addUnprocessedClick (accordion) {
  accordion.dataset.unprocessedClick = '1'
}

function clearUnprocessedClick (accordion) {
  delete accordion.dataset.unprocessedClick
}

function hasUnprocessedClick (accordion) {
  return accordion.dataset.unprocessedClick === '1'
}
