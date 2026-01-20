vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO LuaJIT/LuaJIT
    REF 7a0cf5fd4c6c841d0455a51271af4fd4390c7884
    SHA512 679f65586fd5939a96bcc25b6aa82e38a357f0582de1a748d26b5f57c83b988d782df6e3c1ce33c61a8d1259df632589d0828b1c5479cc6ab4ccf7974c8f69cf
    HEAD_REF master
)

set(BUILD_DIR "${CURRENT_BUILDTREES_DIR}/build/luajit-build")
file(REMOVE_RECURSE "${BUILD_DIR}")
file(MAKE_DIRECTORY "${BUILD_DIR}")
execute_process(COMMAND ${CMAKE_COMMAND} -E copy_directory "${SOURCE_PATH}" "${BUILD_DIR}"
                RESULT_VARIABLE _copy_result)
if(NOT _copy_result EQUAL 0)
    message(FATAL_ERROR "Failed to copy source to build directory.")
  endif()

vcpkg_cmake_get_vars(cmake_vars_file)
include("${cmake_vars_file}")

if(DEFINED VCPKG_OSX_DEPLOYMENT_TARGET)
    message(STATUS "Setting MACOSX_DEPLOYMENT_TARGET=${VCPKG_OSX_DEPLOYMENT_TARGET} for build")
    set(ENV{MACOSX_DEPLOYMENT_TARGET} "${VCPKG_OSX_DEPLOYMENT_TARGET}")
endif()

vcpkg_execute_required_process(
    COMMAND make -j${VCPKG_CONCURRENCY}
    WORKING_DIRECTORY "${BUILD_DIR}"
    LOGNAME make_luajit
)

vcpkg_execute_required_process(
    COMMAND make install PREFIX=${CURRENT_PACKAGES_DIR}
    WORKING_DIRECTORY "${BUILD_DIR}"
    LOGNAME make_install_luajit
  )

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/lib/lua"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/lib/lua"
    "${CURRENT_PACKAGES_DIR}/share/lua"
    "${CURRENT_PACKAGES_DIR}/share/man"
)

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYRIGHT")
