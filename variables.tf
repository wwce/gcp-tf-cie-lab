variable "project_id" {
  description = "GCP Project ID to contain the created cloud resources."
  type        = string
  default     = null
}

variable "prefix" {
  description = "Prefix to prepend the resource names (i.e. panw, or your initials).  This is useful for identifing the created resources."
  type        = string
  default     = null
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}


variable "allowed_sources" {
  description = "A list of IP addresses to be added to the management network's ingress firewall rule. The IP addresses will be able to access to the VM-Series management interface."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vmseries_image_name" {
  description = " Link to VM-Series PAN-OS image. Can be either a full self_link, or one of the shortened forms per the [provider doc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#image)."
  type        = string
  default     = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-flex-bundle2-1016"
}

variable "vmseries_instances_min" {
  description = "The minimum number of VM-Series that the autoscaler can scale down to. This cannot be less than 0."
  type        = number
  default     = 1
}

variable "vmseries_instances_max" {
  description = "The maximum number of VM-Series that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of VM-Series should not be lower than minimal number of VM-Series."
  type        = number
  default     = 1
}

variable "vmseries_machine_type" {
  description = "(Optional) The instance type for the VM-Series firewalls."
  type        = string
  default     = "n2-standard-4"
}

variable "public_key_path" {
  description = "Public SSH key for instances."
  type        = string
  default     = "~/.ssh/gcp-demo.pub"
}
variable "autoscaler_metrics" {
  description = <<-EOF
  The map with the keys being metrics identifiers (e.g. custom.googleapis.com/VMSeries/panSessionUtilization).
  Each of the contained objects has attribute `target` which is a numerical threshold for a scale-out or a scale-in.
  Each zonal group grows until it satisfies all the targets.

  Additional optional attribute `type` defines the metric as either `GAUGE` (the default), `DELTA_PER_SECOND`, or `DELTA_PER_MINUTE`.
  For full specification, see the `metric` inside the [provider doc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler).
  EOF
  default = {
    "custom.googleapis.com/VMSeries/panSessionActive" = {
      target = 100
    }
  }
}

variable "cidr_mgmt" {
  description = "The CIDR range of the management subnetwork."
  type        = string
  default     = "10.0.0.0/24"
}

variable "cidr_untrust" {
  description = "The CIDR range of the untrust subnetwork."
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_trust" {
  description = "The CIDR range of the trust subnetwork."
  type        = string
  default     = "10.0.2.0/24"
}

variable "cidr_branch1" {
  description = "The CIDR range of the branch1 subnetwork."
  type        = string
  default     = "10.0.3.0/24"
}

variable "cidr_branch2" {
  description = "The CIDR range of the branch2 subnetwork."
  type        = string
  default     = "10.0.4.0/24"
}

variable "vm_image" {
  description = "Image for backend VM instances."
  default     = "https://www.googleapis.com/compute/v1/projects/panw-gcp-team-testing/global/images/ubuntu-2004-lts-apache"
}

variable "vm_scopes" {
  description = "Scopes for backend VM instances."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "vm_type" {
  description = "Instance type for backend VM instances."
  type        = string
  default     = "f1-micro"
}
variable "vm_user" {
  description = "Username for backend VM instances."
  type        = string
  default     = "paloalto"
}