var cookies = {
  ids: {
    "find-energy-certificate.digital.communities.gov.uk": "G-ZDCS1W2ZRM",
    "getting-new-energy-certificate.digital.communities.gov.uk": "G-TR7Y5Z1GFY",
    "getting-new-energy-certificate.local.gov.uk": "G-TR7Y5Z1GFY",
    "find-energy-certificate.local.gov.uk": "G-ZDCS1W2ZRM",
  },

  texts: {
    title: {
      en: "Tell us whether you accept cookies",
      cy: "Dywedwch a ydych chi'n derbyn cwcis."
    },
    intro: {
      en: "We use cookies to collect information about how you use this service. This helps us to improve our website and make it work as well as possible.",
      cy: "Rydyn ni’n defnyddio cwcis i gasglu gwybodaeth am sut rydych chi’n defnyddio'r gwasanaeth hwn. Mae hyn yn ein helpu i wella’n gwefan a gwneud iddi weithio cystal â phosibl."
    },
    positive: {
      en: "Accept all cookies",
      cy: "Derbyn pob cwci"
    },
    negative: {
      en: "Set cookie preferences",
      cy: "Gosod dewisiadau cwcis"
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

    let rootElement = document.createElement("div");
    rootElement.className = "cookie-consent-box";

    let innerBox = document.createElement("div");
    innerBox.className = "inner-box";

    let title = document.createElement("p");
    title.innerHTML = cookies.texts.title[lang];
    title.className = "govuk-heading-m";

    let body = document.createElement("p");
    body.innerHTML = cookies.texts.intro[lang];
    body.className = "govuk-body";

    let consent_button = document.createElement("a");
    consent_button.className = "govuk-button consent";
    consent_button.innerHTML = cookies.texts.positive[lang];
    consent_button.onclick = function() {
      cookies.create("cookie_consent", "true");

      cookies.analytics(tag_id);

      this.parentNode.parentNode.classList.add("hidden");
    };

    let reject_button = document.createElement("a");
    reject_button.className = "govuk-button reject";
    reject_button.href = "/cookies" + (lang !== "en" ? "?lang=" + lang : "");
    reject_button.innerHTML = cookies.texts.negative[lang];

    innerBox.appendChild(title);
    innerBox.appendChild(body);
    innerBox.appendChild(consent_button);
    innerBox.appendChild(reject_button);

    rootElement.appendChild(innerBox);

    let row = document.getElementsByClassName("govuk-grid-row")[0];

    row.insertBefore(rootElement, row.firstChild);
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
