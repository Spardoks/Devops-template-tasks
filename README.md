# Дипломный практикум в Yandex.Cloud

https://github.com/netology-code/devops-diplom-yandexcloud/blob/main/README.md

- [Дипломный практикум в Yandex.Cloud](#дипломный-практикум-в-yandexcloud)
  - [Цели:](#цели)
  - [Этапы выполнения:](#этапы-выполнения)
    - [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
    - [Создание Kubernetes кластера](#создание-kubernetes-кластера)
    - [Создание тестового приложения](#создание-тестового-приложения)
    - [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
    - [Деплой инфраструктуры в terraform pipeline](#деплой-инфраструктуры-в-terraform-pipeline)
    - [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  - [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  - [Выполнение заданий](#выполнение-заданий)
    - [Вспомогательные материалы](#вспомогательные-материалы)
    - [Описание окружения-отправной точки](#описание-окружения-отправной-точки)
    - [Этап "Создание облачной инфраструктуры"](#этап-создание-облачной-инфраструктуры)
    - [Этап "Создание Kubernetes кластера"](#этап-создание-kubernetes-кластера)
    - [Этап "Создание тестового приложения"](#этап-создание-тестового-приложения)
    - [Этап "Подготовка cистемы мониторинга и деплой приложения"](#этап-подготовка-cистемы-мониторинга-и-деплой-приложения)
    - [Этап "Деплой инфраструктуры в terraform pipeline"](#этап-деплой-инфраструктуры-в-terraform-pipeline)
    - [Этап "Установка и настройка CI/CD"](#этап-установка-и-настройка-cicd)
  - [Итоги](#итоги)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://developer.hashicorp.com/terraform/language/backend) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
3. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://developer.hashicorp.com/terraform/language/backend) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

### Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform
---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
---

## Выполнение заданий

### Вспомогательные материалы

```
1. https://github.com/Spardoks/cloud_security - сборник информации по terraform

2. https://github.com/Spardoks/Kubernetes_helm - сборник инфоромации по kubernetes и helm

3. https://github.com/Spardoks/Grafana_intro - сборник информации по Grafana

4. https://github.com/Spardoks/DockerInPractice - сборник информации по Docker

5. https://github.com/Spardoks/TestProject - сборник информации по CI/CD

6. https://github.com/Spardoks/AnsibleIntro - сборник информации по Ansible

7. https://docs.google.com/document/d/1p5CNruVQOfGB9kbO9cFVT_Jlv0B52VhiQZfJ5t3sysk/edit?tab=t.0 - GitLab

8. https://docs.google.com/document/d/1xaONQrqilPapDeNjztUmJg9tu900ykL_a-zDOGs55qg/edit?tab=t.0 - Docker 1

9. https://docs.google.com/document/d/16GZSjKXNLUs4bcO0OYDRXsL8j5v5aBn36pgq-4lJpQo/edit?tab=t.0 - Docker 2

10. https://docs.google.com/document/d/1X-wHH0zMjrktgyUW3D81lwV-2BI_DcvhzubB0LCl-94/edit?tab=t.0 - Ansible 1

11. https://docs.google.com/document/d/1X-wHH0zMjrktgyUW3D81lwV-2BI_DcvhzubB0LCl-94/edit?tab=t.0 - Ansible 2

12. https://docs.google.com/document/d/1ZhaLsoOjBcaJpQVnENKq9ByhYdRFOUJdx6kqZZpyPbE/edit?tab=t.0 - Cloud

13. https://docs.github.com/ru/actions/get-started/quickstart - Github Actions
```

### Описание окружения-отправной точки

```
tester@debian:~$ uname -a
Linux debian 6.1.0-33-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.133-1 (2025-04-10) x86_64 GNU/Linux
tester@debian:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 12 (bookworm)
Release:        12
Codename:       bookworm

tester@debian:~$ terraform version
Terraform v1.11.4
on linux_amd64

tester@debian:~$ docker version
Client: Docker Engine - Community
 Version:           28.0.4
 API version:       1.48
 Go version:        go1.23.7
 Git commit:        b8034c0
 Built:             Tue Mar 25 15:07:22 2025
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          28.0.4
  API version:      1.48 (minimum version 1.24)
  Go version:       go1.23.7
  Git commit:       6430e49
  Built:            Tue Mar 25 15:07:22 2025
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.7.27
  GitCommit:        05044ec0a9a75232cad458027ca83437aae3f4da
 runc:
  Version:          1.2.5
  GitCommit:        v1.2.5-0-g59923ef
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

tester@debian:~$ git -v
git version 2.39.5

tester@debian:~$ yc -v
Yandex Cloud CLI 0.146.1 linux/amd64

tester@debian:~$ kubectl version
Client Version: v1.34.0
Kustomize Version: v5.7.1

tester@debian:~$ helm version
version.BuildInfo{Version:"v3.19.0", GitCommit:"3d8990f0836691f0229297773f3524598f46bda6", GitTreeState:"clean", GoVersion:"go1.24.7"}

tester@debian:~$ python3 --version
Python 3.11.2

tester@debian:~$ ansible --version
ansible [core 2.17.10]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/tester/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/tester/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.11.2 (main, Apr 28 2025, 14:11:48) [GCC 12.2.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```

### Этап "Создание облачной инфраструктуры"

1. Берём наше готовое окружение (или настраиваем его по материалам из ссылок выше)

2. Убеждаемся, что у нас есть готовый сервисный аккаунт для работы с terraform c правами админа или создаём его
```
# https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart
# sa-profile admin service ac for using terraform in folder
```

3. Создаём файл терраформа для работы с зеркалами и помещаем его в `~/.terraformrc`
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

4. Создаём файл с описанием провайдеров `providers.tf`
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  #required_version = "~>1.8.4"
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
```

5. Создаём сервисный аккаунт с необходимыми правами для работы с облачной инфраструктурой
```
resource "yandex_iam_service_account" "service" {
  folder_id = var.folder_id
  name      = var.account_name
}

resource "yandex_resourcemanager_folder_iam_member" "service_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
}
```

6. Подготовим backend для Terraform: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)

```
resource "yandex_iam_service_account_static_access_key" "terraform_service_account_key" {
  service_account_id = yandex_iam_service_account.service.id
}

resource "yandex_storage_bucket" "tf-bucket" {
  bucket     = "for-state"
  access_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key

  anonymous_access_flags {
    read = false
    list = false
  }

  force_destroy = true

  provisioner "local-exec" {
    command = "echo export AWS_ACCESS_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.access_key} > ../terraform_infrastructure/backend.tfvars"
  }

  provisioner "local-exec" {
    command = "echo export AWS_SECRET_KEY=${yandex_iam_service_account_static_access_key.terraform_service_account_key.secret_key} >> ../terraform_infrastructure/backend.tfvars"
  }
}
```
Разворачиваем бэкенд [terraform_backend](./terraform_backend/)
```
yc config profile activate sa-profile
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

cp .terraformrc ~/.terraformrc
cat > personal.auto.tfvars << EOF
token        = "${YC_TOKEN}"
cloud_id     = "${YC_CLOUD_ID}"
folder_id    = "${YC_FOLDER_ID}"
EOF
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```
Проверяем, создался ли S3-bucket и сервисный аккаунт
```
yc iam service-account list
yc storage bucket list
```

7. Создадим конфигурацию Terrafrom, используя созданный бакет ранее как бэкенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках (будем её хранить в [terraform_infrastructure](./terraform_infrastructure/))
```
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "for-state"
    region = "ru-central1"
    key = "for-state/terraform.tfstate"
    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id   = true
  }
}
```

8. Создадим VPC с подсетями в разных зонах доступности
```
resource "yandex_vpc_network" "network1" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "network1-subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = var.cidr1
}

resource "yandex_vpc_subnet" "network1-subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.network1.id
  v4_cidr_blocks = var.cidr2
}
```

9. Убедимся, что теперь мы можем выполнять команды terraform destroy и terraform apply без дополнительных ручных действий
```
cd terraform_infrastructure
source backend.tfvars
terraform init
terraform apply
terraform state list
terraform destroy
terraform state list
```

Доп.: Сгенерим ключ для гита для удобства отправки данных
```
# https://docs.github.com/ru/authentication/connecting-to-github-with-ssh
ssh-keygen -t ed25519 -f ./ed25519_github
cat ./ed25519_github.pub
eval "$(ssh-agent -s)"
ssh-add ./ed25519_github
ssh -T git@github.com
git config user.name <Name>
git config user.email <Email>
```

### Этап "Создание Kubernetes кластера"

1. Cоздадим виртуальные машин для Kubernetes кластера. Будем использовать одну Master ноду и две Worker ноды

[master](./terraform_infrastructure/master.tf)

[worker](./terraform_infrastructure/worker.tf)

### Этап "Создание тестового приложения"

...

### Этап "Подготовка cистемы мониторинга и деплой приложения"

...

### Этап "Деплой инфраструктуры в terraform pipeline"

...

### Этап "Установка и настройка CI/CD"

...

## Итоги

...