# data.tf

data "github_repositories" "all_repos" {
  query = "org:${var.github_org}"
}

data "github_repositories" "terraform_repos" {
  query = "org:${var.github_org} terraform in:name"
}

data "github_repositories" "kong_repos" {
  query = "org:${var.github_org} kong in:name"
}
