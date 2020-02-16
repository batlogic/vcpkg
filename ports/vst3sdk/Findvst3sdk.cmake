message(" Looking for vst3sdk! ")
if(WIN32)
else(WIN32)
  message(FATAL_ERROR "Findvst3sdk.cmake: Unsupported platform ${CMAKE_SYSTEM_NAME}" )
endif(WIN32)

find_path(
  VST3SDK_HOME
  vst3sdk
)

if (NOT "${VST3SDK_HOME}" STREQUAL "")
  set(VST3SDK_HOME
	${VST3SDK_HOME}/vst3sdk
  )
endif()


message(" Findvst3sdk VST3SDK_HOME : ${VST3SDK_HOME}")

find_path(VST3SDK_INCLUDE_DIR
  vst3stdsdk.cpp
  PATHS
  ${VST3SDK_HOME}/public.sdk/source 
)  


if (NOT "${VST3SDK_HOME}" STREQUAL "")
	set (VST3SDK_INCLUDE_DIR
		${VST3SDK_HOME}/
		${VST3SDK_HOME}/base/source
		${VST3SDK_HOME}/base/thread/include
		${VST3SDK_HOME}/base/thread/source
	
		${VST3SDK_HOME}/pluginterfaces/base
		${VST3SDK_HOME}/pluginterfaces/gui
		${VST3SDK_HOME}/pluginterfaces/vst
		${VST3SDK_HOME}/public.sdk
		${VST3SDK_HOME}/public.sdk/source
		${VST3SDK_HOME}/public.sdk/source/common
		${VST3SDK_HOME}/public.sdk/source/main
		${VST3SDK_HOME}/public.sdk/source/vst
		${VST3SDK_HOME}/public.sdk/source/vst2.x
		${VST3SDK_HOME}/vstgui4
		${VST3SDK_HOME}/vstgui4/vstgui
	)
endif()


message(" Findvst3sdk VST3SDK_INCLUDE_DIR : ${VST3SDK_INCLUDE_DIR}")

# handle the QUIETLY and REQUIRED arguments and set VST3SDK_FOUND to TRUE if 
# all listed variables are TRUE

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VST3SDK DEFAULT_MSG VST3SDK_HOME VST3SDK_INCLUDE_DIR)

MARK_AS_ADVANCED(
    VST3SDK_HOME VST3SDK_INCLUDE_DIR
)
