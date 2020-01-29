# Specifies if the port install should fail immediately given a condition
vcpkg_fail_port_install(MESSAGE "vst3sdk currently only supports Windows platforms" ON_TARGET "Linux" "OSX")

set(BUILD_TOOLS "OFF")
if("tools" IN_LIST FEATURES)
	message(STATUS "Requested building of tools.")
    set(BUILD_TOOLS "ON")
endif()

set(BUILD_EXAMPLES "OFF")
if("examples" IN_LIST FEATURES)
	message(STATUS "Requested building of examples.")
    set(BUILD_EXAMPLES "ON")
endif()

set(USE_VST3SDK_V367 "OFF")
if("legacy" IN_LIST FEATURES)
	message(STATUS "Requested building of vst3sdk version 3.6.6.")
	message(STATUS "[tools] and [examples] features will be turned off.")
    set(USE_VST3SDK_V367 "ON")
    set(BUILD_TOOLS "OFF")
    set(BUILD_EXAMPLES "OFF")
endif()

	#vcpkg_download_distfile(ARCHIVE
		#URLS "https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip"
		#FILENAME "vstsdk366_27_06_2016_build_61.zip"
		#SHA512 79b186dae42b7a0c2f6ffe4bfeeed68267bfc2f4ce58475e0e84b7b0d8e113de22d95180fc3df6179569bafc5a1f48e8008690d655fc2b12609fd5150f591e4b
	#)
if(USE_VST3SDK_V367)
	message(STATUS "Using previous version of vst3sdk that integrates vst2sdk.")

	vcpkg_download_distfile(ARCHIVE
		URLS "https://www.steinberg.net/sdk_downloads/vstsdk367_03_03_2017_build_352.zip"
		FILENAME "vstsdk367_03_03_2017_build_352.zip"
		SHA512 54ed5101c4b1b07f2341c5c4440223f4de08f9a12b08cc335c5917297db74d1474ba84f06d0120f0b7ae074d9ad776250396269ac7617b69bbab7937c752e098
	)

else()
	message(STATUS "Using lastest version of vst3sdk that contains vst2sdk wrappers.")
	vcpkg_download_distfile(ARCHIVE
		URLS "https://download.steinberg.net/sdk_downloads/vstsdk3612_03_12_2018_build_67.zip"
		FILENAME "vstsdk3612_03_12_2018_build_67.zip"
		SHA512 7f39bf01c055c6ae11f8d982222b511446b9dd9d04ba41344d0d9692ecf491f1e994e8e7e432fef3846eb768ba88a537be46a0b2cd6b9793b72f211ea5c67630
	)
endif()


vcpkg_extract_source_archive_ex(
	OUT_SOURCE_PATH SOURCE_PATH
	NO_REMOVE_ONE_LEVEL
	ARCHIVE ${ARCHIVE}
	REF ${VERSION}
)


message(STATUS "Building ${TARGET_TRIPLET}")

#copy vst2 files into vst3 directory
if(NOT USE_VST3SDK_V367)
	FILE(COPY ${SOURCE_PATH}/VST_SDK/VST2_SDK/ DESTINATION ${SOURCE_PATH}/VST_SDK/VST3_SDK/)
	
endif()


if(BUILD_TOOLS)
	vcpkg_configure_cmake(
		SOURCE_PATH ${SOURCE_PATH}/VST_SDK/VST3_SDK
		PREFER_NINJA
		OPTIONS
			-DSMTG_ADD_VST3_HOSTING_SAMPLES=OFF
			-DSMTG_ADD_VST3_PLUGINS_SAMPLES=OFF
			-DSMTG_VSTGUI_TOOLS=${VSTGUI_HAVE_TOOLS}
	)

	vcpkg_build_cmake()

    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    file(INSTALL ${CMAKE_BINARY_DIR}/bin/Release/ImageStitcher.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    file(INSTALL ${CMAKE_BINARY_DIR}/bin/Release/uidesccompressor.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/vst3sdk)
endif()


if(USE_VST3SDK_V367)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/index.html" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/README.md" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/LICENSE.txt" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk RENAME copyright)

	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/base" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/pluginterfaces" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/public.sdk" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/vstgui.sf" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/vstgui4" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/doc" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/bin" DESTINATION ${CURRENT_PACKAGES_DIR}/bin/${PORT})
	# file(INSTALL "${SOURCE_PATH}/VST3 SDK/doc/VST3_License_Agreement.rtf" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk RENAME copyright)
else()
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/" DESTINATION ${CURRENT_PACKAGES_DIR}/include/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/index.html" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/README.md" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/LICENSE.txt" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk RENAME copyright)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/VST3_License_Agreement.pdf" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)
	file(INSTALL "${SOURCE_PATH}/VST_SDK/VST3_SDK/VST3_Usage_Guidelines.pdf" DESTINATION ${CURRENT_PACKAGES_DIR}/share/vst3sdk)

endif()


file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/Findvst3sdk.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

