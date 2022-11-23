VERSION=$1 
PLATFORM=$2
if [ -z $VERSION ]; then 
    echo "Usage $0 version-number [platform]"
    exit 
fi

if [ -z $PLATFORM ]; then
    PLATFORM="x86-64_linux"
fi

mkdir -p data 
OUT=stats/aqastats-${PLATFORM}-${VERSION}.md
echo "## Platform: ${PLATFORM} Version: ${VERSION} " > $OUT
for group in system openjdk perf functional external
do
  echo "getTestAvgDuration for: $VERSION $PLATFORM "
  TEST_INFO=data/aqa${VERSION}-${group}.json
  curl -s -X 'GET' \
    "https://trss.adoptium.net/api/getTestAvgDuration?jdkVersion=$VERSION&platform=$PLATFORM&group=$group" \
    -H 'accept: application/json' > $TEST_INFO
  node format.js $TEST_INFO ${group} | tee -a $OUT

done

