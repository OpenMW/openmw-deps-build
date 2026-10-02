* `cd` here
* `docker compose up`
* wait
* terminal seems to get stuck at `Attaching to generic-linux-build-container-1`, but Docker Desktop says the container is alive.
* VS Code dev containers extension is able to connect.
* Make `/build/openmw-deps-build` the active directory.
* `vcpkg install --overlay-ports=ports --overlay-triplets=triplets --triplet x64-linux-dynamic --host-triplet x64-linux-dynamic`
* `vcpkg export --x-all-installed --raw --output-dir ./ --output vcpkg-export`
* `tar -caf vcpkg-x64-linux-dynamic-$(git rev-parse HEAD).tar.xz vcpkg-export/`
