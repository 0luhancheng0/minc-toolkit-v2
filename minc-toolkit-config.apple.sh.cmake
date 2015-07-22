# minc-toolkit configuration parameters for @MINC_TOOLKIT_VERSION_FULL@

export MINC_TOOLKIT_VERSION="@MINC_TOOLKIT_VERSION_FULL@"
export PATH=@CMAKE_INSTALL_PREFIX@/bin:@CMAKE_INSTALL_PREFIX@/pipeline:${PATH}
export PERL5LIB=@CMAKE_INSTALL_PREFIX@/perl:@CMAKE_INSTALL_PREFIX@/pipeline:${PERL5LIB}
export DYLD_LIBRARY_PATH=@CMAKE_INSTALL_PREFIX@/lib@LIB_SUFFIX@:@CMAKE_INSTALL_PREFIX@/lib@LIB_SUFFIX@/InsightToolkit:${DYLD_LIBRARY_PATH}
export MNI_DATAPATH=@CMAKE_INSTALL_PREFIX@/share
export MINC_FORCE_V2=1
export MINC_COMPRESS=4
export VOLUME_CACHE_THRESHOLD=-1
export MANPATH=@CMAKE_INSTALL_PREFIX@/man:${MANPATH}