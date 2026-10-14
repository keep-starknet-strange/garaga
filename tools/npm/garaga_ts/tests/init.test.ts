import moduleOrPath from '../src/wasm/pkg/garaga_rs_bg.wasm';

function freshInit(initWasm: jest.Mock): () => Promise<unknown> {
  jest.doMock('../src/wasm/pkg/garaga_rs', () => ({
    __esModule: true,
    default: initWasm,
  }));
  let init: () => Promise<unknown>;
  jest.isolateModules(() => {
    ({ init } = require('../src/node/index'));
  });
  return init!;
}

afterEach(() => jest.dontMock('../src/wasm/pkg/garaga_rs'));

test('decodes embedded WASM directly in Node and shares concurrent initialization', async () => {
  const exports = {};
  const initWasm = jest.fn().mockResolvedValue(exports);
  const init = freshInit(initWasm);
  const first = init();
  expect(init()).toBe(first);
  expect(await first).toBe(exports);
  expect(await init()).toBe(exports);
  expect(initWasm).toHaveBeenCalledTimes(1);
  expect(initWasm.mock.calls[0]![0].module_or_path).toEqual(
    Buffer.from(moduleOrPath.slice(moduleOrPath.indexOf(',') + 1), 'base64'),
  );
});

test('keeps the browser data URI when Buffer is unavailable', async () => {
  const initWasm = jest.fn().mockResolvedValue({});
  const init = freshInit(initWasm);
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
  const initWasm = jest.fn().mockRejectedValueOnce(failure).mockResolvedValue(exports);
  const init = freshInit(initWasm);
  await expect(init()).rejects.toBe(failure);
  await expect(init()).resolves.toBe(exports);
  expect(initWasm).toHaveBeenCalledTimes(2);
});
