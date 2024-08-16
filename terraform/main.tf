# main.tf

# Apply ruleset to all repositories
resource "github_repository_ruleset" "pr_ruleset_all" {
  for_each    = toset(data.github_repositories.all_repos.names)
  name        = "protect-main-branch-${each.key}-pre-commit"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      required_check {
        context = "pre-commit"
      }
      strict_required_status_checks_policy = true
    }
  }

  bypass_actors {
    actor_id    = "952934"
    actor_type  = "Integration"
    bypass_mode = "always"
  }
}

# Apply ruleset to repositories with 'terraform' in their name
resource "github_repository_ruleset" "pr_ruleset_terraform" {
  for_each    = toset(data.github_repositories.terraform_repos.names)
  name        = "protect-main-branch-${each.key}-terraform-plan"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      required_check {
        context = "terraform"
      }
      strict_required_status_checks_policy = true
    }
  }

  bypass_actors {
    actor_id    = "952934"
    actor_type  = "Integration"
    bypass_mode = "always"
  }
}

locals {
  combined_repos = toset(concat(
    data.github_repositories.kong_repos.names,
    ["multi-arch-fpm"]
  ))
}

# Apply ruleset to repositories with 'kong' in their name
resource "github_repository_ruleset" "pr_ruleset_kong" {
  for_each    = local.combined_repos
  name        = "protect-main-branch-${each.key}-release"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      required_check {
        context = "Done"
      }
      strict_required_status_checks_policy = true
    }
  }

  bypass_actors {
    actor_id    = "952934"
    actor_type  = "Integration"
    bypass_mode = "always"
  }
}
