VERSION=$1 
PLATFORM=$2
if [ -z $VERSION ]; then 
    echo "Usage $0 version-number [platform]"
    exit 
fi

if [ -z $PLATFORM ]; then
    PLATFORM="x86-64_linux"
fi

TEST_INFO=data/aqa${VERSION}.json
mkdir -p data

echo "getTestAvgDuration for: $VERSION $PLATFORM "
curl -s -X 'GET' \
  "https://trss.adoptium.net/api/getTestAvgDuration?jdkVersion=$VERSION&platform=$PLATFORM" \
  -H 'accept: application/json' > $TEST_INFO

echo "Fetching Average Test Duration"
cd data
 
echo 
echo "Release data is in $TEST_INFO"
