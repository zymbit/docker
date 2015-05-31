#!/bin/bash

set -o errexit

# ENV VARS
VERSION=$(<VERSION)
#ACCOUNT=
#REPO=
#ACCESS_TOKEN=
#sourceBranch=

if [ -z "$ACCOUNT" ] || [ -z "$REPO" ] || [ -z "$ACCESS_TOKEN" ]; then
	echo "Please set value for ACCOUNT, REPO and ACCESS_TOKEN!"
	exit 1
fi

# Create a release
rm -f request.json response.json
cat > request.json <<-EOF
{
    "tag_name": "$VERSION",
    "target_commitish": "$sourceBranch",
    "name": "$VERSION",
    "body": "Release of version $VERSION",
    "draft": false,
    "prerelease": false
}
EOF
curl -d @request.json https://api.github.com/repos/$ACCOUNT/$REPO/releases?access_token=$ACCESS_TOKEN -o response.json
# Parse response
RELEASE_ID=$(cat response.json | jq '.id')
echo "RELEASE_ID=$RELEASE_ID"

# Upload data
# arm
curl -H "Authorization: token $ACCESS_TOKEN" -H "Content-Type: application/octet-stream" --data-binary "@docker-arm-$VERSION.tar.xz" https://uploads.github.com/repos/$ACCOUNT/$REPO/releases/$RELEASE_ID/assets?name=docker-arm-$VERSION.tar.xz
# i386
curl -H "Authorization: token $ACCESS_TOKEN" -H "Content-Type: application/octet-stream" --data-binary "@docker-386-$VERSION.tar.xz" https://uploads.github.com/repos/$ACCOUNT/$REPO/releases/$RELEASE_ID/assets?name=docker-386-$VERSION.tar.xz
