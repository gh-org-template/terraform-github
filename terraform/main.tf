# main.tf

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
