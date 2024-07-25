# main.tf

# Update repository settings for all repositories
resource "github_repository" "settings_all" {
  for_each = { for repo in var.repositories : repo.name => repo }
  name     = each.key

  visibility             = "public"
  has_issues             = false
  has_wiki               = false
  has_projects           = false
  allow_merge_commit     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true

  dynamic "template" {
    for_each = each.value.template != "" ? [1] : []
    content {
      owner      = var.github_org
      repository = each.value.template
    }
  }
}

# Apply ruleset to all repositories
resource "github_repository_ruleset" "pr_ruleset_all" {
  for_each    = toset(data.github_repositories.all_repos.names)
  name        = "protect-main-branch-${each.key}"
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
}

# Apply ruleset to repositories with 'terraform' in their name
resource "github_repository_ruleset" "pr_ruleset_terraform" {
  for_each    = toset(data.github_repositories.terraform_repos.names)
  name        = "protect-main-branch-terraform-${each.key}"
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
      required_check {
        context = "terraform"
      }
      strict_required_status_checks_policy = true
    }
  }
}

# Apply ruleset to repositories with 'kong' in their name
resource "github_repository_ruleset" "pr_ruleset_kong" {
  for_each    = toset(data.github_repositories.kong_repos.names)
  name        = "protect-main-branch-kong-${each.key}"
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
      required_check {
        context = "done"
      }
      strict_required_status_checks_policy = true
    }
  }
}
