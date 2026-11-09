import { beforeEach, describe, expect, jest, test } from '@jest/globals'
import { screen } from '@testing-library/dom'
import '@testing-library/jest-dom/jest-globals'
import userEvent from '@testing-library/user-event'

function createBanner () {
  document.body.innerHTML = `
    <div class="govuk-cookie-banner" role="region" aria-label="Cookies" hidden>
      <div class="govuk-cookie-banner__message" hidden>
        <h2 class="govuk-cookie-banner__heading govuk-heading-m">Cookies</h2>
        <p>We use some essential cookies to make this service work.</p>

        <button id="accept-button" type="button">
          Accept analytics cookies
        </button>
        <button id="reject-button" type="button">
          Reject analytics cookies
        </button>
        <a href="/cookies">View cookies</a>
      </div>

      <div id="confirmation" class="govuk-cookie-banner__message" role="alert" tabindex="-1" hidden>
        <p class="govuk-body" id="accepted-confirmation" hidden>You’ve accepted analytics cookies</p>
        <p class="govuk-body" id="rejected-confirmation" hidden>You’ve rejected analytics cookies</p>

        <button id="hide-cookie-message">
          Hide cookie message
        </button>
      </div>
    </div>
    <form id="cookies-consent-form">
      <input type="radio" id="cookies-setting" aria-label="Accept cookies">
      <input type="radio" id="cookies-setting-false" aria-label="Reject cookies">
      <input type="submit" value="Save settings">
    </form>
  `
}

beforeEach(() => {
  document.cookie.split(';').forEach((cookie) => {
    document.cookie = `${cookie.trim().split('=')[0]}=; max-age=0`
  })
})

document.addEventListener('submit', (e) => e.preventDefault())

async function initialize () {
  window.GOOGLE_PROPERTY = 'GTM-XXXXXXX'
  window.dataLayer = []
  createBanner()
  await jest.isolateModulesAsync(async () => {
    await import('../cookie-consent')
  })
}

function expectedDatalayer ({ granted }) {
  return [
    ['consent', 'default', { ad_storage: 'denied', analytics_storage: granted ? 'granted' : 'denied' }],
    { event: 'default_consent' }
  ]
}

describe('when cookies have not been accepted or rejected', () => {
  test('does not grant analytics storage permissions', async () => {
    await initialize()
    expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: false }))
  })

  test('grant analytics storage permissions after accepting', async () => {
    await initialize()
    await userEvent.click(screen.getByRole('button', { name: 'Accept analytics cookies' }))
    expect(window.dataLayer).toStrictEqual([
      ...expectedDatalayer({ granted: false }),
      ['consent', 'update', { analytics_storage: 'granted' }]
    ])
    expect(screen.queryByRole('region', { name: 'Cookies' })).toHaveTextContent('You’ve accepted analytics cookies')
    await userEvent.click(screen.getByRole('button', { name: 'Hide cookie message' }))
    expect(screen.queryByRole('region', { name: 'Cookies' })).not.toBeInTheDocument()
    expect(document.cookie).toContain('cookie_consent=true')
  })

  test('does not grant analytics storage permissions after rejecting', async () => {
    await initialize()
    await userEvent.click(screen.getByRole('button', { name: 'Reject analytics cookies' }))
    expect(window.dataLayer).toStrictEqual([
      ...expectedDatalayer({ granted: false }),
      ['consent', 'default', { analytics_storage: 'denied', ad_storage: 'denied' }],
      { event: 'default_consent' }
    ])
    expect(screen.queryByRole('region', { name: 'Cookies' })).toHaveTextContent('You’ve rejected analytics cookies')
    await userEvent.click(screen.getByRole('button', { name: 'Hide cookie message' }))
    expect(screen.queryByRole('region', { name: 'Cookies' })).not.toBeInTheDocument()
    expect(document.cookie).toContain('cookie_consent=false')
  })

  test('deletes ga cookies if storage is rejected', async () => {
    document.cookie = '_gax=foo;'
    await initialize()
    await userEvent.click(screen.getByRole('button', { name: 'Reject analytics cookies' }))
    expect(document.cookie).not.toContain('_gax=')
  })
})

describe('when cookies have previously been accepted', () => {
  test('does grant analytics storage permissions', async () => {
    document.cookie = 'cookie_consent=true;'
    await initialize()
    expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: true }))
  })

  test('does not show the banner', async () => {
    document.cookie = 'cookie_consent=true;'
    await initialize()
    expect(screen.queryByRole('region', { name: 'Cookies' })).not.toBeInTheDocument()
  })
})

describe('when cookies have previously been rejected', () => {
  test('does grant analytics storage permissions', async () => {
    document.cookie = 'cookie_consent=false;'
    await initialize()
    expect(window.dataLayer).toStrictEqual(expectedDatalayer({ granted: false }))
  })

  test('does not show the banner', async () => {
    document.cookie = 'cookie_consent=false;'
    await initialize()
    expect(screen.queryByRole('region', { name: 'Cookies' })).not.toBeInTheDocument()
  })
})

describe('when on the cookie page', () => {
  test('does not show the banner', async () => {
    window.history.pushState({}, '', '/cookies')
    await initialize()
    expect(screen.queryByRole('region', { name: 'Cookies' })).not.toBeInTheDocument()
  })

  test('rejects cookies if the submited with reject cookies', async () => {
    window.history.pushState({}, '', '/cookies')
    await initialize()
    await userEvent.click(screen.getByRole('radio', { name: 'Reject cookies' }))
    await userEvent.click(screen.getByRole('button', { name: 'Save settings' }))
    expect(window.dataLayer).toStrictEqual([
      ...expectedDatalayer({ granted: false }),
      ['consent', 'default', { analytics_storage: 'denied', ad_storage: 'denied' }],
      { event: 'default_consent' }
    ])
    expect(document.cookie).toContain('cookie_consent=false')
  })

  test('accepts cookies if the submited with accept cookies', async () => {
    window.history.pushState({}, '', '/cookies')
    await initialize()
    await userEvent.click(screen.getByRole('radio', { name: 'Accept cookies' }))
    await userEvent.click(screen.getByRole('button', { name: 'Save settings' }))
    expect(document.cookie).toContain('cookie_consent=true')
  })

  test('deletes ga cookies if the submited with reject cookies', async () => {
    document.cookie = '_gax=foo;'
    window.history.pushState({}, '', '/cookies')
    await initialize()
    await userEvent.click(screen.getByRole('radio', { name: 'Reject cookies' }))
    await userEvent.click(screen.getByRole('button', { name: 'Save settings' }))
    expect(document.cookie).not.toContain('_gax=')
  })
})
