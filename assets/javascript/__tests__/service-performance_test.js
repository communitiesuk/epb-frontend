/**
 * @jest-environment jsdom
 */
/* eslint-env jest */
import { initButtons, getUrlParameter } from '../service-performance.js'
describe('when rendering service performance in Welsh', () => {
  const savedLocation = window.location

  beforeEach(() => {
    delete window.location
    window.location = Object.assign(new URL('http://find-energy-certificate.epb-frontend/service-performance?lang=cy'), {
      ancestorOrigins: '',
      assign: jest.fn(),
      reload: jest.fn(),
      replace: jest.fn()
    })

    document.body.innerHTML =
      '<h2 class="govuk-heading-l">Data domestig – adeilad presennol (RdSAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-rdsap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_1" type="button" class="govuk-accordion__show-all" aria-expanded="false">' +
      '      <span class="govuk-accordion-nav__chevron"></span><span class="govuk-accordion__show-all-text">Dangos pob adran</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        <button class="govuk-accordion__section-button" type="button" aria-expanded="false" id="button-section_1">' +
      '          <span class="govuk-accordion__section-heading-text">' +
      '            <span class="govuk-accordion__section-heading-text-focus">Heading</span>' +
      '          </span>' +
      '          <span class="govuk-visually-hidden govuk-accordion__section-heading-divider">, </span>' +
      '          <span class="govuk-accordion__section-toggle">' +
      '            <span class="govuk-accordion__section-toggle-focus">' +
      '              <span class="govuk-accordion-nav__chevron govuk-accordion-nav__chevron--down"></span>' +
      '              <span class="govuk-accordion__section-toggle-text">' +
      '                Dangos<span class="govuk-visually-hidden"> yr adran hon</span>' +
      '              </span>' +
      '            </span>' +
      '          </span>' +
      '        </button>' +
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
      '    <button id="button_2" type="button" class="govuk-accordion__show-all" aria-expanded="false">' +
      '      <span class="govuk-accordion-nav__chevron"></span><span class="govuk-accordion__show-all-text">Dangos pob adran</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        <button class="govuk-accordion__section-button" type="button" aria-expanded="false" id="button-section_2">' +
      '          <span class="govuk-accordion__section-heading-text">' +
      '            <span class="govuk-accordion__section-heading-text-focus">Heading</span>' +
      '          </span>' +
      '          <span class="govuk-visually-hidden govuk-accordion__section-heading-divider">, </span>' +
      '          <span class="govuk-accordion__section-toggle">' +
      '            <span class="govuk-accordion__section-toggle-focus">' +
      '              <span class="govuk-accordion-nav__chevron govuk-accordion-nav__chevron--down"></span>' +
      '              <span class="govuk-accordion__section-toggle-text">' +
      '                Dangos<span class="govuk-visually-hidden"> yr adran hon</span>' +
      '              </span>' +
      '            </span>' +
      '          </span>' +
      '        </button>' +
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
  })
  afterEach(() => {
    window.location = savedLocation
  })

  test('gets the language from the query string', () => {
    expect(getUrlParameter('lang')).toBe('cy')
  })

  test('the text of the open all buttons is translated into Welsh', () => {
    initButtons()
    expect(document.getElementById('button_1').querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Dangos pob adran <span class="govuk-visually-hidden">sy’n ymwneud â Data domestig – adeilad presennol (RdSAP)</span>')
    expect(document.getElementById('button_2').querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Dangos pob adran <span class="govuk-visually-hidden">sy’n ymwneud â Data domestig – adeilad newydd (SAP)</span>')
  })

  test('the button for the show all action is triggered to change to Welsh', () => {
    initButtons()
    const button = document.getElementById('button_1')
    button.ariaExpanded = true
    button.click()
    expect(button.querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Dangos pob adran <span class="govuk-visually-hidden">sy’n ymwneud â Data domestig – adeilad presennol (RdSAP)</span>')
  })
})

describe('when rendering service performance in English', () => {
  const savedLocation = window.location

  beforeEach(() => {
    delete window.location
    window.location = Object.assign(new URL('http://find-energy-certificate.epb-frontend/service-performance'), {
      ancestorOrigins: '',
      assign: jest.fn(),
      reload: jest.fn(),
      replace: jest.fn()
    })

    document.body.innerHTML =
      '<h2 class="govuk-heading-l">Domestic data – existing building (RdSAP)</h2>' +
      '<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-rdsap">' +
      '  <div class="govuk-accordion__controls">' +
      '    <button id="button_1" type="button" class="govuk-accordion__show-all" aria-expanded="false">' +
      '      <span class="govuk-accordion-nav__chevron"></span><span class="govuk-accordion__show-all-text">Show all sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        <button class="govuk-accordion__section-button" type="button" aria-expanded="false" id="button-section_1">' +
      '          <span class="govuk-accordion__section-heading-text">' +
      '            <span class="govuk-accordion__section-heading-text-focus">Heading</span>' +
      '          </span>' +
      '          <span class="govuk-visually-hidden govuk-accordion__section-heading-divider">, </span>' +
      '          <span class="govuk-accordion__section-toggle">' +
      '            <span class="govuk-accordion__section-toggle-focus">' +
      '              <span class="govuk-accordion-nav__chevron govuk-accordion-nav__chevron--down"></span>' +
      '              <span class="govuk-accordion__section-toggle-text">' +
      '                Show<span class="govuk-visually-hidden"> this section</span>' +
      '              </span>' +
      '            </span>' +
      '          </span>' +
      '        </button>' +
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
      '    <button id="button_2" type="button" class="govuk-accordion__show-all" aria-expanded="false" id="button-section_2">' +
      '      <span class="govuk-accordion-nav__chevron"></span><span class="govuk-accordion__show-all-text">Show all sections</span>' +
      '    </button>' +
      '  </div>' +
      '  <div class="govuk-accordion__section">' +
      '    <div class="govuk-accordion__section-header">' +
      '      <h2 class="govuk-accordion__section-heading">' +
      '        <button class="govuk-accordion__section-button" type="button" aria-expanded="false">' +
      '          <span class="govuk-accordion__section-heading-text">' +
      '            <span class="govuk-accordion__section-heading-text-focus">Heading</span>' +
      '          </span>' +
      '          <span class="govuk-visually-hidden govuk-accordion__section-heading-divider">, </span>' +
      '          <span class="govuk-accordion__section-toggle">' +
      '            <span class="govuk-accordion__section-toggle-focus">' +
      '              <span class="govuk-accordion-nav__chevron govuk-accordion-nav__chevron--down"></span>' +
      '              <span class="govuk-accordion__section-toggle-text">' +
      '                Show<span class="govuk-visually-hidden"> this section</span>' +
      '              </span>' +
      '            </span>' +
      '          </span>' +
      '        </button>' +
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
  })
  afterEach(() => {
    window.location = savedLocation
  })

  test('gets the language from the query string', () => {
    expect(getUrlParameter('lang')).toBeFalsy()
  })

  test('the text of the open all buttons is translated', () => {
    initButtons()
    expect(document.getElementById('button_1').querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Show all sections <span class="govuk-visually-hidden">related to Domestic data – existing building (RdSAP)</span>')
    expect(document.getElementById('button_2').querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Show all sections <span class="govuk-visually-hidden">related to Domestic data – new building (SAP)</span>')
  })

  test('the buttons have the event to change', () => {
    initButtons()
    const button = document.getElementById('button_1')
    button.ariaExpanded = true
    button.click()
    expect(button.querySelector('.govuk-accordion__show-all-text').innerHTML).toBe('Show all sections <span class="govuk-visually-hidden">related to Domestic data – existing building (RdSAP)</span>')
  })
})
