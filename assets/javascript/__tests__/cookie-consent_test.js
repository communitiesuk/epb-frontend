/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

import cookieConsent from '../cookie-consent'

const acceptButton = document.createElement('button')

const init = () => {
  callScript()
  window.onload.call()
}

beforeEach(() => {
  window.GOOGLE_PROPERTY = 'GTM-XXXXXXX'
  window.dataLayer = []
})

describe('using GTM (Google Tag Manager)', () => {
  describe('when cookies have not been accepted or rejected', () => {
    beforeEach(init)

    it('actively denies consent', () => {
      expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: false }))
    })
  })

  describe('when cookies have been accepted', () => {
    beforeEach(() => {
      Object.defineProperty(window.document, 'cookie', {
        writable: true,
        value: 'cookie_consent=true'
      })
      init()
    })

    it('actively grants consent', () => {
      expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: true }))
    })
  })

  describe('when cookies have been rejected', () => {
    beforeEach(() => {
      Object.defineProperty(window.document, 'cookie', {
        writable: true,
        value: 'cookie_consent=false'
      })
      init()
    })

    it('actively denies consent', () => {
      expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: false }))
    })
  })

  describe('when cookies have not been accepted or rejected, but are accepted from user clicking acceptance', () => {
    beforeEach(() => {
      init()
      const clickEvent = new MouseEvent('click', { view: window, bubbles: true, cancelable: false })
      acceptButton.dispatchEvent(clickEvent)
    })

    it('has actively denied consent, but additionally actively grants it', () => {
      expect(window.dataLayer).toStrictEqual(
        expectedDatalayer({ granted: false }).concat([['consent', 'update', { analytics_storage: 'granted' }]])
      )
    })
  })
})

describe('when calling the reject cookie function to remove _ga* cookies  ', () => {
  beforeEach(() => {
    Object.defineProperty(window.document, 'cookie', {
      writable: true,
      value: '_ga=12345; ga_123458=458489489'
    })

    Object.defineProperty(window.document, 'domain', {
      writable: true,
      value: '.find-energy-certificate.service.gov.uk'
    })
    init()
    const gtag = (...args) => window.dataLayer.push(args)
    const objCookie = cookieConsent(window.GOOGLE_PROPERTY, window, gtag)
    objCookie.rejectCookieConsent()
  })
  afterEach(() => {
    window.dataLayer = []
  })

  it('removes all cookies that starts with _ga', () => {
    expect(window.document.cookie).not.toContain('_ga')
  })

  it('set the cookie_consent cookie to false', () => {
    expect(window.document.cookie).toContain('cookie_consent=false')
  })
})

function callScript () {
  jest.resetModules()
  const resolvers = {
    cookieBanner: () => ({}),
    cookieMessage: () => ({}),
    cookieConfirmation: () => ({}),
    acceptButton: () => (acceptButton),
    rejectButton: () => (document.createElement('button')),
    hideCookieMessageButton: () => (document.createElement('button')),
    acceptedConfirmationMessage: () => ({}),
    rejectedConfirmationMessage: () => ({})
  }
  const gtag = (...args) => window.dataLayer.push(args)
  cookieConsent(window.GOOGLE_PROPERTY, window, gtag, resolvers)
}

function expectedDatalayer ({ granted }) {
  return [
    ['consent', 'default', { ad_storage: 'denied', analytics_storage: granted ? 'granted' : 'denied' }],
    { event: 'default_consent' }
  ]
}
