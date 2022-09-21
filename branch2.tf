# Create branch2 office.  Use network tags to steer branch2 VMs to VM-Series in branch2

locals {
  branch2 = "branch2"
}

#---------------------------------------------------------------------------------------------------------------------------
module "branch2_vmseries" {
  source                = "PaloAltoNetworks/vmseries-modules/google//modules/vmseries"
  name                  = "${local.branch2}-vmseries"
  zone                  = data.google_compute_zones.main.names[0]
  ssh_keys              = fileexists(var.public_key_path) ? "admin:${file(var.public_key_path)}" : ""
  custom_image          = var.vmseries_image_name
  create_instance_group = false

  metadata = {
    mgmt-interface-swap                  = "enable"
    vmseries-bootstrap-gce-storagebucket = module.bootstrap.bucket_name
    serial-port-enable                   = true
  }

  network_interfaces = [
    {
      subnetwork       = module.vpc_untrust.subnets_self_links[0]
      create_public_ip = true
    },
    {
      subnetwork       = module.vpc_mgmt.subnets_self_links[0]
      create_public_ip = true
    },
    {
      subnetwork = module.vpc_trust.subnets_self_links[0]
    }
  ]

  depends_on = [
    module.bootstrap
  ]
}


#---------------------------------------------------------------------------------------------------------------------------
resource "google_compute_subnetwork" "branch2_subnet" {
  name          = "${local.branch2}-${var.region}-subnet"
  ip_cidr_range = var.cidr_branch2
  region        = var.region
  network       = module.vpc_trust.network_id
}


resource "google_compute_route" "branch2_route" {
  name              = "${local.branch2}-route"
  dest_range        = "0.0.0.0/0"
  network           = module.vpc_trust.network_id
  next_hop_instance = module.branch2_vmseries.self_link
  priority          = 100
  tags              = ["${local.branch2}-route"]
}

#---------------------------------------------------------------------------------------------------------------------------
resource "google_compute_instance" "branch2_vm1" {
  name                      = "${local.branch2}-vm1"
  machine_type              = "f1-micro"
  zone                      = data.google_compute_zones.main.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path) ? "${var.vm_user}:${file(var.public_key_path)}" : ""
  }

  network_interface {
    subnetwork = google_compute_subnetwork.branch2_subnet.id
    network_ip = cidrhost(var.cidr_branch2, 2)
  }

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  service_account {
    scopes = var.vm_scopes
  }

  tags = ["${local.branch2}-route"]
}

resource "google_compute_instance" "branch2_vm2" {
  name                      = "${local.branch2}-vm2"
  machine_type              = var.vm_type
  zone                      = data.google_compute_zones.main.names[0]
  can_ip_forward            = false
  allow_stopping_for_update = true

  metadata = {
    serial-port-enable = true
    ssh-keys           = fileexists(var.public_key_path) ? "${var.vm_user}:${file(var.public_key_path)}" : ""
  }

  network_interface {
    subnetwork = google_compute_subnetwork.branch2_subnet.id
    network_ip = cidrhost(var.cidr_branch2, 3)
  }

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  service_account {
    scopes = var.vm_scopes
  }

  tags = ["${local.branch2}-route"]
}
