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

variable "repositories" {
  description = "List of repositories to manage with their templates"
  type = list(object({
    name     = string
    template = string
  }))
  default = []
}

variable "private_repositories" {
  description = "List of repositories to manage with their templates"
  type = list(object({
    name     = string
    template = string
  }))
  default = []
}
