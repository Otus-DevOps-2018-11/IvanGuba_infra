IvanGuba_infra repository

  ДЗ №11 Ansible-4

    Установлен vagrant и обновлен gitignore
    Установлен virtualbox
    Создан и наполнен vagrantfile
    Созданы инстансы appserver и dbserver с помощью vagrant
    Создан playbook base для установки python
    Доработана роль db, добалены таски install_mongo и config_mongo
    Доработана роль app, добалены таски puma и ruby, параметризировано имя пользователя (используется 'vagrant' вместо 'ubuntu')
    Создан virtualenv и установлены molecule и testinfra
    Выполнено molecule init scenario для создания заготовки тестов роли db
    Добавлены тесты в testinfra
    Добавлен тест к роли db для проверки БД слушает по нужному порту (27017)
    Использованы роли db и app в playbook'ах packer_db и packer_app и проверена работоспособность
    
Самостоятельное задание

    Добавлен тест к роли db для проверки того, что БД слушает по нужному порту (27017)
    Код

    Использованы роли db и app в плейбуках packer_db.yml и packer_app.yml и проверено, что всё работает как прежде
    (использованы теги для запуска только нужных тасков, теги указаны в шаблонах пакера)

  ДЗ №9 Ansible-2

    Создан playbook все в одном сценарии
    Создан playbook с отдельными сенариями
    Созданы playbok'и app, db и deploy + сводный playbook site
    Созданы playbok' packer_app и packer_db для замены bash-скриптов при создании образов инстансов через packer
    Созданы шаблоны db_config и mongod.conf
    Модифицированы шаблоны образов app и db packer для использования playbook'ов вместо bash скриптов
    Проверена работоспособность    

  ДЗ №8 Ansible-1

    Создан inventory и ansible.cfg. Проверено подключение к хостам и возможность передачи команд
    Создан inventory.yml
    Создан базовый playbook clone.yml
    При выполнении playbook изменилось состояние changed=1, поскольку директория отсутствовала и ansible склонировал её. 

  ДЗ №6 Terraform-1

  Задание со*

    Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта. Выполните terraform apply и проверьте результат (публичный ключ можно брать пользователя appuser)

      resource "google_compute_project_metadata_item" "default" {
        key   = "ssh-keys"
        value = "ivan:${file(var.public_key_path)}"    

    Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта  

      resource "google_compute_project_metadata_item" "default" {
        key   = "ssh-keys"
        value = "ivan:${file(var.public_key_path)}ekl17:${file(var.public_key_path)}"

    Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат 

    После применения terraform apply пользователь appuser_web будет удален.
    terraform использует декларативный подход для описания инфраструктуры и приводит ее состояние в соответствие в файлам конфигурации.

  ДЗ №4

    testapp_IP = 35.198.167.169
    testapp_port = 9292

    bastion_IP = 104.155.108.24 
    someinternalhost_IP = 10.132.0.3

  ДЗ №3

    способ подключения к someinternalhost в одну команду 

    ssh -A -t ekl17@104.155.108.24 ssh 10.132.0.3

      ekl17           — имя пользователя
      104.155.108.24  — bastion
      10.132.0.3      — someinternalhost

    ivan@VTB-Notebook-GubaIV:~/IvanGuba_infra$ ssh -A -t ekl17@104.155.108.24 ssh 10.132.0.3

      Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1025-gcp x86_64)

       * Documentation:  https://help.ubuntu.com
       * Management:     https://landscape.canonical.com
       * Support:        https://ubuntu.com/advantage

        Get cloud support with Ubuntu Advantage Cloud Guest:
          http://www.ubuntu.com/business/services/cloud
      This system has been minimized by removing packages and content that are
      not required on a system that users do not log into.

      To restore this content, you can run the 'unminimize' command.

      4 packages can be updated.
      4 updates are security updates.

      New release '18.04.1 LTS' available.
      Run 'do-release-upgrade' to upgrade to it.

      Last login: Wed Dec 26 11:54:47 2018 from 10.132.0.2

    способ подключения к someinternalhost по алиасу

      Создаем файл config

        Host bastion
            HostName 104.155.108.24
            User ekl17

        Host someinternalhost
            ProxyCommand ssh -A bastion -W 10.132.0.3:22
            User ekl17

      Добавлем его через ssh-add

      ivan@VTB-Notebook-GubaIV:~/IvanGuba_infra$ ssh someinternalhost

        Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-1025-gcp x86_64)

       * Documentation:  https://help.ubuntu.com
       * Management:     https://landscape.canonical.com
       * Support:        https://ubuntu.com/advantage

      Get cloud support with Ubuntu Advantage Cloud Guest:
      http://www.ubuntu.com/business/services/cloud
      This system has been minimized by removing packages and content that are
      not required on a system that users do not log into.

      To restore this content, you can run the 'unminimize' command.

      4 packages can be updated.
      4 updates are security updates.

      New release '18.04.1 LTS' available.
      Run 'do-release-upgrade' to upgrade to it.

      Last login: Wed Dec 26 11:55:41 2018 from 10.132.0.2

end of file
