export default {
  injectGlobals: false,
  restoreMocks: true,
  testEnvironment: "jsdom",
  testPathIgnorePatterns: [
    '/node_modules/',
    // CI installs gems to /vendor/bundle/, which may contain tests
    '/vendor/',
  ],
  transform: {},
};
