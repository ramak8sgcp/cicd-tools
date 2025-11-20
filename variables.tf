variable "project" {
    default = "expense"

}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
}

variable "domain_name" {
  default = "ramana3490.online"
}

variable "zone_id" {
    default = "Z00280343M1NSFAEBLQAW"
}


variable "zone_name" {
  type        = string
  default     = "ramana3490.online"
  description = "description"
}