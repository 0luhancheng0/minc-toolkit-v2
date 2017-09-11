macro(build_itkv4 install_prefix staging_prefix minc_dir hdf_bin_dir hdf_include_dir hdf_library_dir zlib_include_dir zlib_library)
  find_package(Threads REQUIRED)

  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif(CMAKE_EXTRA_GENERATOR)


  #message("HDF5_DIR=${HDF5_DIR}")
  #message("CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
  #message("CMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
  SET(EXT_CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
  SET(EXT_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  IF(NOT APPLE)
  LIST(APPEND EXT_CMAKE_C_FLAGS -D_XOPEN_SOURCE=600)
  LIST(APPEND EXT_CMAKE_CXX_FLAGS -D_XOPEN_SOURCE=600)
  ENDIF(NOT APPLE)
  
  set(CMAKE_EXTERNAL_PROJECT_ARGS
        -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
        -DCMAKE_LINKER:FILEPATH=${CMAKE_LINKER}
        -DCMAKE_CXX_FLAGS:STRING=${EXT_CMAKE_CXX_FLAGS} 
        -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
        -DCMAKE_CXX_FLAGS_MINSIZEREL:STRING=${CMAKE_CXX_FLAGS_MINSIZEREL}
        -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
        -DCMAKE_CXX_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_CXX_FLAGS_RELWITHDEBINFO}
        -DCMAKE_C_FLAGS:STRING=${EXT_CMAKE_C_FLAGS} 
        -DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}
        -DCMAKE_C_FLAGS_MINSIZEREL:STRING=${CMAKE_C_FLAGS_MINSIZEREL}
        -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
        -DCMAKE_C_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_C_FLAGS_RELWITHDEBINFO}
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
  )
  if(APPLE)
    list(APPEND CMAKE_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )
  endif(APPLE)

  SET(PATCH_QUIET "")
  #if(MT_BUILD_QUIET)
  IF(NOT APPLE)
    SET(PATCH_QUIET patch -p0 -t -N -i ${CMAKE_SOURCE_DIR}/cmake-modules/quiet_cmake_ccache.patch)
  ENDIF(NOT APPLE)
  #endif(MT_BUILD_QUIET)

  SET(HDF5_LIB_SUFFIX ".a")
  
  IF(MT_BUILD_SHARED_LIBS) 
    SET(ITK_SHARED_LIBRARY "ON")
    
    IF(APPLE)
        SET(HDF5_LIB_SUFFIX ".dylib")
    ELSE(APPLE)
        SET(HDF5_LIB_SUFFIX ".so")
    ENDIF(APPLE)
    
  ELSE(MT_BUILD_SHARED_LIBS)
      SET(HDF5_LIB_SUFFIX    ".a")
      SET(ITK_SHARED_LIBRARY "OFF")
  ENDIF(MT_BUILD_SHARED_LIBS)
  
  IF(${CMAKE_BUILD_TYPE} STREQUAL Release)
    #message("Using release version of HDF5")
    SET(HDF5_LIBRARY ${hdf_library_dir}/libhdf5${HDF5_LIB_SUFFIX})
    SET(HDF5_CPP_LIBRARY ${hdf_library_dir}/libhdf5_cpp${HDF5_LIB_SUFFIX})
    SET(HDF5_HL_LIBRARY ${hdf_library_dir}/libhdf5_hl${HDF5_LIB_SUFFIX})
    SET(HDF5_HL_CPP_LIBRARY ${hdf_library_dir}/libhdf5_hl_cpp${HDF5_LIB_SUFFIX})
  ELSE(${CMAKE_BUILD_TYPE} STREQUAL Release)
    #message("Using debug version of HDF5")
    SET(HDF5_LIBRARY ${hdf_library_dir}/libhdf5_debug${HDF5_LIB_SUFFIX})
    SET(HDF5_CPP_LIBRARY ${hdf_library_dir}/libhdf5_cpp_debug${HDF5_LIB_SUFFIX})
    SET(HDF5_HL_LIBRARY ${hdf_library_dir}/libhdf5_hl_debug${HDF5_LIB_SUFFIX})
    SET(HDF5_HL_CPP_LIBRARY ${hdf_library_dir}/libhdf5_hl_cpp_debug${HDF5_LIB_SUFFIX})
  ENDIF(${CMAKE_BUILD_TYPE} STREQUAL Release)

   message("HDF5_LIBRARY=${HDF5_LIBRARY}")
   message("HDF5_CPP_LIBRARY=${HDF5_CPP_LIBRARY}")
   message("HDF5_HL_LIBRARY=${HDF5_HL_LIBRARY}")
   message("HDF5_HL_CPP_LIBRARY=${HDF5_HL_CPP_LIBRARY}")

  GET_PACKAGE("https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.1.tar.xz" "5eb35af6a645680235c36390d864e77f" "InsightToolkit-4.12.1.tar.xz" ITKv4_PATH ) 
  
  ExternalProject_Add(ITKv4
    URL "${ITKv4_PATH}"
    URL_MD5 "5eb35af6a645680235c36390d864e77f"
    UPDATE_COMMAND ""
    SOURCE_DIR ITKv4
    BINARY_DIR ITKv4-build
    PATCH_COMMAND ${PATCH_QUIET}
    CMAKE_GENERATOR ${CMAKE_GEN}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=${ITK_SHARED_LIBRARY}
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_SKIP_RPATH:BOOL=OFF
        -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
        -DMACOSX_RPATH:BOOL=ON
        -DCMAKE_INSTALL_RPATH:PATH=${install_prefix}/lib${LIB_SUFFIX}
        ${CMAKE_EXTERNAL_PROJECT_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DITK_USE_REVIEW:BOOL=ON
        -DModule_ITKIOMINC:BOOL=ON
        -DModule_ITKIOTransformMINC:BOOL=ON
        -DITK_USE_SYSTEM_MINC:BOOL=ON
        -DITK_USE_SYSTEM_HDF5:BOOL=ON
        -DITK_USE_SYSTEM_ZLIB:BOOL=ON
        -DHAVE_ZLIB:BOOL=ON
        -DITK_USE_FFTWD:BOOL=ON
        -DITK_USE_FFTWF:BOOL=ON
        -DITK_USE_SYSTEM_FFTW:BOOL=ON
        -DFFTWD_LIB:FILEPATH=${FFTW3D_LIBRARY}
        -DFFTWD_THREADS_LIB:FILEPATH=${FFTW3D_THREADS_LIBRARY}
        -DFFTWF_LIB:FILEPATH=${FFTW3F_LIBRARY}
        -DFFTWF_THREADS_LIB:FILEPATH=${FFTW3F_THREADS_LIBRARY}
        -DFFTW_INCLUDE_PATH:PATH=${FFTW3D_INCLUDE_DIR}
        -DLIBMINC_DIR:PATH=${minc_dir}
        -DHDF5_CXX_COMPILER_EXECUTABLE:FILEPATH=${hdf_bin_dir}/h5c++
        -DHDF5_C_COMPILER_EXECUTABLE:FILEPATH=${hdf_bin_dir}/h5cc
        -DHDF5_DIFF_EXECUTABLE:FILEPATH=${hdf_bin_dir}/h5diff
        -DHDF5_CXX_INCLUDE_DIR:PATH=${hdf_include_dir}
        -DHDF5_C_INCLUDE_DIR:PATH=${hdf_include_dir}
        -DHDF5_hdf5_LIBRARY:FILEPATH=${HDF5_LIBRARY}
        -DHDF5_hdf5_cpp_LIBRARY:FILEPATH=${HDF5_CPP_LIBRARY}
        -DHDF5_hdf5_LIBRARY_RELEASE:FILEPATH=${HDF5_LIBRARY}
        -DHDF5_hdf5_cpp_LIBRARY_RELEASE:FILEPATH=${HDF5_CPP_LIBRARY}
        -DHDF5_hdf5_LIBRARY_DEBUG:FILEPATH=${HDF5_LIBRARY}
        -DHDF5_hdf5_cpp_LIBRARY_DEBUG:FILEPATH=${HDF5_CPP_LIBRARY}
        -DHDF5_DIR:PATH=HDF5_DIR-NOTFOUND
        -DHDF5_Fortran_COMPILER_EXECUTABLE:FILEPATH=''
        -DZLIB_LIBRARY:PATH=${zlib_library}
        -DZLIB_INCLUDE_DIR:PATH=${zlib_include_dir}
        -DITK_LEGACY_REMOVE:BOOL=OFF
    INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
    INSTALL_DIR ${staging_prefix}/${install_prefix}
    STEP_TARGETS PatchInstall
  )
  
  ExternalProject_Add_Step(ITKv4 PatchInstall 
    COMMAND ${CMAKE_COMMAND} -Dstaging_prefix=${staging_prefix} -Dminc_dir=${minc_dir} -Dinstall_prefix=${install_prefix} -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/PatchITKv4.cmake
    COMMENT "Patching ITKv4 Build"
    DEPENDEES install
    )
  
  # let's patch targets to remove staging directory
  
  
  SET(ITK_DIR ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build)
  
  SET(ITK_INCLUDE_DIRS 
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Algorithms
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/BasicFilters
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Common
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Numerics
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/IO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Numerics/FEM
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Numerics/NeuralNetworks
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/SpatialObject
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/MetaIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/NrrdIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/NrrdIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/DICOMParser
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/DICOMParser
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/expat
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/expat
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/nifti/niftilib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/nifti/znzlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/itkExtHdrs
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/vxl/v3p/netlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/vxl/vcl
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/vxl/core
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/vxl/v3p/netlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/vxl/vcl
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/vxl/core
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/Utilities/gdcm
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Utilities/gdcm/src
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Review
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv4/Code/Review/Statistics)

# The ITK library directories.
  SET(ITK_LIBRARY_DIRS "${CMAKE_CURRENT_BINARY_DIR}/ITKv4-build/bin")
  
  SET(ITK_LIBRARIES  
          ITKAlgorithms ITKStatistics 
          ITKNumerics 
          ITKFEM ITKQuadEdgeMesh 
          ITKBasicFilters  ITKIO ITKNrrdIO 
          ITKSpatialObject ITKMetaIO
          ITKDICOMParser ITKEXPAT
          ITKniftiio ITKTransformIOReview  ITKCommon ITKznz 
          itkgdcm itkpng itktiff itkzlib itkvcl 
          itkvcl 
          itkv3p_lsqr  itkvnl_algo itkvnl_inst itkvnl itkv3p_netlib 
          itksys itkjpeg8 itkjpeg12 itkjpeg16 itkopenjpeg  hdf5_cpp hdf5
          ${CMAKE_THREAD_LIBS_INIT}
          )

  IF(UNIX)
    SET(ITK_LIBRARIES  ${ITK_LIBRARIES} dl)
  ENDIF(UNIX)

endmacro(build_itkv4)
