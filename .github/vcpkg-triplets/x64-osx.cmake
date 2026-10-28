set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Darwin)
set(VCPKG_OSX_ARCHITECTURES x86_64)

# CMake 4 no longer defaults CMAKE_OSX_SYSROOT. scripts/get_cmake_vars still
# appends "-isysroot ${CMAKE_OSX_SYSROOT}", so an empty value becomes a bare
# -isysroot and host meson (pkgconf) cannot link. vcpkg_configure_cmake forwards
# VCPKG_OSX_SYSROOT as -DCMAKE_OSX_SYSROOT for this triplet only; arm64-ios
# keeps CMake's iphoneos default.
execute_process(
    COMMAND xcrun --sdk macosx --show-sdk-path
    OUTPUT_VARIABLE VCPKG_OSX_SYSROOT
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE _vcpkg_sdk_rc
)
if(NOT _vcpkg_sdk_rc EQUAL 0 OR NOT IS_DIRECTORY "${VCPKG_OSX_SYSROOT}")
    message(FATAL_ERROR "xcrun did not return a macOS SDK (rc=${_vcpkg_sdk_rc}, path='${VCPKG_OSX_SYSROOT}')")
endif()
