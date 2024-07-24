# main.tf

resource "github_organization_ruleset" "pr_ruleset" {
  name        = "require-pull-requests"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
    repository_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = true
    required_signatures     = true

    pull_request {
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 1
      required_review_thread_resolution = false
    }
  }
}
