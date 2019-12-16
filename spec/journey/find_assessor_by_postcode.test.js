const { openBrowser, goto, write, into, click, closeBrowser, textBox } = require('taiko');

describe('Finding an assessor by postcode', () => {
  beforeAll(async () => {
    await openBrowser();
  });

  it('finds an assessor by postcode', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
  }, 30000);

  afterAll(async () => {
    await closeBrowser();
  });
});
