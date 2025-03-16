# Hello World API

## Overview

This project is a simple REST API built using FastAPI, containerized using Docker, and deployed to AWS ECS Fargate using Terraform.

## API Endpoints

- **GET /hello_world** - Returns `{ "message": "Hello World!" }`
- **GET /current_time?name=some_name** - Returns `{ "timestamp": <epoch_time>, "message": "Hello some_name" }`
- **GET /healthcheck** - Returns `{ "status": "healthy" }`

## Building the Docker Image

```sh
docker build -t hello-world-api .
```

## Running the Image Locally

```sh
docker run -p 8000:8000 hello-world-api
```

## Tagging and Pushing to AWS ECR

```sh
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

docker tag hello-world-api:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/hello-world-api:latest

docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/hello-world-api:latest
```

## Improvements to the hello-world project

- Add app tests(both unit and integration tests and maybe end to end)
- Lock version on the `requirements.txt` file
- Have a more structured `infrastucture` folder with subfolders for each environment
- Update the CI/CD pipeline using GitHub Actions to use reusable workflows actions and to be environment aware
- Surely have a better structured and reusable terraform code, with modules expedited by us with all security locking necessary
- Pin all terraform modules to a specific version
- Add necessary tags to the resources
- Omitted from the simple diagram pieces like `Security Groups`, `Internet Gateway`, `NAT Gateway`, `Route Table`, etc.
