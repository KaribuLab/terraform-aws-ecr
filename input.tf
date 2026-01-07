variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The image tag mutability of the repository"
  type        = string
  default     = "MUTABLE"
}

variable "lifecycle_policy" {
  description = "The lifecycle policy of the repository"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "repository_policy" {
  description = "The repository policy JSON document. If null, no policy is attached."
  type        = string
  default     = null
}