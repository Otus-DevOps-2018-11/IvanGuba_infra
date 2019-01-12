#!/usr/bin/env bash

# Выкачиваем репозиторий, перемещаем в целевую папку и определяем зависимости

git clone -b monolith https://github.com/express42/reddit.git
cd redit && bundle install

# Стартуем сервер и проверяем порт

puma -d
ps aux | grep puma
