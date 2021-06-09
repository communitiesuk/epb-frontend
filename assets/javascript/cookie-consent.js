var cookies = {
  ids: {
    "find-energy-certificate.digital.communities.gov.uk": "G-ZDCS1W2ZRM",
    "getting-new-energy-certificate.digital.communities.gov.uk": "G-TR7Y5Z1GFY",
    "getting-new-energy-certificate.local.gov.uk": "G-TR7Y5Z1GFY",
    "find-energy-certificate.local.gov.uk": "G-ZDCS1W2ZRM",
  },

  initialize: function() {
    var tag_id = cookies.ids[window.location.hostname];
    if(!tag_id) return;

    if(window.location.search.indexOf("cookies-setting=false")!==-1) return;

    let cookie_value = cookies.read("cookie_consent");

    //Get Google Analytics going if consented
    if (cookie_value==="true") {
      cookies.analytics(tag_id);
    }

    // Don't show the cookie banner on the Cookies page and present which option is selected (opt-in style)
    else if (location.pathname === "/cookies") {
      cookies.hideCookieBanner();
    }

    //If we don't have consent or rejection, display cookie question
    else if (cookie_value !== "false") {
      cookies.displayCookieBanner(tag_id);
    }

    // If we're on the cookie page, let's present which option is selected (opt-in style)
    if(location.pathname.indexOf("/cookies")===0) {
      document.getElementById("cookies-setting" + (cookie_value==="true"?"":"-false")).checked = true;
    }
  },

  displayCookieBanner: function(tag_id) {
    cookies.showCookieBanner();

    let acceptButton = document.getElementById("accept-button")
    acceptButton.onclick = function() {
      cookies.create("cookie_consent", "true");

      cookies.analytics(tag_id);

      cookies.hideCookieQuestion();

      cookies.displayConfirmation(true);
    };

    let rejectButton = document.getElementById("reject-button")
    rejectButton.onclick = function() {
      cookies.erase('cookie_consent');

      cookies.create("cookie_consent", "false");

      cookies.hideCookieQuestion();

      cookies.displayConfirmation(false);
    };

    let hideCookieMessageButton = document.getElementById("hide-cookie-message")
    hideCookieMessageButton.onclick = function() {
      cookies.hideCookieBanner();
    }
  },

  showCookieBanner: function() {
    let cookieBanner = document.getElementsByClassName("govuk-cookie-banner")[0];
    cookieBanner.hidden = false;
    let cookieMessage = document.getElementsByClassName("govuk-cookie-banner__message")[0];
    cookieMessage.hidden = false;
  },

  hideCookieQuestion: function() {
    let cookieMessage = document.getElementsByClassName("govuk-cookie-banner__message")[0];
    cookieMessage.hidden = true;
  },

  displayConfirmation: function(consent) {
    let cookieConfirmation = document.getElementById("confirmation");
    cookieConfirmation.hidden = false;

    let id = ""
    if (consent === true) {
      id = "accepted-confirmation";
    } else {
      id = "rejected-confirmation";
    };

    let cookieConfirmationMessage = document.getElementById(id)
    cookieConfirmationMessage.hidden = false;
  },

  hideCookieBanner: function() {
    let cookieBanner = document.getElementsByClassName("govuk-cookie-banner")[0];
    cookieBanner.hidden = true;
  },

  analytics: function(tag_id) {
    //Add Google Analytics script to page
    let data_script = document.createElement("script");
    data_script.src = "https://www.googletagmanager.com/gtag/js?id=" + tag_id;
    document.getElementsByTagName("head")[0].appendChild(data_script);

    //Record visit
    setTimeout(
      function() {
        window.dataLayer = window.dataLayer || [];

        function gtag() {
          dataLayer.push(arguments);
        }

        gtag('js', new Date());
        gtag('config', tag_id);
      },
      100
    );
  },

  create: function (name, value, days = 30) {
    let expires;
    if (days) {
      let date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toUTCString();
    }
    else expires = "";
    document.cookie = name + "=" + value + expires + "; path=/";
  },

  read: function (name) {
    let nameEQ = name + "=";
    let ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) === ' ') c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
  },

  erase: function (name) {
    cookies.create(name, "", -1);
  }
};

window.onload = cookies.initialize;
