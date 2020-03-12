const {openBrowser, goto, write, into, click, closeBrowser, textBox, text, intercept} = require('taiko');
const {spawn} = require('child_process');

describe('Journey::Assessor', () => {
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
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
  }, 30000);

  it('finds an assessor by postcode in Welsh', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click('Welsh (Cymraeg)');
    await click('Welsh: Start now');
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Welsh: Find');
  }, 30000);

  it('displays an error message when entering an empty postcode', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await write('', into(textBox('postcode')));
    await click('Find');
    let result = await text('Enter a real postcode').exists();

    expect(result).toBeTruthy();
  }, 30000);

  it('displays an error message when entering an invalid postcode', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await write('NOT A POSTCODE', into(textBox('postcode')));
    await click('Find');
    let result = await text('Enter a real postcode').exists();

    expect(result).toBeTruthy();
  }, 30000);

  it('displays the find an assessor page heading when entering a valid postcode ', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await write('SW1A 2AA', into(textBox('postcode')));
    await click('Find');
    let result = await text('3 assessors, sorted by distance from SW1A 2AA').exists();

    expect(result).toBeTruthy();
  }, 30000);

  it('displays an error message when entering an empty name', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await click('Find assessor by name');
    await click('Search');
    let result = await text('Enter a name').exists();

    expect(result).toBeTruthy();
  }, 30000);

  it('displays an assessor when searched for one that does exist', async () => {
    await goto("localhost:9292/find-an-assessor");
    await click("Start now");
    await click('Find assessor by name');
    await write('Supercommon Name', into(textBox('name')));
    await click('Search');
    let result = await text('3 results, found by the name Supercommon Name').exists();

    expect(result).toBeTruthy();
  }, 30000);

  afterAll(async () => {
    await closeBrowser();
    process.kill(rackup_pid, "SIGTERM")
  });
});
