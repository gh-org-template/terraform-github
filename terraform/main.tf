# main.tf
locals {
  combined_repos = toset(concat(
    data.github_repositories.kong_repos.names,
    ["multi-arch-fpm", "template-1-github-release"]
  ))
  timestamp = formatdate("YYYYMMDD-HHMMss", timestamp())
}

resource "github_repository" "settings_all" {
  for_each = { for repo in var.repositories : repo.name => repo }
  name     = each.key

  private                = lookup(each.value, "private", false) # Toggle repository privacy using 'private'
  has_issues             = false
  has_wiki               = false
  has_projects           = false
  allow_merge_commit     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
  is_template            = contains(split("-", each.key), "template") ? true : false

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
  name        = "protect-main-branch-${each.key}-pre-commit-${local.timestamp}"
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
  name        = "protect-main-branch-${each.key}-terraform-plan-${local.timestamp}"
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


# Apply ruleset to repositories with 'kong' in their name
resource "github_repository_ruleset" "pr_ruleset_kong" {
  for_each    = local.combined_repos
  name        = "protect-main-branch-${each.key}-release-${local.timestamp}"
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
