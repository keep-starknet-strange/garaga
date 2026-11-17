import assert from 'node:assert/strict';
import { beforeEach, mock, test } from 'node:test';
import * as wasm from '../src/wasm/pkg/garaga_rs.js';
import moduleOrPath from '../src/wasm/pkg/garaga_rs_bg.wasm.js';

const initWasm = mock.fn((_input: { module_or_path: unknown }): Promise<object> => Promise.resolve({}));
mock.module(new URL('../src/wasm/pkg/garaga_rs.js', import.meta.url), {
  exports: { ...wasm, default: initWasm },
});

let init: () => Promise<unknown>;
let imports = 0;
beforeEach(async () => {
  initWasm.mock.resetCalls();
  initWasm.mock.mockImplementation(() => Promise.resolve({}));
  const entry = new URL('../src/node/index.js', import.meta.url);
  entry.searchParams.set('test', String(imports++));
  ({ init } = await import(entry.href));
});

test('decodes embedded WASM directly in Node and shares concurrent initialization', async () => {
  const exports = {};
  initWasm.mock.mockImplementation(() => Promise.resolve(exports));
  const first = init();
  assert.equal(init(), first);
  assert.equal(await first, exports);
  assert.equal(await init(), exports);
  assert.equal(initWasm.mock.callCount(), 1);
  const bytes = initWasm.mock.calls[0]!.arguments[0].module_or_path;
  const expected = Buffer.from(moduleOrPath.slice(moduleOrPath.indexOf(',') + 1), 'base64');
  assert.ok(Buffer.isBuffer(bytes));
  assert.deepEqual(bytes, expected);
});

test('keeps the browser data URI when Buffer is unavailable', async () => {
  const buffer = globalThis.Buffer;
  let pending: Promise<unknown>;
  try {
    Object.defineProperty(globalThis, 'Buffer', { value: undefined });
    pending = init();
  } finally {
    Object.defineProperty(globalThis, 'Buffer', { value: buffer });
  }
  await pending;
  assert.equal(initWasm.mock.callCount(), 1);
  assert.deepEqual(initWasm.mock.calls[0]!.arguments, [{ module_or_path: moduleOrPath }]);
});

test('allows initialization to retry after failure', async () => {
  const failure = new Error('compile failed');
  const exports = {};
  initWasm.mock.mockImplementationOnce(() => Promise.reject(failure));
  initWasm.mock.mockImplementation(() => Promise.resolve(exports));
  await assert.rejects(init(), error => error === failure);
  assert.equal(await init(), exports);
  assert.equal(initWasm.mock.callCount(), 2);
});
