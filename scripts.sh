#!/bin/bash

determine_version() {
  ARTIFACT_ID=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
  echo "ARTIFACT_ID=$ARTIFACT_ID" >> $GITHUB_ENV

  if [[ $GITHUB_REF == refs/heads/release/* ]]; then
    VERSION=${GITHUB_REF#refs/heads/release/}
  elif [[ $GITHUB_REF == refs/tags/* ]]; then
    VERSION=${GITHUB_REF#refs/tags/}
  elif [[ $GITHUB_REF == refs/heads/main ]]; then
   git fetch --all
    LATEST_RELEASE=$(git branch -r | grep 'origin/release/' | sed 's|origin/release/||' | sort -V | tail -n 1 | xargs echo -n)
    if [[ -n $LATEST_RELEASE ]]; then
        VERSION=$LATEST_RELEASE
    else
        return 1
    fi
  elif [[ $GITHUB_REF == refs/heads/feature/* ]]; then
    git fetch --all
    # Find the latest release version
    LATEST_RELEASE=$(git branch -r | grep 'origin/feature/.*-1\.0\..*' | sed 's|origin/feature/||' | sort -V | tail -n 1 | xargs echo -n)
    if [[ -n $LATEST_RELEASE ]]; then
      VERSION="$LATEST_RELEASE-SNPASHOT.jar"
    else
        echo 'could not find the latest release version'
        return 1
    fi
  elif [[ $GITHUB_REF == refs/pull/* ]]; then
    # Extract the base branch from the pull request reference
    BASE_BRANCH=$(jq -r '.base.ref' "$GITHUB_EVENT_PATH")
    if [[ $BASE_BRANCH == main ]]; then
      # Find the latest release version
      git fetch --all
      LATEST_RELEASE=$(git branch -r | grep 'origin/release/' | sed 's|origin/release/||' | sort -V | tail -n 1 | xargs echo -n)
      if [[ -n $LATEST_RELEASE ]]; then
          VERSION=$LATEST_RELEASE
      else
          echo 'could not find the latest release version'
          return 1
      fi
  else
    echo 'could not determine the version'
    return 1
  fi
  echo "VERSION=$VERSION" >> $GITHUB_ENV
 fi
}


update_pom_version() {
  mvn -q versions:set -DnewVersion=${VERSION}
  mvn -q versions:commit
}

clean_compile_run() {
  mvn -q -B clean compile exec:java
}

build_package() {
  mvn -B package --file pom.xml > /dev/null
}

verify_docker_image() {
  docker run --rm $DOCKER_USERNAME/myapp:latest
}