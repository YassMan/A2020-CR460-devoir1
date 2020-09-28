provider "google" {
project = "a2020-cr460-yassine"
credentials="account.json"
region= "us-east1"
zone="us-east1-b"

}
////////////////-------Fermier------------/////////////////
resource "google_compute_instance" "vm_instance" {
  name         = "fermier"
  machine_type = "f1-micro"
  //zone         = "us-central1-c"

  tags = ["fermier"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    //  image = "debian-cloud/debian-9"
    }
  }

  network_interface {
  //  network = "default"
network = google_compute_network.vpc_network.self_link
  //  access_config {
      // Ephemeral IPS gien an external ip
  //  }
  }
  }


    ////////////////-------mouton------------/////////////////
    resource "google_compute_instance" "vm_instance1" {
      name         = "mouton"
      machine_type = "f1-micro"
      //zone         = "us-central1-c"

     tags = [ "public"]

      boot_disk {
        initialize_params {
          image = "fedora-coreos-cloud/fedora-coreos-stable"
        }
      }
    // Local SSD disk
  //  scratch_disk {
    //  interface = "SCSI"
    //}

    network_interface {
      subnetwork = google_compute_subnetwork.prod-dmz.name

      access_config {
        // Ephemeral IPS give an  external ip
      }
    }

  //metadata_startup_script = "echo hi > /test.txt"
    }


  ////////////////-------Canard------------/////////////////
  resource "google_compute_instance" "vm_instance2" {
    name         = "canard"
    machine_type = "f1-micro"
    //zone         = "us-central1-c"

//  tags = [ ""]

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-9"
      }
    }
  // Local SSD disk
//  scratch_disk {
  //  interface = "SCSI"
  //}

  network_interface {
    subnetwork = google_compute_subnetwork.prod-dmz.name

    access_config {
      // Ephemeral IPS give an  external ip
    }
  }

  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"

  }

  ////////////////-------Cheval------------/////////////////
  resource "google_compute_instance" "vm_instance3" {
    name         = "cheval"
    machine_type = "f1-micro"
    //zone         = "us-central1-c"

    tags = ["traitement"]

    boot_disk {
      initialize_params {
        image = "fedora-coreos-cloud/fedora-coreos-stable"
      }
    }
  // Local SSD disk
//  scratch_disk {
  //  interface = "SCSI"
  //}

  network_interface {
    subnetwork = google_compute_subnetwork.prod-traitement.name

    access_config {
      // Ephemeral IPS give an  external ip
    }
  }

//metadata_startup_script = "echo hi > /test.txt"
  }



  resource "google_compute_network" "vpc_network" {
name = "devoir1"
  }


/////////////-------- Sub nets---------////////////
  resource "google_compute_subnetwork" "prod-dmz" {
    name          = "prod-dmz"
    ip_cidr_range = "172.163.3.0/24"
    region        = "us-east1"
    network       = google_compute_network.vpc_network.self_link
  }

  resource "google_compute_subnetwork" "prod-interne" {
    name          = "prod-interne"
    ip_cidr_range = "10.0.3.0/24"
    region        = "us-east1"
    network       = google_compute_network.vpc_network.self_link
  }

  resource "google_compute_subnetwork" "prod-traitement" {
    name          = "prod-traitement"
    ip_cidr_range = "10.0.2.0/24"
    region        = "us-east1"
    network       = google_compute_network.vpc_network.self_link
  }

  /////////////-------- FireWall---------////////////

  /*  resource "google_compute_firewall" "external-http" {
    name    = "external-http"
    network = google_compute_network.devoir1.name
    allow {
      protocol = "tcp"
      ports    = ["22"]
    }

  }
/*  resource "google_compute_firewall" "external-ssh" {
  name    = "external-ssh"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}

/*resource "google_compute_firewall" "internal-control" {
  name    = "internal-control"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["2846","5462" ]
  }
  source_ranges=["10.0.2.0/24"]
target_tags["interne"]

}*/
