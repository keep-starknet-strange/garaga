const puppeteer = require('puppeteer');

async function loadWebContent(url) {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();

  // Capture console messages and errors
  const consoleMessages = [];
  page.on('console', async msg => {
    const args = await Promise.all(msg.args().map(arg => arg.jsonValue().catch(() => arg.toString())));
    consoleMessages.push(`[${msg.type()}] ${args.join(' ')}`);
  });
  page.on('pageerror', err => {
    consoleMessages.push(`[pageerror] ${err.message || err.toString()}`);
  });

  await page.goto(url);

  try {
    await page.waitForSelector('body pre', { visible: true, timeout: 90000 });
  } catch (e) {
    // Wait a bit to collect any pending console messages
    await new Promise(r => setTimeout(r, 1000));
    if (consoleMessages.length > 0) {
      console.error('Browser console messages:');
      consoleMessages.forEach(m => console.error('  ', m));
    }
    const html = await page.content();
    console.error('Page HTML:', html.substring(0, 2000));
    throw e;
  }

  const content = await page.evaluate(() => document.querySelector('body pre').innerHTML);
  await browser.close();
  return content;
}

async function scrape() {
  const content = await loadWebContent('http://localhost:8080');
  console.log(content);
}

scrape()
  .then(() => process.exit(0))
  .catch((e) => process.exit((console.error(e), 1)));
