variable "nsg_associations" {
  description = "Map of subnet to NSG associations to create"
  type        = map(any)
}
