set(VSTSDK_PREV_MODULE_PATH ${CMAKE_MODULE_PATH})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

if(NOT VSTSDK_INCLUDE_DIR)
  _find_package(${ARGS})
endif()

set(CMAKE_MODULE_PATH ${VSTSDK_PREV_MODULE_PATH})
