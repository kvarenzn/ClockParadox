cmake_minimum_required(VERSION 3.14)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_MODULE_PATH})

find_package(KF5Plasma REQUIRED)

plasma_install_package(plasmoid kvarenzn.clockparadox)
