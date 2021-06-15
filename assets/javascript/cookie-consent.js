var cookies = {
  ids: {
    'find-energy-certificate.digital.communities.gov.uk': 'G-ZDCS1W2ZRM',
    'getting-new-energy-certificate.digital.communities.gov.uk': 'G-TR7Y5Z1GFY',
    'getting-new-energy-certificate.local.gov.uk': 'G-TR7Y5Z1GFY',
    'find-energy-certificate.local.gov.uk': 'G-ZDCS1W2ZRM'
  },

  initialize: function () {
    const location = window.location
    var tagId = cookies.ids[window.location.hostname]
    if (!tagId) return

    if (location.search.indexOf('cookies-setting=false') !== -1) return

    const cookieValue = cookies.read('cookie_consent')

    // Get Google Analytics going if consented
    if (cookieValue === 'true') {
      cookies.analytics(tagId)
    } else if (location.pathname === '/cookies') {
      // Don't show the cookie banner on the Cookies page and present which option is selected (opt-in style)
      cookies.hideCookieBanner()
    } else if (cookieValue !== 'false') {
      // If we don't have consent or rejection, display cookie question
      cookies.displayCookieBanner(tagId)
    }

    // If we're on the cookie page, let's present which option is selected (opt-in style)
    if (location.pathname.indexOf('/cookies') === 0) {
      document.getElementById('cookies-setting' + (cookieValue === 'true' ? '' : '-false')).checked = true
    }
  },

  displayCookieBanner: function (tagId) {
    cookies.showCookieBanner()

    const acceptButton = document.getElementById('accept-button')
    acceptButton.onclick = function () {
      cookies.create('cookie_consent', 'true')

      cookies.analytics(tagId)

      cookies.hideCookieQuestion()

      cookies.displayConfirmation(true)
    }

    const rejectButton = document.getElementById('reject-button')
    rejectButton.onclick = function () {
      cookies.erase('cookie_consent')

      cookies.create('cookie_consent', 'false')

      cookies.hideCookieQuestion()

      cookies.displayConfirmation(false)
    }

    const hideCookieMessageButton = document.getElementById('hide-cookie-message')
    hideCookieMessageButton.onclick = function () {
      cookies.hideCookieBanner()
    }
  },

  showCookieBanner: function () {
    const cookieBanner = document.getElementsByClassName('govuk-cookie-banner')[0]
    cookieBanner.hidden = false
    const cookieMessage = document.getElementsByClassName('govuk-cookie-banner__message')[0]
    cookieMessage.hidden = false
  },

  hideCookieQuestion: function () {
    const cookieMessage = document.getElementsByClassName('govuk-cookie-banner__message')[0]
    cookieMessage.hidden = true
  },

  displayConfirmation: function (consent) {
    const cookieConfirmation = document.getElementById('confirmation')
    cookieConfirmation.hidden = false

    let id = ''
    if (consent === true) {
      id = 'accepted-confirmation'
    } else {
      id = 'rejected-confirmation'
    };

    const cookieConfirmationMessage = document.getElementById(id)
    cookieConfirmationMessage.hidden = false
  },

  hideCookieBanner: function () {
    const cookieBanner = document.getElementsByClassName('govuk-cookie-banner')[0]
    cookieBanner.hidden = true
  },

  analytics: function (tagId) {
    // Add Google Analytics script to page
    const dataScript = document.createElement('script')
    dataScript.src = 'https://www.googletagmanager.com/gtag/js?id=' + tagId
    document.getElementsByTagName('head')[0].appendChild(dataScript)

    // Record visit
    setTimeout(
      function () {
        window.dataLayer = window.dataLayer || []

        function gtag () {
          dataLayer.push(arguments)
        }

        gtag('js', new Date())
        gtag('config', tagId)
      },
      100
    )
  },

  create: function (name, value, days = 30) {
    let expires
    if (days) {
      let date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = '; expires=' + date.toUTCString()
    }
    else expires = ''
    document.cookie = name + "=" + value + expires + "; path=/"
  },

  read: function (name) {
    const nameEQ = name + '='
    const ca = document.cookie.split(';')
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i]
      while (c.charAt(0) === ' ') c = c.substring(1, c.length)
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length)
    }
    return null
  },

  erase: function(name) {
    var cookies =document.cookie.split('; ')

    for (var i = 0; i < cookies.length; i++) {
        if (cookies[i].startsWith('_ga')){
          var expDate = new Date()
          var name = cookies[i].split("=")[0] + "="
          var value = cookies[i].split("=")[1] + ";"

          var expires = " expires=" + expDate.toUTCString() + ";"
          var path = " path=/;"
          var domain = " domain=" + document.domain.split('.').slice(-3).join('.') + ";"

          document.cookie = name + value + expires + path + domain
        }
    }
  document.cookie = 'cookie_consent=false;'
  }
}

window.onload = cookies.initialize
