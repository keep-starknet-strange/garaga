# ark-relations 0.5.1

This copy comes from the published [ark-relations 0.5.1 crate](https://crates.io/crates/ark-relations/0.5.1).
The crate archive has SHA-256 `ec46ddc93e7af44bcab5230937635b06fb5744464dd6a7e7b083e80ebd274384`.
The original MIT and Apache 2.0 licenses are included.

This backport updates `tracing-subscriber` to the patched 0.3 series and removes an empty callback from the old subscriber API.
It leaves the constraint code unchanged.
Both Fibonacci Cargo workspaces use this copy. The guest build copies only the contents of the guest directory into Docker.

Remove the patch from both workspaces when the example's SDK resolves an arkworks release that uses the patched subscriber.
Run the host compatibility tests to check both receipts and the compiled guest image ID.
