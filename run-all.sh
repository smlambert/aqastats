function allversions () { 
    for PLATFORM in $PLATFORMS
    do
        for VERSION in $VERSIONS
        do 
            bash ./compute.sh $VERSION $PLATFORM
        done
    done
}
PLATFORMS="x86-64_linux x86-64_windows x86-64_mac x86-32_windows aarch64_linux ppc64le_linux ppc64_aix arm_linux x86-64_alpine-linux x86-64_solaris sparcv9_solaris" 
VERSIONS="8"
allversions 
PLATFORMS="x86-64_linux x86-64_windows x86-64_mac x86-32_windows aarch64_linux ppc64le_linux ppc64_aix arm_linux x86-64_alpine-linux s390x_linux aarch64_mac"
VERSIONS="11 17 19"
allversions