const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');

function loadFileContent(name) {
  return fs.readFileSync(path.join(__dirname, name), 'utf8');
}

function writeFileContent(name, content) {
  return fs.writeFileSync(path.join(__dirname, name), content, 'utf8');
}

async function loadWebContent(url) {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
  const page = await browser.newPage();
  await page.goto(url);
  await page.waitForSelector('body pre', { visible: true });
  const content = await page.evaluate(() => document.querySelector('body pre').innerHTML);
  await browser.close();
  return content;
}

async function test() {
  const content1 = loadFileContent('output.txt');
  const content2 = await loadWebContent('http://localhost:8080');
  if (content1 !== content2) {
    writeFileContent('output.txt', content2);
    throw new Error('Content mistmatch');
  }
}

test()
  .then(() => process.exit(0))
  .catch((e) => process.exit((console.error(e), 1)));
