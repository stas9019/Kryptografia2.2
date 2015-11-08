cmake_minimum_required(VERSION 3.3)
project(Kryptografia2_2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp )
add_executable(Kryptografia2_2 ${SOURCE_FILES})


target_link_libraries(Kryptografia2_2 ao) #link the ssl library
target_link_libraries(Kryptografia2_2 mpg123) #link the crypto library