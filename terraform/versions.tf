# versions.tf

terraform {
  required_version = ">= 0.13"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0" # Ensure to use the latest appropriate version
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}
