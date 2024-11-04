provider "google" {
  credentials = file("/home/glc300/Downloads/extended-poetry-440019-t7-927e00afaaae.json") # Replace with your service account key path
  project     = var.project_id
  region      = var.region
}

resource "google_compute_instance" "app_server" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}" # Using the image family and project
    }
  }

  network_interface {
    network = "default"
    access_config {} # Allows external IP
  }

  # Metadata for SSH keys
  metadata = {
    ssh-keys = "cwanjau52:${file("/home/glc300/.ssh/wanjau.pub")}"  # Add your SSH key here
  }

  # Provisioner to install Docker and run containers on the VM
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io", # Install Docker

      # Run backend container
      "sudo docker run -d --name backend -p 5000:5000 ${var.backend_image}",

      # Run client container
      "sudo docker run -d --name client -p 3000:3000 ${var.client_image}",

      # Run database container (MongoDB)
      "sudo docker run -d --name database -p 27017:27017 ${var.database_image}"
    ]

    # Connection details for provisioner
    connection {
      type        = "ssh"
      user        = "cwanjau52"
      private_key = file("/home/glc300/.ssh/wanjau") # Replace with your private key path
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # Output IP for Ansible inventory
  provisioner "local-exec" {
    command = "echo '${google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip}' > ../ansible/hosts"
  }
}

output "instance_ip" {
  value = google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip
}

