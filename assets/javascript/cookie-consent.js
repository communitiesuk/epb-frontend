/* global resolvers */
// above is directive for linter (standard.js to ignore the 'resolvers' global var in this file

const cookieConsent = (tagId, _, gtag, resolvers) => {
  _.dataLayer = _.dataLayer || []

  const cookies = {
    initialize: function () {
      if (!tagId) return

      const location = window.location

      if (location.search.indexOf('cookies-setting=false') !== -1) return

      const cookieValue = cookies.read('cookie_consent')

      const onCookiePage = location.pathname.indexOf('/cookies') === 0

      cookies.signalGtmConsent(cookieValue === 'true')

      if (cookieValue === null && !onCookiePage) {
        // If we don't have consent or rejection, display cookie question
        cookies.displayCookieBanner()
      }

      // If we're on the cookie page, let's present which option is selected (opt-in style)
      if (onCookiePage) {
        document.getElementById('cookies-setting' + (cookieValue === 'true' ? '' : '-false')).checked = true
        cookies.cookieFormHandler()
      }
    },

    displayCookieBanner: function () {
      cookies.showCookieBanner()

      const acceptButton = resolvers.acceptButton()
      acceptButton.addEventListener('click', () => {
        cookies.grantCookieConsent()

        cookies.hideCookieQuestion()

        cookies.displayConfirmation(true)
      })

      const rejectButton = resolvers.rejectButton()
      rejectButton.addEventListener('click', () => {
        cookies.rejectCookieConsent()

        cookies.hideCookieQuestion()

        cookies.displayConfirmation(false)
      })

      const hideCookieMessageButton = resolvers.hideCookieMessageButton()
      hideCookieMessageButton.addEventListener('click', () => {
        cookies.hideCookieBanner()
      })
    },

    showCookieBanner: function () {
      const cookieBanner = resolvers.cookieBanner()
      cookieBanner.hidden = false
      const cookieMessage = resolvers.cookieMessage()
      cookieMessage.hidden = false
    },

    hideCookieQuestion: function () {
      const cookieMessage = resolvers.cookieMessage()
      cookieMessage.hidden = true
    },

    displayConfirmation: function (consent) {
      const cookieConfirmation = resolvers.cookieConfirmation()
      cookieConfirmation.hidden = false

      const messageResolver = consent === true
        ? resolvers.acceptedConfirmationMessage
        : resolvers.rejectedConfirmationMessage

      const cookieConfirmationMessage = messageResolver()
      cookieConfirmationMessage.hidden = false
    },

    hideCookieBanner: function () {
      const cookieBanner = resolvers.cookieBanner()
      cookieBanner.hidden = true
    },

    grantCookieConsent: function () {
      cookies.create('cookie_consent', 'true')

      cookies.enableAnalytics()
    },

    rejectCookieConsent: function () {
      cookies.erase()

      cookies.create('cookie_consent', 'false')

      cookies.signalGtmConsent(false)
    },

    enableAnalytics: function () {
      cookies.updateGtmConsent(true)
    },

    signalGtmConsent: function (isGranted = false) {
      gtag('consent', 'default', {
        ad_storage: 'denied',
        analytics_storage: isGranted ? 'granted' : 'denied'
      })

      _.dataLayer.push({ event: 'default_consent' })
    },

    updateGtmConsent: function (isGranted = false) {
      gtag('consent', 'update', { analytics_storage: isGranted ? 'granted' : 'denied' })
    },

    create: function (name, value) {
      const yearInMilliseconds = 365 * 24 * 60 * 60 * 1000
      const date = new Date()
      date.setTime(date.getTime() + yearInMilliseconds)
      const expires = '; expires=' + date.toUTCString()
      document.cookie = name + '=' + value + expires + '; path=/ ; SameSite=Strict; '
    },

    read: function (name) {
      const nameEQ = name + '='
      const ca = document.cookie.split(';')
      for (let i = 0; i < ca.length; i++) {
        let c = ca[i]
        while (c.charAt(0) === ' ') c = c.substring(1, c.length)
        if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length)
      }
      return null
    },

    erase: function () {
      const cookies = document.cookie.split('; ')

      for (let i = 0; i < cookies.length; i++) {
        if (cookies[i].startsWith('_ga')) {
          const expDate = new Date()
          const name = cookies[i].split('=')[0] + '='
          const value = cookies[i].split('=')[1] + ';'

          const expires = ' expires=' + expDate.toUTCString() + ';'
          const path = ' path=/;'
          let domain
          if (document.domain.includes('communities')) {
            domain = ' domain=' + document.domain.split('.').slice(-3).join('.') + ';'
          } else { domain = ' domain=' + '.' + document.domain + ';' }
          document.cookie = name + value + expires + path + domain
        }
      }
    },

    eraseOnPageChange: function () {
      document.addEventListener('visibilitychange', () => {
        if (document.visibilityState === 'hidden') {
          cookies.erase()
        }
      })
    },

    cookieFormHandler: function () {
      document.getElementById('cookies-consent-form').addEventListener('submit', cookies.cookieFormOnSubmit)
    },

    cookieFormOnSubmit: function () {
      if (document.getElementById('cookies-setting').checked === true) { cookies.create('cookie_consent', 'true') } else { cookies.rejectCookieConsent() } return true
    }
  }

  _.onload = cookies.initialize

  return cookies
}

export default cookieConsent

if (typeof window !== 'undefined') {
  window.cookies = cookieConsent(
    window.GOOGLE_PROPERTY,
    window,
    window.gtag || function (...args) {
      window.dataLayer = window.dataLayer || []
      window.dataLayer.push(args)
    },
    typeof resolvers !== 'undefined'
      ? resolvers
      : {
          cookieBanner: () => document.getElementsByClassName('govuk-cookie-banner')[0],
          cookieMessage: () => document.getElementsByClassName('govuk-cookie-banner__message')[0],
          cookieConfirmation: () => document.getElementById('confirmation'),
          acceptButton: () => document.getElementById('accept-button'),
          rejectButton: () => document.getElementById('reject-button'),
          hideCookieMessageButton: () => document.getElementById('hide-cookie-message'),
          acceptedConfirmationMessage: () => document.getElementById('accepted-confirmation'),
          rejectedConfirmationMessage: () => document.getElementById('rejected-confirmation')
        }
  )
}
