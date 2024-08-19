# Maven CI/CD Pipeline

This repository contains a Maven-based Java project with a CI/CD pipeline configured using GitHub Actions. The pipeline handles version determination, building, testing, packaging, and Docker image creation and deployment.

## Prerequisites

- Docker
- Maven
- GitHub account with access to this repository
- Docker Hub account

## Repository Structure

- `myapp/`: Contains the Java application source code and `pom.xml`.
- `scripts.sh`: Contains shell functions used in the CI/CD pipeline.
- `.github/workflows/maven.yml`: GitHub Actions workflow file for the CI/CD pipeline.

## CI/CD Pipeline

The CI/CD pipeline is defined in `.github/workflows/maven.yml` and includes the following steps:

1. **Checkout Code**: Checks out the repository code.
2. **Set up JDK 17**: Sets up Java Development Kit version 17.
3. **Fetch All Branches**: Fetches all branches from the repository.
4. **Move Script**: Moves the `scripts.sh` file to the `myapp/scripts/` directory.
5. **Source Build Functions**: Sources the shell functions from the script.
6. **Determine Version**: Determines the version based on the Git reference.
7. **Update POM Version**: Updates the Maven `pom.xml` file with the determined version.
8. **Clean, Compile, and Run**: Cleans, compiles, and runs the Java application.
9. **Build and Package**: Builds and packages the Java application.
10. **Upload Artifact**: Uploads the built JAR file as an artifact.
11. **Log in to Docker Hub**: Logs in to Docker Hub using secrets.
12. **Build and Push Docker Image**: Builds and pushes the Docker image to Docker Hub.
13. **Verify Docker Image**: Runs the Docker image to verify it works correctly.

### GitHub Actions Triggers

The pipeline is triggered on the following events:

- **Push to Branches**: Triggered on push to branches matching `release/1.0.*` or `feature/*-1.0.*`.
- **Push of Tags**: Triggered on push of tags matching `1.0.*`.
- **Pull Request Closed**: Triggered when a pull request is closed on the `main` branch.

### Versioning

The versioning logic is handled in the `scripts.sh` file. Here is an excerpt from the file:

```shell
elif [[ $GITHUB_REF == refs/pull/* ]]; then
    # Extract the base branch from the pull request reference
    BASE_BRANCH=$(jq -r '.base.ref' "$GITHUB_EVENT_PATH")
    if [[ $BASE_BRANCH == main ]]; then
      # Find the latest release version
      git fetch --all
      LATEST_RELEASE=$(git branch -r | grep 'origin/release/' | sed 's|origin/release/||' | sort -V | tail -n 1 | xargs echo -n)
      if [[ -n $LATEST_RELEASE ]]; then
          VERSION=$LATEST_RELEASE
           echo "VERSION=$VERSION" >> $GITHUB_ENV
      else
          echo 'could not find the latest release version'
          return 1
      fi
  else
    echo 'could not determine the version'
    return 1
 fi
 fi
}


update_pom_version() {
  echo ${VERSION}
  mvn -q -B versions:set -DnewVersion=${VERSION}
  mvn -q -B versions:commit
}


How Versioning Works
Push to Feature Branch:

When you push to a branch matching feature/*-1.0.*, the version is determined based on the branch name.
For example, if you push to feature/new-feature-1.0.2, the version will be set to 1.0.2.
The JAR file will be named myapp-1.0.2.jar.
Push to Release Branch:

When you push to a branch matching release/1.0.*, the version is determined based on the branch name.
For example, if you push to release/1.0.3, the version will be set to 1.0.3.
The JAR file will be named myapp-1.0.3.jar.
Push of Tags:

When you push a tag matching 1.0.*, the version is determined based on the tag name.
For example, if you push the tag 1.0.4, the version will be set to 1.0.4.
The JAR file will be named myapp-1.0.4.jar.
Pull Request Closed:

When a pull request is closed on the main branch, the version is determined based on the latest release branch.
The script fetches all branches and finds the latest release version.
For example, if the latest release branch is release/1.0.5, the version will be set to 1.0.5.
The JAR file will be named myapp-1.0.5.jar.



## Local Development

### Clone the Repository:
Local Development
Clone the Repository:
git clone https://github.com/your-username/your-repo.git
cd your-repo

Build the Project:
mvn clean install

Run the Application:
mvn exec:java
NOTE: if you have arm cpu and not x86  you need to build the dockerfile with arm64 platform 

docker build --platform linux/arm64   --build-arg BUILD_VERSION=1.0.1  -t myapp:m1 .

Docker
Build Docker Image:
docker build --build-arg BUILD_VERSION=1.0.1 -t myapp:latest .
Run Docker Container:
docker run --rm myapp:m1
Push Docker Image to Docker Hub:


docker tag myapp:m1 your-dockerhub-username/myapp:latest 
docker push your-dockerhub-username/myapp:m1
Push Docker Image to Docker Hub:


