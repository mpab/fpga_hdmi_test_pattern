cmake_minimum_required(VERSION 3.21)
cmake_policy(SET CMP0144 NEW)
# generate compile_commands.json for clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(sim)
add_compile_definitions(_SDL_USE_VERSION=2)

add_executable(${PROJECT_NAME} ../src/sim.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE ../src/)
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    target_link_libraries(${PROJECT_NAME} "-undefined dynamic_lookup")
endif()

# verilator
find_package(verilator HINTS $ENV{VERILATOR_ROOT})
add_library(dut)
verilate(dut
    SOURCES ../src/sim.sv
    INCLUDE_DIRS ../../hardware/src
    VERILATOR_ARGS -O3 --x-assign fast --x-initial fast --noassert
)

# SDL2
find_package(SDL2 REQUIRED)
target_link_libraries(${PROJECT_NAME} SDL2::SDL2 dut)
target_compile_definitions(${PROJECT_NAME} PRIVATE SDL_MAIN_HANDLED)

# copy shared DLLs to output
function (copy_dlls PROJECT_NAME)
    if (WIN32)
        add_custom_command (
            TARGET "${PROJECT_NAME}" POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E copy -t "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
                    "$<TARGET_RUNTIME_DLLS:${PROJECT_NAME}>" USES_TERMINAL COMMAND_EXPAND_LISTS
        )
    endif ()
endfunction ()

copy_dlls(${PROJECT_NAME})
