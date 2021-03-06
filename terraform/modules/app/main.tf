# создаем ресурс вм

resource "google_compute_instance" "app" {
    count        = "${var.app_count}"
    name         = "reddit-app-${var.env}-${format("%02d", count.index+1)}"
    machine_type = "${var.app_machine_type}"
    zone         = "${var.zone}"
    tags         = ["reddit-app"]

    boot_disk {
        initialize_params {
            image = "${var.app_disk_image}"
        }
    }

    network_interface {
        network = "default"

    access_config = {
        nat_ip = "${google_compute_address.app_ip.address}"
        }
    } 

    metadata {
        ssh-keys = "appuser:${file(var.public_key_path)}"
    }

    connection {
        type        = "ssh"
        user        = "appuser"
        agent       = false
        private_key = "${file(var.private_key_path)}"
    }

    provisioner "file" {
        source      = "../modules/app/files/puma.service"
        destination = "/tmp/puma.service"
    }

    provisioner "file" {
        source      = "../modules/app/files/deploy.sh"
        destination = "/tmp/deploy.sh"
    }

    provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/deploy.sh",
        "/tmp/deploy.sh ${var.db_address}"
        ]
    }
}

# создаем ресурс -внешний ip

resource "google_compute_address" "app_ip" {
    name = "reddit-app-ip"
}

# создаем ресурс nginx файрволл

resource "google_compute_firewall" "firewall_nginx" {
    name = "allow-nginx-${var.env}"
    network = "default"
    allow {
        protocol = "tcp"
        ports    = ["80"]
        }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["reddit-app"]
}



