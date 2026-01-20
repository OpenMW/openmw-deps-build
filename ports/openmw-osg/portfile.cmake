set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)

set(OSG_VER 3.6.5)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO openmw/osg
    REF 61a4c88d5292ad693086826b9eaaf142466d05f9
    SHA512 037a7511317d56055784c00826f4cb5c2f7983d9cf45635f50cfb898529d42d4c3e5f8df66ac3a42792c41854cb39c20f3a1e5a790510c61563a00f19bb19293
    HEAD_REF 3.6
)

file(REMOVE
    "${SOURCE_PATH}/CMakeModules/FindFontconfig.cmake"
    "${SOURCE_PATH}/CMakeModules/FindFreetype.cmake"
    "${SOURCE_PATH}/CMakeModules/Findilmbase.cmake"
    "${SOURCE_PATH}/CMakeModules/FindOpenEXR.cmake"
    "${SOURCE_PATH}/CMakeModules/FindSDL2.cmake"
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" OSG_DYNAMIC)

set(OPTIONS "")

# Skip try_run checks
if(VCPKG_TARGET_IS_MINGW)
    list(APPEND OPTIONS -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=0 -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS=1)
elseif(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND OPTIONS -D_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED=1 -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS=0)
elseif(VCPKG_TARGET_IS_IOS)
    # handled by osg
elseif(VCPKG_CROSSCOMPILING)
    message(WARNING "Atomics detection may fail for cross builds. You can set osg cmake variables in a custom triplet.")
endif()

# The package osg can be configured to use different OpenGL profiles via a custom triplet file:
# Possible values are GLCORE, GL2, GL3, GLES1, GLES2, GLES3, and GLES2+GLES3
if(NOT DEFINED osg_OPENGL_PROFILE)
    set(osg_OPENGL_PROFILE "GL2")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DDYNAMIC_OPENSCENEGRAPH=${OSG_DYNAMIC}
        -DDYNAMIC_OPENTHREADS=${OSG_DYNAMIC}
        -DOSG_MSVC_VERSIONED_DLL=OFF
        -DOSG_DETERMINE_WIN_VERSION=OFF
        -DOSG_FIND_3RD_PARTY_DEPS=OFF
        -DOSG_DISABLE_MSVC_WARNINGS=OFF
        -DOPENGL_PROFILE=${osg_OPENGL_PROFILE}
        -DBUILD_DASHBOARD_REPORTS=OFF
        -DCMAKE_CXX_STANDARD=11
        -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON
        -DBUILD_OSG_PLUGINS_BY_DEFAULT=OFF
        -DBUILD_OSG_PLUGIN_OSG=ON
        -DBUILD_OSG_PLUGIN_DDS=ON
        -DBUILD_OSG_PLUGIN_TGA=ON
        -DBUILD_OSG_PLUGIN_BMP=ON
        -DBUILD_OSG_PLUGIN_JPEG=ON
        -DBUILD_OSG_PLUGIN_PNG=ON
        -DBUILD_OSG_PLUGIN_FREETYPE=ON
        -DBUILD_OSG_PLUGIN_DAE=ON
        -DBUILD_OSG_PLUGIN_KTX=ON
        -DBUILD_OSG_DEPRECATED_SERIALIZERS=OFF
        -DBUILD_OSG_APPLICATIONS=OFF
        -DBUILD_OSG_EXAMPLES=OFF
        -DBUILD_DOCUMENTATION=OFF
        ${OPTIONS}
    MAYBE_UNUSED_VARIABLES
        OSG_DETERMINE_WIN_VERSION
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(APPEND "${CURRENT_PACKAGES_DIR}/include/osg/Config" "#ifndef OSG_LIBRARY_STATIC\n#define OSG_LIBRARY_STATIC 1\n#endif\n")
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/openscenegraph.pc" "\\\n" " ")
if(NOT VCPKG_BUILD_TYPE)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/openscenegraph.pc" "\\\n" " ")
endif()
vcpkg_fixup_pkgconfig()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
