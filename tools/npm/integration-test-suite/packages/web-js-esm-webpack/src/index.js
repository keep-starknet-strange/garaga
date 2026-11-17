import * as garaga from 'garaga';
import { conformanceOutput } from '../../../browser-output.mjs';

async function main() {
  const element = document.createElement('pre');
  element.textContent = await conformanceOutput(garaga);
  document.getElementById('app').appendChild(element);
}

main().catch(console.error);
