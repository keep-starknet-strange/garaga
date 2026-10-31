import moduleOrPath from '../src/wasm/pkg/garaga_rs_bg.wasm';
import { vi } from 'vitest';

const initWasm = vi.hoisted(() => vi.fn());
vi.mock('../src/wasm/pkg/garaga_rs', () => ({ default: initWasm }));

let init: () => Promise<unknown>;
beforeEach(async () => {
  vi.resetModules();
  initWasm.mockReset();
  ({ init } = await import('../src/node/index'));
});

test('decodes embedded WASM directly in Node and shares concurrent initialization', async () => {
  const exports = {};
  initWasm.mockResolvedValue(exports);
  const first = init();
  expect(init()).toBe(first);
  expect(await first).toBe(exports);
  expect(await init()).toBe(exports);
  expect(initWasm).toHaveBeenCalledTimes(1);
  const bytes = initWasm.mock.calls[0]![0].module_or_path;
  const expected = Buffer.from(moduleOrPath.slice(moduleOrPath.indexOf(',') + 1), 'base64');
  expect(Buffer.isBuffer(bytes)).toBe(true);
  expect(bytes.equals(expected)).toBe(true);
});

test('keeps the browser data URI when Buffer is unavailable', async () => {
  initWasm.mockResolvedValue({});
  const buffer = globalThis.Buffer;
  let pending: Promise<unknown>;
  try {
    Object.defineProperty(globalThis, 'Buffer', { value: undefined });
    pending = init();
  } finally {
    Object.defineProperty(globalThis, 'Buffer', { value: buffer });
  }
  await pending!;
  expect(initWasm).toHaveBeenCalledWith({ module_or_path: moduleOrPath });
});

test('allows initialization to retry after failure', async () => {
  const failure = new Error('compile failed');
  const exports = {};
  initWasm.mockRejectedValueOnce(failure).mockResolvedValue(exports);
  await expect(init()).rejects.toBe(failure);
  await expect(init()).resolves.toBe(exports);
  expect(initWasm).toHaveBeenCalledTimes(2);
});
