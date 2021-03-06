function clickHandler () { // eslint-disable-line no-unused-vars
  copyToClipboard()
  changeTextAndIconAnimation()
}

function copyToClipboard () {
  const input = document.body.appendChild(document.createElement('input'))
  input.value = window.location.href
  input.select()
  document.execCommand('copy')
  input.parentNode.removeChild(input)
}

function changeTextAndIconAnimation () {
  const text = document.getElementById('copyToClipboardButton')
  const originalText = text.innerHTML

  text.innerHTML = `<span style="padding-top: 5px; padding-right: 5px; padding-bottom: 5px;">
        <img src="/images/check.svg">
        </span> Copied`
  setTimeout(function () { text.innerHTML = originalText }, 5000)
}
