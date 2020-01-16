const {openBrowser, goto, write, into, click, closeBrowser, textBox, text, intercept} = require('taiko');
const {spawn} = require('child_process');

describe('Finding an assessor by postcode', () => {
  let rackup_pid;
  let rackup_stdout = '';
  let rackup_resolved = false;
  let rackup_rejected = false;


  beforeAll(async () => {
    rackup_pid = await new Promise((resolve, reject) => {
      let rackup = spawn('make', ['run', 'ARGS=config_test.ru']);

      rackup.stderr.on('data', line => {
        rackup_stdout += line.toString();

        if (line.indexOf('port=9292') !== -1 && !rackup_rejected && !rackup_resolved) {
          rackup_resolved = true;
          resolve(rackup.pid);
        }

        if (line.indexOf('*** [run] Error') !== -1 && !rackup_rejected && !rackup_resolved) {
          rackup_rejected = true;
          reject(rackup_stdout);
        }
      });
    });

    await openBrowser({
      args: [
        '--disable-gpu',
        '--disable-dev-shm-usage',
        '--disable-setuid-sandbox',
        '--no-first-run',
        '--no-sandbox',
        '--no-zygote']
    });
  });

  it('finds an assessor by postcode', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
  }, 30000);

  it('finds an assessor by postcode in Welsh', async () => {
    await goto("localhost:9292");
    await click('Welsh (Cymraeg)')
    await click('Welsh: Start now');
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Welsh: Find');
  }, 30000);

  it('displays an error message when entering an empty postcode', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('', into(textBox('postcode')));
    await click('Find');
    await text('Enter a real postcode').exists()
  }, 30000);

  it('displays an error message when entering an invalid postcode', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('NOT A POSTCODE', into(textBox('postcode')));
    await click('Find');
    await text('Enter a real postcode').exists()
  }, 30000);

  it('displays the find an assessor page heading when entering a valid postcode ', async () => {
    await goto("localhost:9292");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
    await text('Results for energy assessors near you').exists()
  }, 30000);

  afterAll(async () => {
    await closeBrowser();
    process.kill(rackup_pid, "SIGTERM")
  });
});
