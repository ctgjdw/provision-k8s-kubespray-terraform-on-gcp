# Input variables
variable "project_id" {
  type        = string
  description = "The ID of the project to create the VM in"
}

variable "instance_name_prefix" {
  type        = string
  description = "The prefix for the instance name"
}

variable "machine_type" {
  type        = string
  description = "The machine type for the instance"
  default     = "e2-standard-2"
}

variable "region" {
  type        = string
  description = "The region for the GCP provider"
  default     = "asia-southeast1"
}

variable "control_plane_count" {
  type        = number
  description = "Number of control plane instances"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of worker instances"
  default     = 1
}

variable "zone" {
  type        = string
  description = "The zone for the instance"
  default     = "asia-southeast1-a"
}

variable "image" {
  type        = string
  description = "The image for the instance"
  default     = "ubuntu-2404-lts-amd64"
}

variable "disk_size" {
  type        = number
  description = "The size of the boot disk"
  default     = 50
}

variable "network" {
  type        = string
  description = "The network for the instance"
}
