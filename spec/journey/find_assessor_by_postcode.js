const { openBrowser, goto, write, into, click, closeBrowser, textBox } = require('taiko');

(async () => {
  try {
    await openBrowser();
    await goto("localhost:9292");
    await click("Start now");
    await write('SW1A 2AA', into(textBox( 'postcode')))
    await click('Find')
  } catch (error) {
    console.error(error);
  } finally {
    await closeBrowser();
  }
})();
