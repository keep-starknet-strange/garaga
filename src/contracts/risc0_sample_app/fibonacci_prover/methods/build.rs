use std::{collections::HashMap, path::PathBuf};

fn main() {
    // Panic locations embed source paths in the guest image. Use the same pinned
    // container and locked dependencies locally and in CI to keep its image ID stable.
    let docker = risc0_build::DockerOptionsBuilder::default()
        .root_dir(PathBuf::from(std::env::var("CARGO_MANIFEST_DIR").unwrap()).join("guest"))
        .docker_container_tag(
            "r0.1.97.0@sha256:6f6c300e4af57ea3efe62b7f04a17629efe0f0caa6ad3699d6766bf19e0e62fb",
        )
        .build()
        .unwrap();
    let options = risc0_build::GuestOptionsBuilder::default()
        .use_docker(docker)
        .build()
        .unwrap();
    risc0_build::embed_methods_with_options(HashMap::from([("fibonacci_guest", options)]));
}
