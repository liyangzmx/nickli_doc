cmake_minimum_required(VERSION 3.8.1)

project(fdk-aac C CXX)

foreach ( subdir
    libAACdec libAACenc libArithCoding 
	libDRCdec 
	libFDK 
    libMpegTPDec libMpegTPEnc
    libPCMutils
	libSACdec libSACenc libSBRdec libSBRenc libSYS)
    set ( incdir ${CMAKE_SOURCE_DIR}/${subdir}/include )
    set ( srcdir ${CMAKE_SOURCE_DIR}/${subdir}/src )
    include_directories ( ${incdir} )
    file ( GLOB srcfiles ${srcdir}/*.cpp ${srcdir}/*.h)
    list ( APPEND SOURCE_FILES ${srcfiles} )
endforeach()

message("srcs: ${SOURCE_FILES}")

add_library ( fdk-aac SHARED ${SOURCE_FILES} )
set_target_properties(fdk-aac PROPERTIES LINKER_LANGUAGE CXX)