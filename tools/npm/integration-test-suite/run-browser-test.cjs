const { spawn } = require('node:child_process');
const { readFileSync, writeFileSync } = require('node:fs');
const net = require('node:net');
const { setTimeout: delay } = require('node:timers/promises');

async function freePort() {
  const socket = net.createServer();
  await new Promise((resolve, reject) => socket.once('error', reject).listen(0, '127.0.0.1', resolve));
  const port = socket.address().port;
  await new Promise(resolve => socket.close(resolve));
  return port;
}

async function main() {
  const port = await freePort();
  const url = `http://127.0.0.1:${port}`;
  const server = spawn('npm', ['run', 'start', '--', '--port', String(port)], {
    detached: true, stdio: ['ignore', 'pipe', 'pipe'],
  });
  server.stdout.pipe(process.stderr);
  server.stderr.pipe(process.stderr);
  let exited = false;
  server.once('exit', () => { exited = true; });
  try {
    let ready = false;
    for (let attempt = 0; attempt < 300; attempt++) {
      if (exited) throw new Error('Browser test server exited before it was ready');
      try {
        const response = await fetch(url, { signal: AbortSignal.timeout(1000) });
        ready = response.ok;
      } catch { /* Retry until the owned server starts listening. */ }
      if (ready) break;
      await delay(100);
    }
    if (!ready) throw new Error('Browser test server did not become ready');
    const scrape = spawn(process.execPath, ['scrape.cjs'], {
      env: { ...process.env, GARAGA_TEST_URL: url }, stdio: ['ignore', 'pipe', 'inherit'],
    });
    let actual = '';
    scrape.stdout.on('data', data => { actual += data; });
    const code = await new Promise((resolve, reject) => {
      scrape.once('error', reject);
      scrape.once('exit', resolve);
    });
    if (code !== 0) throw new Error(`Browser conformance check failed with exit code ${code}`);
    if (process.argv.includes('--update')) writeFileSync('output.txt', actual);
    else if (actual !== readFileSync('output.txt', 'utf8')) throw new Error('Browser output differs from the reference');
  } finally {
    try { process.kill(-server.pid, 'SIGTERM'); } catch (error) {
      if (error.code !== 'ESRCH') throw error;
    }
  }
}

main().catch(error => { console.error(error); process.exitCode = 1; });
