macro(build_fftw3d install_prefix staging_prefix)
  

  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()

  set(CMAKE_EXTERNAL_PROJECT_ARGS
        -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
        -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
        -DCMAKE_LINKER:FILEPATH=${CMAKE_LINKER}
        "-DCMAKE_CXX_FLAGS:STRING=-fPIC ${CMAKE_CXX_FLAGS}"
        -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
        -DCMAKE_CXX_FLAGS_MINSIZEREL:STRING=${CMAKE_CXX_FLAGS_MINSIZEREL}
        -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
        -DCMAKE_CXX_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_CXX_FLAGS_RELWITHDEBINFO}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        "-DCMAKE_C_FLAGS:STRING=-fPIC ${CMAKE_C_FLAGS}"
        -DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}
        -DCMAKE_C_FLAGS_MINSIZEREL:STRING=${CMAKE_C_FLAGS_MINSIZEREL}
        -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
        -DCMAKE_C_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_C_FLAGS_RELWITHDEBINFO}
        -DCMAKE_Fortran_FLAGS:STRING=${CMAKE_Fortran_FLAGS}
        -DCMAKE_Fortran_FLAGS_DEBUG:STRING=${CMAKE_Fortran_FLAGS_DEBUG}
        -DCMAKE_Fortran_FLAGS_MINSIZEREL:STRING=${CMAKE_Fortran_FLAGS_MINSIZEREL}
        -DCMAKE_Fortran_FLAGS_RELEASE:STRING=${CMAKE_Fortran_FLAGS_RELEASE}
        -DCMAKE_Fortran_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_Fortran_FLAGS_RELWITHDEBINFO}
        -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
        -DCMAKE_EXE_LINKER_FLAGS_DEBUG:STRING=${CMAKE_EXE_LINKER_FLAGS_DEBUG}
        -DCMAKE_EXE_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL}
        -DCMAKE_EXE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_EXE_LINKER_FLAGS_RELEASE}
        -DCMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO}
        -DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}
        -DCMAKE_MODULE_LINKER_FLAGS_DEBUG:STRING=${CMAKE_MODULE_LINKER_FLAGS_DEBUG}
        -DCMAKE_MODULE_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL}
        -DCMAKE_MODULE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_MODULE_LINKER_FLAGS_RELEASE}
        -DCMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO}
        -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
        -DCMAKE_SHARED_LINKER_FLAGS_DEBUG:STRING=${CMAKE_SHARED_LINKER_FLAGS_DEBUG}
        -DCMAKE_SHARED_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL}
        -DCMAKE_SHARED_LINKER_FLAGS_RELEASE:STRING=${CMAKE_SHARED_LINKER_FLAGS_RELEASE}
        -DCMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO}
        -DCMAKE_STATIC_LINKER_FLAGS:STRING=${CMAKE_STATIC_LINKER_FLAGS}
        -DCMAKE_STATIC_LINKER_FLAGS_DEBUG:STRING=${CMAKE_STATIC_LINKER_FLAGS_DEBUG}
        -DCMAKE_STATIC_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL}
        -DCMAKE_STATIC_LINKER_FLAGS_RELEASE:STRING=${CMAKE_STATIC_LINKER_FLAGS_RELEASE}
        -DCMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO}
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_LIBDIR:PATH=lib${LIB_SUFFIX}
        -DENABLE_SSE:BOOL=ON
        -DENABLE_SSE2:BOOL=ON
        -DENABLE_THREADS:BOOL=ON
  )

  if(APPLE)
    list(APPEND CMAKE_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )
  else()
    list(APPEND CMAKE_EXTERNAL_PROJECT_ARGS
        -DENABLE_AVX:BOOL=ON
        -DENABLE_AVX2:BOOL=ON
        )
  endif()

  IF(MT_USE_OPENMP)
    LIST(APPEND CMAKE_EXTERNAL_PROJECT_ARGS ENABLE_OPENMP:BOOL=ON  )
  ENDIF(MT_USE_OPENMP)


  GET_PACKAGE("http://www.fftw.org/fftw-3.3.8.tar.gz" "8aac833c943d8e90d51b697b27d4384d" "fftw-3.3.8.tar.gz" FFTW_PATH )

    ExternalProject_Add(FFTW3D
      URL  "${FFTW_PATH}"
      URL_MD5 "8aac833c943d8e90d51b697b27d4384d"
      UPDATE_COMMAND ""
      SOURCE_DIR FFTW3D
      BINARY_DIR FFTW3D-build
      LIST_SEPARATOR :::
      CMAKE_GENERATOR ${CMAKE_GEN}
      CMAKE_ARGS
          -DENABLE_FLOAT:BOOL=OFF
          -DDISABLE_FORTRAN:BOOL=ON
          -DBUILD_SHARED_LIBS:BOOL=OFF
          -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
          -DCMAKE_SKIP_RPATH:BOOL=OFF
          -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
          -DMACOSX_RPATH:BOOL=ON
          -DCMAKE_INSTALL_RPATH:PATH=${install_prefix}/lib${LIB_SUFFIX}
          -DINSTALL_LIB_DIR:PATH=${install_prefix}/lib${LIB_SUFFIX}
          -DINSTALL_INC_DIR:PATH=${install_prefix}/include
          ${CMAKE_EXTERNAL_PROJECT_ARGS}
      INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
      INSTALL_DIR ${staging_prefix}/${install_prefix}
    )

      
SET(FFTW3_INCLUDE_DIR      ${install_prefix}/include )
SET(FFTW3_LIBRARY          ${install_prefix}/lib${LIB_SUFFIX}/libfftw3.a )
SET(FFTW3_THREADS_LIBRARY  ${install_prefix}/lib${LIB_SUFFIX}/libfftw3_threads.a )
SET(FFTW3_OMP_LIBRARY      ${install_prefix}/lib${LIB_SUFFIX}/libfftw3_omp.a )
#configure_file(${CMAKE_SOURCE_DIR}/cmake-modules/FFTW3DConfig.cmake.in ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/FFTW3DConfig.cmake @ONLY)

SET(FFTW3_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
SET(FFTW3_LIBRARY  ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3.a )
SET(FFTW3_THREADS_LIBRARY  ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3_threads.a )
SET(FFTW3_OMP_LIBRARY  ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3_omp.a )
SET(FFTW3_FOUND ON)

endmacro(build_fftw3d)
