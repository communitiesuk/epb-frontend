/**
 * @jest-environment jsdom
 */
/* eslint-env jest */
import { translate_welsh, getUrlParameter } from '../service-performance.js'

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
    '<div>' +
    '<button id="button_1" type="button" class="govuk-accordion__open-all" aria-expanded="false" />Open all' +
    '</button>' +
    '<button id="button_2" type="button" class="govuk-accordion__open-all" aria-expanded="false"/>Open all' +
    '</button>' +
    '</div>';

});
afterEach(() => {
  window.location = savedLocation;
});


test('gets the language from the query string', () => {
  expect(getUrlParameter("lang")).toBe('cy');
});

test('the text of the open all buttons is translated into Welsh', () =>{
  translate_welsh()
  expect(document.getElementById("button_1").innerText).toBe("Agor pob adran");
  expect(document.getElementById("button_2").innerText).toBe("Agor pob adran");
});

test('the buttons have the event to change to Welsh', () =>{
  translate_welsh();
  let button =   document.getElementById("button_1");
  button.ariaExpanded = true;
  button.click()
  expect(button.innerText).toBe("Agor pob adran");
});

test('returns null when no lang present in the query string', () => {
  delete window.location;
  window.location = Object.assign(new URL("http://find-energy-certificate.epb-frontend/service-performance"), {
    ancestorOrigins: "",
    assign: jest.fn(),
    reload: jest.fn(),
    replace: jest.fn()
  });
  expect(getUrlParameter("lang")).toBe("");
});
