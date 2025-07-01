const puppeteer = require('puppeteer');

async function loadWebContent(url) {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.goto(url);
  await page.waitForSelector('body pre', { visible: true, timeout: 90000 });
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
