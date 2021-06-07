var cookies = {
  ids: {
    "find-energy-certificate.digital.communities.gov.uk": "G-ZDCS1W2ZRM",
    "getting-new-energy-certificate.digital.communities.gov.uk": "G-TR7Y5Z1GFY",
    "getting-new-energy-certificate.local.gov.uk": "G-TR7Y5Z1GFY",
    "find-energy-certificate.local.gov.uk": "G-ZDCS1W2ZRM",
  },

  texts: {
    title: {
      en: "Cookies on ",
      cy: "Cwcis ar "
    },
    intro_essential: {
      en: "We use some essential cookies to make this service work.",
      cy: "Rydym yn defnyddio cwcis hanfodol i wneud i'r gwasanaeth hwn weithio."
    },
    intro_analytics: {
      en: "We’d also like to use analytics cookies so we can understand how you use the service and make improvements.",
      cy: "Fe hoffen ni ddefnyddio cwcis dadansoddeg hefyd, er mwyn deall sut rydych chi'n defnyddio'r gwasanaeth a gwneud gwelliannau."
    },
    positive: {
      en: "Accept analytics cookies",
      cy: "Derbyn cwcis dadansoddeg"
    },
    negative: {
      en: "Reject analytics cookies",
      cy: "Gwrthod cwcis dadansoddeg"
    },
    view_cookies: {
      en: "View cookies",
      cy: "Gweld y cwci"
    }
  },

  initialize: function() {
    var tag_id = cookies.ids[window.location.hostname];
    if(!tag_id) return;

    if(window.location.search.indexOf("cookies-setting=false")!==-1) return;

    let cookie_value = cookies.read("cookie_consent");

    //Get Google Analytics going if consented
    if(cookie_value==="true") {
      cookies.analytics(tag_id);
    }

    //If we don't have consent/rejection, and we're at start page, display cookie question
    else if(cookie_value!=="false" && location.pathname==="/") {
      cookies.display(tag_id);
    }

    //If we're on the cookie page, let's present which option is selected (opt-in style)
    if(location.pathname.indexOf("/cookies")===0) {
      document.getElementById("cookies-setting" + (cookie_value==="true"?"":"-false")).checked = true;
    }
  },

  display: function(tag_id) {
    let lang = document.getElementsByTagName("html")[0].getAttribute("lang");
    let serviceName = document.getElementsByClassName("govuk-header__link--service-name")[0].textContent

    let rootElement = document.createElement("div");
    rootElement.className = "govuk-cookie-banner govuk-!-display-none-print";
    rootElement.ariaLabel = cookies.texts.title[lang] + serviceName;
    rootElement.setAttribute("role", "region");
    rootElement.setAttribute("data-nosnippet", "true");

    let cookieBannerMessage = document.createElement("div");
    cookieBannerMessage.className = "govuk-cookie-banner__message govuk-width-container";

    let gridRow = document.createElement("div");
    gridRow.className = "govuk-grid-row";

    let gridColumn = document.createElement("div");
    gridColumn.className = "govuk-grid-column-two-thirds";

    let title = document.createElement("h2");
    title.innerHTML = cookies.texts.title[lang] + serviceName;
    title.className = "govuk-cookie-banner__heading govuk-heading-m";

    let cookieBannerContent = document.createElement("div");
    cookieBannerContent.className = "govuk-cookie-banner__content";

    let bodyEssential = document.createElement("p");
    bodyEssential.innerHTML = cookies.texts.intro_essential[lang];

    let bodyAnalytics = document.createElement("p");
    bodyAnalytics.innerHTML = cookies.texts.intro_analytics[lang];

    let buttonGroup = document.createElement("div");
    buttonGroup.className = "govuk-button-group";

    let consentButton = document.createElement("button");
    consentButton.className = "govuk-button";
    consentButton.innerHTML = cookies.texts.positive[lang];
    consentButton.onclick = function() {
      cookies.create("cookie_consent", "true");

      cookies.analytics(tag_id);

      let cookieBanner = document.getElementsByClassName("govuk-cookie-banner")[0];
      cookieBanner.hidden = true;
    };

    let rejectButton = document.createElement("a");
    rejectButton.className = "govuk-button";
    rejectButton.href = "/cookies" + (lang !== "en" ? "?lang=" + lang : "");
    rejectButton.innerHTML = cookies.texts.negative[lang];

    let viewCookiesLink = document.createElement("a");
    viewCookiesLink.className = "govuk-link";
    viewCookiesLink.href = "/cookies" + (lang !== "en" ? "?lang=" + lang : "");
    viewCookiesLink.innerHTML = cookies.texts.view_cookies[lang];

    cookieBannerMessage.appendChild(gridRow);
      gridRow.appendChild(gridColumn);
        gridColumn.appendChild(title);
        gridColumn.appendChild(cookieBannerContent);
          cookieBannerContent.appendChild(bodyEssential);
          cookieBannerContent.appendChild(bodyAnalytics);

    cookieBannerMessage.appendChild(buttonGroup);
      buttonGroup.appendChild(consentButton);
      buttonGroup.appendChild(rejectButton);
      buttonGroup.appendChild(viewCookiesLink);

    rootElement.appendChild(cookieBannerMessage);

    let body = document.getElementsByClassName("govuk-template__body")[0];

    body.insertBefore(rootElement, body.firstChild);
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
