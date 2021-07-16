let printed
window.addEventListener('load', (event) => {
  printed = false

  const backUrl = document.referrer
  const printButton = document.getElementById('link')
  if (printButton) {
    printButton.addEventListener('click', () => {
      printed = true
      resetBrowserHistory(window, backUrl)
    })
  }

  const backLink = document.querySelector('a.govuk-back-link')
  backLink.addEventListener('click', () => updateHref(backUrl))
})

function resetBrowserHistory (window, url) {
  window.history.replaceState(null, document.title, url)
  window.history.pushState(null, document.title, url)
}

function updateHref (backUrl) {
  if (printed === true) {
    this.setAttribute('href', backUrl)
  }
  return false
}
