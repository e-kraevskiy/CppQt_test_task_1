cmake_minimum_required(VERSION 3.14)

project(polygone_editor LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON )

set(CMAKE_BUILD_TYPE Debug)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")

####################################
## Attention! Need use gold linker #
## to avoid multiple definition    #
## '__bss_start' in QQuickStyle    #
####################################
if (UNIX)
  execute_process(COMMAND ${CMAKE_C_COMPILER} -fuse-ld=gold -Wl,--version ERROR_QUIET OUTPUT_VARIABLE ld_version)
  if ("${ld_version}" MATCHES "GNU gold")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=gold -Wl,--disable-new-dtags")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=gold -Wl,--disable-new-dtags")
  endif()
endif()
####################################

find_package(Qt5 COMPONENTS REQUIRED
  Core
  Quick
  QuickControls2
  Sql
  Widgets
  )

FIND_PACKAGE(OpenCV REQUIRED)

# Сюда добавляем .h-ки из директории include
set(PROJECT_HEADERS
  )
# Сюда добавляем .cpp-ки из директории src
set(PROJECT_SOURCES
  src/main.cpp
  )
# Сюда добавляем .qrc-ки
set(PROJECT_RESOURCES
  qml.qrc
  )

qt5_wrap_cpp(${PROJECT_NAME}_MOCS ${PROJECT_HEADERS})

list(APPEND QML_IMPORT ${CMAKE_SOURCE_DIR}/)

set(QML_IMPORT_PATH "${QML_IMPORT}" CACHE STRING "" FORCE)

qt5_add_resources(${PROJECT_NAME}_QML qml.qrc)

include_directories(
  include
  ${PROJECT_SOURCE_DIR}
  ${Qt5Widgets_INCLUDE_DIRS}
  ${OpenCV_INCLUDE_DIRS}
  )

link_directories( ${OpenCV_LIBRARY_DIR} )

add_executable(${PROJECT_NAME}
  ${PROJECT_SOURCES}
  ${PROJECT_HEADERS}
  ${QT_RESOURCES_CPP}
  ${${PROJECT_NAME}_MOCS}
  ${${PROJECT_NAME}_QML}
  ${PROJECT_RESOURCES}
  )


target_compile_definitions(polygone_editor
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME}
  Qt5::Core
  Qt5::Quick
  Qt5::QuickControls2
  Qt5::Sql
  Qt5::Widgets
  )
