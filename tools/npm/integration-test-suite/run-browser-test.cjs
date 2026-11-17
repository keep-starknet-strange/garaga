const { once } = require('node:events');
const { readdirSync, readFileSync, writeFileSync } = require('node:fs');
const { createServer } = require('node:http');
const { join } = require('node:path');
const puppeteer = require('puppeteer');

async function main() {
  const html = readFileSync(join(__dirname, 'browser.html'));
  const bundles = new Map(
    readdirSync('dist')
      .filter(file => file.endsWith('.js'))
      .map(file => ['/' + file, readFileSync(join('dist', file))]),
  );
  const server = createServer((request, response) => {
    if (request.url === '/') {
      response.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      response.end(html);
    } else if (bundles.has(request.url)) {
      response.writeHead(200, { 'Content-Type': 'text/javascript; charset=utf-8' });
      response.end(bundles.get(request.url));
    } else {
      response.writeHead(404).end();
    }
  });
  server.listen(0, '127.0.0.1');

  try {
    await once(server, 'listening');
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    try {
      const page = await browser.newPage();
      page.on('pageerror', error => console.error(error));
      page.on('console', message => {
        if (message.type() === 'error') console.error(message.text());
      });
      await page.goto(`http://127.0.0.1:${server.address().port}`);
      await page.waitForSelector('body pre', { visible: true, timeout: 90000 });
      const content = await page.$eval('body pre', element => element.textContent);
      const actual = content + '\n';
      if (process.argv.includes('--update')) writeFileSync('output.txt', actual);
      else if (actual !== readFileSync('output.txt', 'utf8')) {
        throw new Error('Browser output differs from the reference');
      }
    } finally {
      await browser.close();
    }
  } finally {
    server.close();
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
