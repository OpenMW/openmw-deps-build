vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO recastnavigation/recastnavigation
  REF 40ec6fcd6c0263a3d7798452aee531066072d15d
  SHA512 e5b8d84b1f399faceaed27286f503991536298da8be4dfaeca9a32b2628c8316af6245dbe46517e39821b8e4f2634a9e1de23e992cb7842f4b38368b81ec0302
)
vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_SHARED_LIBS=ON
    -DRECASTNAVIGATION_DEMO=OFF
    -DRECASTNAVIGATION_TESTS=OFF
    -DRECASTNAVIGATION_EXAMPLES=OFF
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/recastnavigation)
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")
