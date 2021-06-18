const dayInMilliseconds = 24*60*60*1000

console.log('loading cookie consent script');
console.log('cookies at script load: ' + document.cookie);

const cookies = {
  ids: {
    'find-energy-certificate.digital.communities.gov.uk': 'G-ZDCS1W2ZRM',
    'getting-new-energy-certificate.digital.communities.gov.uk': 'G-TR7Y5Z1GFY',
    'getting-new-energy-certificate.local.gov.uk': 'G-TR7Y5Z1GFY',
    'find-energy-certificate.epb-frontend': 'G-ZDCS1W2ZRM'
  },

  initialize: function () {
    const location = window.location
    const tagId = cookies.ids[window.location.hostname]
    if (!tagId) return

    if (location.search.indexOf('cookies-setting=false') !== -1) return

    const cookieValue = cookies.read('cookie_consent')

    console.log("cookie value is " + cookieValue);

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
      cookies.erase()

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
    console.log('including analytics js');
    // Add Google Analytics script to page
    const dataScript = document.createElement('script')
    dataScript.src = 'https://www.googletagmanager.com/gtag/js?id=' + tagId
    document.getElementsByTagName('head')[0].appendChild(dataScript)

    // Record visit
    setTimeout(
      function () {
        window.dataLayer = window.dataLayer || []

        function gtag () {
          window.dataLayer.push(arguments)
        }

        gtag('js', new Date())
        gtag('config', tagId, {
          cookie_expires: 31536000,
        });
      },
      100
    )
  },

  create: function (name, value, days = 30) {
    let expires
    if (days) {
      const date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = '; expires=' + date.toUTCString()
    } else expires = ''
    document.cookie = name + '=' + value + expires + '; path=/'
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
    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push(function() {
      this.reset()
    })

    const cookies = document.cookie.split('; ')

    for (let i = 0; i < cookies.length; i++) {
      if (cookies[i].startsWith('_ga')) {
        let expDate = new Date()
        expDate.setTime(expDate.getTime() - dayInMilliseconds)
        const name = cookies[i].split('=')[0] + '='
        const value = cookies[i].split('=')[1] + ';'

        const expires = ' expires=' + expDate.toUTCString() + ';'
        const path = ' path=/;'
        const domain = ' domain=.' + document.domain.split('.').slice(-3).join('.') + ';'

        console.log(name + value + expires + path + domain);

        document.cookie = name + value + expires + path + domain

        console.log(document.cookie);
      }
    }
    document.cookie = 'cookie_consent=false;path=/'
  }
}

window.onload = cookies.initialize

const getState = () => {
  if (document.visibilityState === 'hidden') {
    return 'hidden';
  }
  if (document.hasFocus()) {
    return 'active';
  }
  return 'passive';
};

// Stores the initial state using the `getState()` function (defined above).
let state = getState();

// Accepts a next state and, if there's been a state change, logs the
// change to the console. It also updates the `state` value defined above.
const logStateChange = (nextState) => {
  const prevState = state;
  if (nextState !== prevState) {
    console.log(`State change: ${prevState} >>> ${nextState}`);
    console.log(`Cookies at state change: ${document.cookie}`);
    state = nextState;
  }
};

// These lifecycle events can all use the same listener to observe state
// changes (they call the `getState()` function to determine the next state).
['pageshow', 'focus', 'blur', 'visibilitychange', 'resume'].forEach((type) => {
  window.addEventListener(type, () => logStateChange(getState()), {capture: true});
});

// The next two listeners, on the other hand, can determine the next
// state from the event itself.
window.addEventListener('freeze', () => {
  // In the freeze event, the next state is always frozen.
  logStateChange('frozen');
}, {capture: true});

window.addEventListener('pagehide', (event) => {
  if (event.persisted) {
    // If the event's persisted property is `true` the page is about
    // to enter the Back-Forward Cache, which is also in the frozen state.
    logStateChange('frozen');
  } else {
    // If the event's persisted property is not `true` the page is
    // about to be unloaded.
    logStateChange('terminated');
  }
}, {capture: true});

document.addEventListener('visibilitychange', function () {
  console.log('document visibility changed to: ' + document.visibilityState);
  console.log('cookies after visibility change: ' + document.cookie);
  // if (document.visibilityState === 'hidden' && cookies.read('cookie_consent') === 'false') {
  //   cookies.erase();
  // }
})

document.addEventListener('resume', function () {
  console.log('a resume happened')
})
