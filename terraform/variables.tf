# variables.tf

variable "github_token" {
  description = "GitHub token with appropriate permissions"
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = ""
}

variable "repositories" {
  description = "List of repositories to manage"
  type        = list(string)
}
