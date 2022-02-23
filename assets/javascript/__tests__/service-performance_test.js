/**
 * @jest-environment jsdom
 */
/* eslint-env jest */
import { init_buttons, getUrlParameter } from '../service-performance.js'
describe('when rendering service performance in Welsh', () => {
  const savedLocation = window.location;

  beforeEach(() => {
    delete window.location;
    window.location = Object.assign(new URL("http://find-energy-certificate.epb-frontend/service-performance?lang=cy"), {
      ancestorOrigins: "",
      assign: jest.fn(),
      reload: jest.fn(),
      replace: jest.fn()
    });

    document.body.innerHTML =
      '<h2 class="govuk-heading-l">Data domestig – adeilad presennol (RdSAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-rdsap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_1" type="button" class="govuk-accordion__open-all" aria-expanded="false">Open all<span class="govuk-visually-hidden"> sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        Heading' +
      '      </h2>' +
      '    </div>' +
      '    <div id="accordion-rdsap-content-0" class="govuk-accordion__section-content">' +
      '      <p class="govuk-body"> </p>' +
      '      <div id="rdsap" class="govuk-body">' +
      '        Content' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</div>' +
      '' +
      '<h2 class="govuk-heading-l">Data domestig – adeilad newydd (SAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-sap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_2" type="button" class="govuk-accordion__open-all" aria-expanded="false">Open all<span class="govuk-visually-hidden"> sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        Heading' +
      '      </h2>' +
      '    </div>' +
      '    <div id="accordion-sap-content-0" class="govuk-accordion__section-content">' +
      '      <p class="govuk-body"> </p>' +
      '      <div id="sap" class="govuk-body">' +
      '        Content' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</div>'

  });
  afterEach(() => {
    window.location = savedLocation;
  });

  test('gets the language from the query string', () => {
    expect(getUrlParameter("lang")).toBe('cy');
  });

  test('the text of the open all buttons is translated into Welsh', () =>{
    init_buttons();
    expect(document.getElementById("button_1").innerHTML).toBe(`Agor pob adran <span class="govuk-visually-hidden">sy'n ymwneud â Data domestig – adeilad presennol (RdSAP)</span>`);
    expect(document.getElementById("button_2").innerHTML).toBe(`Agor pob adran <span class="govuk-visually-hidden">sy'n ymwneud â Data domestig – adeilad newydd (SAP)</span>`);
  });

  test('the buttons have the event to change to Welsh', () =>{
    init_buttons();
    let button =   document.getElementById("button_1");
    button.ariaExpanded = true;
    button.click()
    expect(button.innerHTML).toBe(`Agor pob adran <span class="govuk-visually-hidden">sy'n ymwneud â Data domestig – adeilad presennol (RdSAP)</span>`);
  });
})

describe('when rendering service performance in English', () => {
  const savedLocation = window.location;

  beforeEach(() => {
    delete window.location;
    window.location = Object.assign(new URL("http://find-energy-certificate.epb-frontend/service-performance"), {
      ancestorOrigins: "",
      assign: jest.fn(),
      reload: jest.fn(),
      replace: jest.fn()
    });

    document.body.innerHTML =
      '<h2 class="govuk-heading-l">Domestic data – existing building (RdSAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-rdsap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_1" type="button" class="govuk-accordion__open-all" aria-expanded="false">Open all<span class="govuk-visually-hidden"> sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        Heading' +
      '      </h2>' +
      '    </div>' +
      '    <div id="accordion-rdsap-content-0" class="govuk-accordion__section-content">' +
      '      <p class="govuk-body"> </p>' +
      '      <div id="rdsap" class="govuk-body">' +
      '        Content' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</div>' +
      '' +
      '<h2 class="govuk-heading-l">Domestic data – new building (SAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-sap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_2" type="button" class="govuk-accordion__open-all" aria-expanded="false">Open all<span class="govuk-visually-hidden"> sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        Heading' +
      '      </h2>' +
      '    </div>' +
      '    <div id="accordion-sap-content-0" class="govuk-accordion__section-content">' +
      '      <p class="govuk-body"> </p>' +
      '      <div id="sap" class="govuk-body">' +
      '        Content' +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '</div>'

  });
  afterEach(() => {
    window.location = savedLocation;
  });

  test('gets the language from the query string', () => {
    expect(getUrlParameter("lang")).toBeFalsy();
  });

  test('the text of the open all buttons is translated', () =>{
    init_buttons();
    expect(document.getElementById("button_1").innerHTML).toBe(`Open all <span class="govuk-visually-hidden">sections related to Domestic data – existing building (RdSAP)</span>`);
    expect(document.getElementById("button_2").innerHTML).toBe(`Open all <span class="govuk-visually-hidden">sections related to Domestic data – new building (SAP)</span>`);
  });

  test('the buttons have the event to change', () =>{
    init_buttons();
    let button =   document.getElementById("button_1");
    button.ariaExpanded = true;
    button.click()
    expect(button.innerHTML).toBe(`Open all <span class="govuk-visually-hidden">sections related to Domestic data – existing building (RdSAP)</span>`);
  });
})
