# minc-toolkit configuration parameters for @MINC_TOOLKIT_VERSION_FULL@

setenv MINC_TOOLKIT_VERSION "@MINC_TOOLKIT_VERSION_FULL@"
setenv PATH @CMAKE_INSTALL_PREFIX@/bin:@CMAKE_INSTALL_PREFIX@/pipeline:${PATH}

if ( ! ${?PERL5LIB} ) then
setenv PERL5LIB @CMAKE_INSTALL_PREFIX@/perl:@CMAKE_INSTALL_PREFIX@/pipeline
else
setenv PERL5LIB @CMAKE_INSTALL_PREFIX@/perl:@CMAKE_INSTALL_PREFIX@/pipeline:${PERL5LIB}
endif

if ( ! ${?LD_LIBRARY_PATH} ) then
setenv LD_LIBRARY_PATH @CMAKE_INSTALL_PREFIX@/lib@LIB_SUFFIX@:@CMAKE_INSTALL_PREFIX@/lib@LIB_SUFFIX@/InsightToolkit
else
setenv LD_LIBRARY_PATH @CMAKE_INSTALL_PREFIX@/lib:@CMAKE_INSTALL_PREFIX@/lib@LIB_SUFFIX@/InsightToolkit:${LD_LIBRARY_PATH}
endif

if ( ! ${?MANPATH} ) then
setenv MANPATH @CMAKE_INSTALL_PREFIX@/man
else
setenv MANPATH @CMAKE_INSTALL_PREFIX@/man:${MANPATH}
endif

setenv MNI_DATAPATH @CMAKE_INSTALL_PREFIX@/share

setenv MINC_FORCE_V2 1
setenv MINC_COMPRESS 4
setenv VOLUME_CACHE_THRESHOLD -1
