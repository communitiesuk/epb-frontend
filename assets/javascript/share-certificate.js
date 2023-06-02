export { copyToClipboard }

function clickHandler () { // eslint-disable-line no-unused-vars
  copyToClipboard()
  changeTextAndIconAnimation()
  maintainTabIndexOrder()
}

function copyToClipboard () {
  const input = document.body.appendChild(document.createElement('input'))
  input.value = window.location.href
  input.select()

  document.execCommand('copy')

  navigator.permissions.query({ name: 'clipboard-write' })
    .then((result) => {
      if (result.state === 'granted' || result.state === 'prompt') {
        navigator.clipboard.writeText(input.value)
      }
    })
    .catch(e => {
      // do nothing - we've already tried using execCommand
    })
    .finally(() => {
      input.parentNode.removeChild(input)
    })
}

function changeTextAndIconAnimation () {
  const text = document.getElementById('copyToClipboardButton')
  const originalText = text.innerHTML

  text.innerHTML = `<span class="copied">
        <img src="${text.dataset.clickedImageSrc}">
        </span> Copied`
  setTimeout(function () { text.innerHTML = originalText }, 5000)
}

function maintainTabIndexOrder () {
  document.getElementById('copyToClipboardButton').focus()
}
