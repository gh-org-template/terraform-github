# data.tf

data "github_repositories" "all_repos" {
  query = "org:${var.github_org}"
}
