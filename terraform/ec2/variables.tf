variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "ip_allowlist" {
  type = list(string)
}