variable "name" {
  description = "Repository name"
  type        = string
}

variable "force_delete" {
  description = "Allow deleting the repository even if it still has images"
  type        = bool
  default     = false
}

variable "max_image_count" {
  description = "How many images to keep, older ones are expired"
  type        = number
  default     = 20
}
