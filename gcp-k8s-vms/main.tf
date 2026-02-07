# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a new network
resource "google_compute_network" "vm_network" {
  name                    = var.network
  auto_create_subnetworks = false
}

# Create a new subnetwork
resource "google_compute_subnetwork" "vm_subnetwork" {
  name          = "vm-subnetwork"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vm_network.id
}

# Create a new instance
resource "google_compute_instance" "control_plane" {
  count        = var.control_plane_count
  name         = "${var.instance_name_prefix}-cp-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vm_subnetwork.id
    access_config {
      nat_ip = google_compute_address.control_plane_ip[count.index].address
    }
  }
}

# Static external IPs for control plane instances
resource "google_compute_address" "control_plane_ip" {
  count        = var.control_plane_count
  name         = "${var.instance_name_prefix}-cp-${count.index}-ip"
  region       = var.region
  address_type = "EXTERNAL"
}

# Static external IPs for worker nodes
resource "google_compute_address" "worker_ip" {
  count        = var.worker_count
  name         = "${var.instance_name_prefix}-worker-${count.index}-ip"
  region       = var.region
  address_type = "EXTERNAL"
}


resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vm_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_kubectl" {
  name    = "allow-kubectl"
  network = google_compute_network.vm_network.name
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Create a new firewall rule to allow internal traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vm_network.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_instance" "worker_nodes" {
  count        = var.worker_count
  name         = "${var.instance_name_prefix}-worker-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vm_subnetwork.id
    access_config {
      nat_ip = google_compute_address.worker_ip[count.index].address
    }
  }
}
