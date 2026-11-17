import { createElement } from 'react';
import { createRoot } from 'react-dom/client';
import * as garaga from 'garaga';
import { conformanceOutput } from '../../../browser-output.mjs';

async function main() {
  const output = await conformanceOutput(garaga);
  createRoot(document.getElementById('app')).render(createElement('pre', null, output));
}

main().catch(console.error);
