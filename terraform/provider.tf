# provider.tf

provider "github" {
  token = var.github_token
  owner = var.github_org
}
