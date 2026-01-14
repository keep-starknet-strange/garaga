const puppeteer = require('puppeteer');

async function loadWebContent(url) {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();

  // Capture console errors
  const consoleErrors = [];
  page.on('console', msg => {
    if (msg.type() === 'error') {
      consoleErrors.push(msg.text());
    }
  });
  page.on('pageerror', err => {
    consoleErrors.push(err.toString());
  });

  await page.goto(url);

  try {
    await page.waitForSelector('body pre', { visible: true, timeout: 90000 });
  } catch (e) {
    if (consoleErrors.length > 0) {
      console.error('Browser console errors:', consoleErrors.join('\n'));
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
