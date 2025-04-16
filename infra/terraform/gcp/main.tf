provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

resource "google_storage_bucket" "my_bucket" {
  name     = "my-unique-gcp-bucket-name"
  location = "US"
}

resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}

output "instance_id" {
  value = google_compute_instance.my_instance.id
}
