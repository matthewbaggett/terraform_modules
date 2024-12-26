variable "username" {
  type        = string
  description = "Set this identity's username"
  default     = null
}
variable "username_max_length" {
  type        = number
  default     = 32
  description = "The maximum length of the username"
}
variable "username_separator" {
  type        = string
  description = "The separator for the username"
  default     = ""
}
variable "username_words" {
  type        = number
  description = "The number of words to include in the username."
  default     = null
  validation {
    error_message = "username_words must be between 1 and 5 or null."
    condition     = var.username_words == null || (try(var.username_words >= 1, false) && try(var.username_words <= 5, false))
  }
}

variable "password" {
  type        = string
  description = "Set this identity's password"
  default     = null
}
variable "password_length" {
  type        = number
  description = "The length of the password"
  default     = 32
  validation {
    error_message = "password_length must be between 8 and 64."
    condition     = var.password_length >= 8 && var.password_length <= 64
  }
}
variable "password_special_characters" {
  type        = string
  description = "Special characters to include in the password"
  default     = "!*-_><?"
}