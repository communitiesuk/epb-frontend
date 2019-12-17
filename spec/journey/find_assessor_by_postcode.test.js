const { openBrowser, goto, write, into, click, closeBrowser, textBox } = require('taiko');
const { spawn } = require('child_process');

describe('Finding an assessor by postcode', () => {
  let rackup_pid;

  beforeAll(async () => {
    rackup_pid = await new Promise((resolve, reject) => {
      let rackup = spawn('make', ['run']);

      rackup.stderr.on('data', line => {
        if (line.indexOf('port=9292') !== -1) {
          resolve(rackup.pid);
        }
      });
    });
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
    process.kill(rackup_pid, "SIGTERM")
  });
});
