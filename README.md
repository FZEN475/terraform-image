# terraform-image
## Описание
* Образ основан на alpine/terragrunt
* Сборка образа выполняется в github ci и помещается в registry.
* Для загрузки main.tf требуется указать environment.TERRAFORM_REPO.
* Образ зависим от файлов variables.tf и terraform.tfstate, которые копируются из "безопасного" расположения.
  * variables.tf содержит пароль от esxi.
  * Если terraform.tfstate не существует, то создастся при первом запуске.

## Подготовка
### Требования
| Soft   | Comment                                                         |
|:-------|:----------------------------------------------------------------|
| docker | Локальный или удалённый сервер для сборки и запуска контейнера. | 

| Дополнительно               | Значение   | Comment                                                            |
|:----------------------------|:-----------|:-------------------------------------------------------------------|
| secrets.id_ed25519          | id_ed25519 | Закрытый ключ "безопасного" сервера                                |
| environment.TERRAFORM_REPO  | git url    | Репозиторий с main.tf                                              |
| environment.ESXI_SERVER     | IP/DNS     | IP или DNS ESXI                                                    |
| environment.SECURE_SERVER   | IP/DNS     | IP или DNS "безопасного" сервера с inventory.json и structure.yaml |
| environment.SECURE_PATH     | path       | Расположение на "безопасном" сервере                               |
| environment.APPLY           | true       | Применить изменения.                                               |
| environment.GIT_EXTRA_PARAM | -b dev     | Дополнительные параметры git clone                                 |


### Дополнительно
variables.tf
```terraform
variable "esxi_hostname" {
  default = "esxi"
}

variable "esxi_hostport" {
  default = "22"
}

variable "esxi_username" {
  default = "root"
}

variable "esxi_password" {
  default = "xxxxxxxx"
}
```
inventory.json
```json
{
  "control": {
    "hosts": {
      "control02": null,
      "control03": null
    }
  },
  "control_main": {
    "hosts": {
      "control01": null
    }
  },
  "dev": {
    "hosts": {
      "dev01": null
    }
  },
  "prod": {
    "hosts": {
      "prod01": null
    }
  },
  "test": {
    "hosts": {
      "test01": null
    }
  }
}
```

### Заметки

<!DOCTYPE html>
<table>
  <thead>
    <tr>
      <th>Проблема</th>
      <th>Решение</th>
    </tr>
  </thead>
  <tr>
      <td>Из контейнера не определяется DNS имя без домена.</td>
      <td>
На хосте докера:  
/etc/docker/daemon.json

```json
{
  "dns": ["192.168.2.1","8.8.8.8"]
}
```
</td>
  </tr>
  <tr>
  </tr>
</table>
