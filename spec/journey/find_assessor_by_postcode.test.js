const { openBrowser, goto, write, into, click, closeBrowser, textBox } = require('taiko');
const { spawn } = require('child_process');
const http = require('http');

describe('Finding an assessor by postcode', () => {
  let process_id;
  let server;

  beforeAll(async () => {
    process_id = spawn('rackup', ['-q']);
    server = await http.createServer(function (req, res) {
    }).listen(9292);
    await openBrowser({ headless: false });
  });

  it('finds an assessor by postcode', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
  }, 30000);

  afterAll(async (done) => {
    await closeBrowser();
    await server.close(done);
    process.kill(process_id.pid, "SIGTERM")
  });
});
