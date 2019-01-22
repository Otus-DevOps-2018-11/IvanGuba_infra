# обявляем провайдера

provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

# объявляем ресурс - публичный ключ ssh

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "ivan:${file(var.public_key_path)}ekl17:${file(var.public_key_path)}"
}

# объявляем ресурс - экземпляр ВМ

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network       = "default" # сеть, к которой присоединяем интерфейс
    access_config = {}        # использовать ephemeral IP для доступа из Интернет
  }

  connection {
    type        = "ssh"
    user        = "ivan"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  # добавляем провиженеры

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

# объявляем еще ресурс - файрволл

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ 
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
