# создаем ресурс правило брандмауэра ssh

resource "google_compute_firewall" "firewall_ssh" {
    name    = "default-allow-ssh"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = "${var.source_ranges}"
}

# создаем ресурс правило брандмауэра firewall_puma

resource "google_compute_firewall" "firewall_puma" {
    name = "allow-puma-default"

    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["9292"]
    } 

    source_ranges = "${var.source_ranges}"

    target_tags = ["reddit-app"]
}

# создаем ресурс правило брандмауэра firewall_mongo

resource "google_compute_firewall" "firewall_mongo" {
    name    = "allow-mongo-default"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["27017"]
    }

    target_tags = ["reddit-db"]
    source_tags = ["reddit-app"]
}
