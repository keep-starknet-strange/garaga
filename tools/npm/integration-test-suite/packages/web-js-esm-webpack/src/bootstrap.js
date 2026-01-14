// A dependency graph that contains any wasm must all be imported
// asynchronously. This `bootstrap.js` file does the single async import, so
// that no one else needs to worry about it again.
import('./index.js')
  .catch((e) => {
    console.error('Error importing "index.js":', e.name, e.message, e.stack);
    // Also create a visible element to show the error
    const pre = document.createElement('pre');
    pre.textContent = `Import Error: ${e.name}: ${e.message}\n${e.stack}`;
    pre.style.color = 'red';
    document.body.appendChild(pre);
  });
