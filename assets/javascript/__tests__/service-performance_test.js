/**
 * @jest-environment jsdom
 */
/* eslint-env jest */


import { translate_welsh, updateText, getUrlParameter } from '../service-performance.js'

const savedLocation = window.location;


beforeEach(() => {
  delete window.location;
  window.location = Object.assign(new URL("http://find-energy-certificate.epb-frontend/service-performance?lang=cy"), {
    ancestorOrigins: "",
    assign: jest.fn(),
    reload: jest.fn(),
    replace: jest.fn()
  });
});
afterEach(() => {
  window.location = savedLocation;
});


test('get the lang from the query string', () => {
  expect(getUrlParameter("lang")).toBe('cy');
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

