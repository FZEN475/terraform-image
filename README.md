# terraform-image
## Описание
* Образ основан на alpine/terragrunt 
* Для управления esxi используется провайдер [josenk/esxi](https://github.com/josenk/terraform-provider-esxi).
* Для загрузки main.tf требуется указать environment.TERRAFORM_REPO.
* Образ зависим от файлов variables.tf, terraform.tfstate, которые копируются из "безопасного" расположения.
  * variables.tf содержит пароль от esxi.
  * Если terraform.tfstate не существует, то создастся при первом запуске.

## Variables

| Дополнительно               | Значение   | Comment                                                            |
|:----------------------------|:-----------|:-------------------------------------------------------------------|
| secrets.id_ed25519          | id_ed25519 | Закрытый ключ "безопасного" сервера                                |
| environment.TERRAFORM_REPO  | git url    | Репозиторий с main.tf                                              |
| environment.ESXI_SERVER     | IP/DNS     | IP или DNS ESXI                                                    |
| environment.SECURE_SERVER   | IP/DNS     | IP или DNS "безопасного" сервера с inventory.json и structure.yaml |
| environment.SECURE_PATH     | path       | Расположение на "безопасном" сервере                               |
| environment.APPLY           | true       | Применить изменения.                                               |
| environment.GIT_EXTRA_PARAM | -bdev      | Дополнительные параметры git clone                                 |
