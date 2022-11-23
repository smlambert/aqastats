VERSION=$1 
PLATFORM=$2
if [ -z $VERSION ]; then 
    echo "Usage $0 version-number [platform]"
    exit 
fi

# VERSION list is 8 11 17 19
# PLATFORM list for   8: x86-64_linux x86-64_windows x86-64_mac x86-32_windows aarch64_linux ppc64le_linux ppc64_aix arm_linux x86-64_alpine-linux x86-64_solaris sparcv9_solaris 
# PLATFORM list for 11+: x86-64_linux x86-64_windows x86-64_mac x86-32_windows aarch64_linux ppc64le_linux ppc64_aix arm_linux x86-64_alpine-linux s390x_linux aarch64_mac
if [ -z $PLATFORM ]; then
    PLATFORM="x86-64_linux"
fi 

mkdir -p data  
#get all files 
for group in system openjdk perf functional external
do
  echo "getTestAvgDuration for: $group on version $VERSION $PLATFORM "
  TEST_INFO=data/aqa${VERSION}-${group}.json
  curl -s -X 'GET' \
    "https://trss.adoptium.net/api/getTestAvgDuration?jdkVersion=$VERSION&platform=$PLATFORM&group=$group" \
    -H 'accept: application/json' > $TEST_INFO  
done
 
# Compute Totals for all groups
TOTAL_TIME=0
for group in system openjdk perf functional external
do 
  TEST_INFO=data/aqa${VERSION}-${group}.json 
  GROUPTIME=$(cat $TEST_INFO | jq ".testListTime[0]")
  TOTAL_TIME=$(echo $TOTAL_TIME+$GROUPTIME | bc) 
done 
TOTAL_TIME_HRS=$(echo "scale=2; $TOTAL_TIME / 1000 / 60 / 60" | bc)

echo "TOTAL_TIME_HRS: $TOTAL_TIME_HRS TOTAL_TIME: $TOTAL_TIME"

OUT=stats/aqastats-${PLATFORM}-${VERSION}.md
echo "## Platform: ${PLATFORM} Version: ${VERSION} " > $OUT
echo "### Total time across all groups $TOTAL_TIME_HRS hrs " >> $OUT
echo "---" >> $OUT
echo 
for group in system openjdk perf functional external
do 
  TEST_INFO=data/aqa${VERSION}-${group}.json 
  node format.js $TEST_INFO ${group} | tee -a $OUT 
done

