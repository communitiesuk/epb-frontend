/**
 * @jest-environment jsdom
 */
/* eslint-env jest */

import cookieConsent from '../cookie-consent'

const acceptButton = {}

const init = () => {
  callScript()
  window.onload.call()
}

beforeEach(() => {
  window.GOOGLE_PROPERTY = 'GTM-XXXXXXX'
  window.dataLayer = []
})

describe('using GTM (Google Tag Manager)', () => {
  beforeEach(() => {
    window.USE_GTM = true
  })

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
      acceptButton.onclick.call()
    })

    it('has actively denied consent, but additionally actively grants it', () => {
      expect(window.dataLayer).toStrictEqual(
        expectedDatalayer({ granted: false }).concat([['consent', 'update', { analytics_storage: 'granted' }]])
      )
    })
  })
})

describe('using GA (Google Analytics)', () => {
  beforeEach(() => {
    window.USE_GTM = false
  })

  describe('when cookies have not been accepted or rejected', () => {
    beforeEach(init)

    it('does not actively indicate consent status', () => {
      expect(window.dataLayer).toStrictEqual([])
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

    it('does not actively indicate consent status', () => {
      expect(window.dataLayer).toStrictEqual([])
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

    it('does not actively indicate consent status', () => {
      expect(window.dataLayer).toStrictEqual([])
    })
  })
})

function callScript () {
  jest.resetModules()
  const resolvers = {
    cookieBanner: () => ({}),
    cookieMessage: () => ({}),
    cookieConfirmation: () => ({}),
    acceptButton: () => (acceptButton),
    rejectButton: () => ({}),
    hideCookieMessageButton: () => ({}),
    acceptedConfirmationMessage: () => ({}),
    rejectedConfirmationMessage: () => ({})
  }
  const gtag = (...args) => window.dataLayer.push(args)
  cookieConsent(window.USE_GTM, window.GOOGLE_PROPERTY, window, gtag, resolvers)
}

function expectedDatalayer ({ granted }) {
  return [
    ['consent', 'default', { ad_storage: 'denied', analytics_storage: granted ? 'granted' : 'denied' }],
    { event: 'default_consent' }
  ]
}
