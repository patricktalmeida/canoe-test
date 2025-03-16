provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                           = "cloudposse/vpc/aws"
  name                             = "hello-world-vpc"
  ipv4_primary_cidr_block          = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = false
}

module "dynamic_subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  stage              = "test"
  name               = "hello-world-subnets"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  name   = "hello-world-api"
}

module "ecs" {
  source = "cloudposse/ecs-cluster/aws"

  name = "hello-world-cluster"

  container_insights_enabled = false
  capacity_providers_fargate = true
}

module "alb" {
  source        = "cloudposse/alb/aws"
  name          = "hello-world-lb"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.dynamic_subnets.public_subnet_ids
  internal      = false
  http_enabled  = true
  https_enabled = true
  http_redirect = true
}

module "ecs_service" {
  source          = "cloudposse/ecs-alb-service-task/aws"
  name            = "hello-world-service"
  ecs_cluster_arn = module.ecs.arn
  vpc_id          = module.vpc.vpc_id
  launch_type     = "FARGATE"
  desired_count   = 2
  container_definition_json = jsonencode([
    {
      "name" : "hello-world-api",
      "image" : "${module.ecr.repository_url}:latest",
      "memory" : 512,
      "cpu" : 256,
      "essential" : true,
      "portMappings" : [{ "containerPort" : 8000, "hostPort" : 8000 }]
    }
  ])
  security_group_ids = [module.vpc.vpc_default_security_group_id]
  subnet_ids         = module.dynamic_subnets.private_subnet_ids
  assign_public_ip   = false
}
