let printed
window.addEventListener('load', (event) => {
  const header = document.querySelector('h1')
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
  backLink.addEventListener('click', updateHref)
})

function resetBrowserHistory (window, url) {
  window.history.replaceState(null, document.title, url)
  window.history.pushState(null, document.title, url)
}

function updateHref () {
  if (printed === true) {
    this.setAttribute('href', backUrl)
  }
  return false
}
