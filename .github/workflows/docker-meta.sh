#!/usr/bin/env bash
set -e
IMG_NAME="ghcr.io/$GITHUB_REPOSITORY"
IMG_VER=""
IMG_TAGS=""
if [[ $GITHUB_EVENT_NAME == 'push' ]]; then
	IMG_VER=${GITHUB_SHA::7} # e.g. badbeef

	# e.g. two tags: badbeef, main
	IMG_TAGS="$IMG_NAME:$IMG_VER,$IMG_NAME:main"
elif [[ $GITHUB_EVENT_NAME == 'release' ]]; then
	if [[ "$GITHUB_REF" =~ ^refs/tags/v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		IMG_VER=${GITHUB_REF#refs/tags/} # e.g. v1.2.3
		IMG_MAJ_MIN=${IMG_VER%.*} # e.g. v1.2
		IMG_MAJ=${IMG_MAJ_MIN%.*} # e.g. v1

		# e.g. four tags: v1.2.3, v1.2, v1, latest
		IMG_TAGS="$IMG_NAME:$IMG_VER,$IMG_NAME:$IMG_MAJ_MIN,$IMG_NAME:$IMG_MAJ,$IMG_NAME:latest"
	else
		echo 'Unknown GITHUB_REF format, cannot construct image tags.'
	fi
fi
echo ::set-output name=date::$(date -u +'%Y-%m-%dT%H:%M:%SZ')
echo ::set-output name=version::${IMG_VER}
echo ::set-output name=tags::${IMG_TAGS}
