This repository is a fork of the Hello World Maven project. It includes a GitHub Actions pipeline that automates the build, test, packaging, and deployment process. The pipeline performs the following tasks:

	•	Check for Changes: Detects modifications in the myapp directory.
	•	Build the Application: Compiles and packages the Java application.
	•	Version Management: Automatically determines and updates the version.
	•	Artifact Handling: Uploads the JAR file as an artifact.
	•	Docker Integration: Builds and pushes a Docker image to Docker Hub.
	•	Deployment Verification: Runs the Docker image to verify deployment.

How to Trigger the Pipeline

The pipeline is automatically triggered by the following events:

	•	Pushing a branch that starts with release/1.0.x.
	•	Pushing a branch that starts with feature/*-1.0.x.
	•	Creating a pull request to merge into the main branch.
	•	Pushing a tag that starts with 1.0.x.

Deploying a Release Version

To deploy a release version:

	1.	Prepare the Release Branch:
	•	Create or update a branch named release/* (e.g., release/v1.0.0).
	•	Push your changes to this branch.
	2.	Push Changes or Tags:
	•	Push changes to the release/* branch, or push a tag to the repository.
	•	The pipeline will:
	1.	Check for changes in the myapp directory.
	2.	Set up JDK 17 and Maven.
	3.	Move necessary scripts to the appropriate directory.
	4.	Determine the version and update the POM file if needed.
	5.	Build, package, and upload the JAR file.
	6.	Build and push a Docker image to Docker Hub.
	7.	Verify the Docker image by running it.

Secrets Configuration

Ensure the following secrets are set in your GitHub repository:

	•	DOCKER_USERNAME: Your Docker Hub username.
	•	DOCKER_PASSWORD: Your Docker Hub password.

Scripts

The pipeline uses a script (scripts.sh) that handles:

	•	Determining the application version.
	•	Updating the POM version.
	•	Cleaning, compiling, and running the application.
	•	Packaging the application into a JAR file.

This script is moved and sourced as part of the pipeline steps to ensure all functions are available during the build process.
