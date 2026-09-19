set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# for whatever reason, vcpkg does not default to creating symbols for release builds on Linux even though it does for Windows
set(VCPKG_C_FLAGS -g)
set(VCPKG_CXX_FLAGS -g)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)
