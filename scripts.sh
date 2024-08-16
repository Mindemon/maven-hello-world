#!/bin/bash

determine_version() {
  ARTIFACT_ID=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
  echo "ARTIFACT_ID=$ARTIFACT_ID" >> $GITHUB_ENV
  if [[ $GITHUB_REF == refs/tags/* ]]; then
    TAGV=${GITHUB_REF#refs/tags/}
  else
    TAGV="1.0.0"
  fi
  echo "TAGV=$TAGV" >> $GITHUB_ENV
}

update_pom_version() {
  mvn -q versions:set -DnewVersion=${TAGV}
  mvn -q versions:commit
}

clean_compile_run() {
  mvn -q clean compile exec:java
}

build_package() {
  mvn -B package --file pom.xml > /dev/null
}

verify_docker_image() {
  docker run --rm $DOCKER_USERNAME/myapp:latest
}