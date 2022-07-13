export { initButtons, getUrlParameter }

window.addEventListener('load', function () {
  initButtons()
}, false)

const texts = {
  en: {
    showAllSections: 'Show all sections',
    show: 'Show',
    hideAllSections: 'Hide all sections',
    hide: 'Hide',
    relation: 'related to',
    thisSectionForShow: ' this section',
    thisSectionForHide: ' this section'
  },
  cy: {
    showAllSections: 'Dangos pob adran',
    show: 'Dangos',
    hideAllSections: 'Cuddio pob adran',
    hide: 'Cuddio',
    relation: 'sy’n ymwneud â',
    thisSectionForShow: ' yr adran hon',
    thisSectionForHide: '’r adran hon'
  }
}

function initButtons () {
  updateAllSectionsText()
  setUpAccordionClickHandler()

  const openButtonObserver = new MutationObserver((mutationsList, observer) => {
    let shouldUpdateAllSectionLinks = false
    let sectionButtonToUpdate
    const processedAccordions = new Set()
    for (const mutation of mutationsList) {
      const mutationAccordion = mutation.target.closest('.govuk-accordion')
      if (!mutationAccordion || !hasUnprocessedClick(mutationAccordion)) {
        continue
      }
      let shouldClearAccordion = true
      if (mutation.target.closest('.govuk-accordion__show-all')) {
        shouldUpdateAllSectionLinks = true
      } else if (mutation.target.closest('.govuk-accordion__section-button')) {
        sectionButtonToUpdate = mutation.target.closest('button')
      } else {
        shouldClearAccordion = false
      }
      if (shouldClearAccordion) {
        processedAccordions.add(mutationAccordion)
      }
    }
    if (shouldUpdateAllSectionLinks) {
      processedAccordions.forEach(updateTextsForAccordion)
    }
    if (sectionButtonToUpdate) {
      refreshSectionButtonText(sectionButtonToUpdate)
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
  Array.from(accordion.getElementsByClassName('govuk-accordion__section-button')).forEach(refreshSectionButtonText)
  refreshSectionButtonText(accordion.getElementsByClassName('govuk-accordion__show-all')[0])
  Array.from(accordion.getElementsByClassName('govuk-accordion__show-all')).forEach(refreshAllSectionsButtonText)
}

function refreshAllSectionsButtonText (button) {
  const lang = currentLanguage()
  const isExpanded = button.getAttribute('aria-expanded') === 'true'
  const sectionHeading = button.closest('div.govuk-accordion').previousElementSibling?.innerHTML
  const showAllTextSpan = button.querySelector('.govuk-accordion__show-all-text')

  if (!showAllTextSpan) {
    return
  }

  showAllTextSpan.innerHTML = `${isExpanded ? texts[lang].hideAllSections : texts[lang].showAllSections} <span class="govuk-visually-hidden">${texts[lang].relation} ${sectionHeading}</span>`
}

function refreshSectionButtonText (button) {
  const lang = currentLanguage()
  const isExpanded = button.getAttribute('aria-expanded') === 'true'
  const showTextSpan = button.querySelector('.govuk-accordion__section-toggle-text')

  if (!showTextSpan) {
    return
  }

  showTextSpan.innerHTML = `${isExpanded ? texts[lang].hide : texts[lang].show} <span class="govuk-visually-hidden">${texts[lang][isExpanded ? 'thisSectionForHide' : 'thisSectionForShow']}</span>`
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
