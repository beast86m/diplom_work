**Итоговый модуль профессии Системный администратор, SYS-24, Фролов И.Р.**

Начнем с создания инфрастуктуры, но прежде подготовим рабочее место:

![изображение](https://github.com/user-attachments/assets/286f40c4-bea2-4097-98f0-8ca90805e91d)

Создаем первый конфигурационный файл terraform с настройкой провайдера:

![изображение](https://github.com/user-attachments/assets/ad9d7ee7-9b24-4c79-8190-c6eb1df438ce)

Далее создаем сеть и подсети для бужущих виртуальных машин:

![изображение](https://github.com/user-attachments/assets/ea8dc17a-1508-448c-81b2-5071d59abc4c)

Создаем виртуальные машины:

![изображение](https://github.com/user-attachments/assets/3b16825e-e623-4586-831c-eec3a6becfa9)

![изображение](https://github.com/user-attachments/assets/2e0203e4-6403-4b71-a55a-2075e16f08b4)

![изображение](https://github.com/user-attachments/assets/6f4a2040-d73f-49b3-978d-56c803d6b364)

Создаем Target группы и добавляем в нее две ВМ:

![изображение](https://github.com/user-attachments/assets/048de38c-d623-4629-b4db-a436fe8414bb)

![изображение](https://github.com/user-attachments/assets/90af9363-08b4-41a9-83c6-d5d4a25cd0fd)

Создаем Backend Group, настраиваем backends на target group, ранее созданную. Настроаиваем healthcheck на корень (/) и порт 80, протокол HTTP:

![изображение](https://github.com/user-attachments/assets/c75b4221-8112-49e3-94c8-78ef6036c615)

![изображение](https://github.com/user-attachments/assets/2ea6f39d-8844-4421-a723-9ac0d8f9e47c)

Создаем HTTP router. Путь укажем — /, backend group — созданную ранее:

![изображение](https://github.com/user-attachments/assets/6a12746e-cef9-4def-89e9-ff3774efb72a)

![изображение](https://github.com/user-attachments/assets/9f5e484c-0a2c-4304-947c-20f679c6123f)

Балансировщик:

![изображение](https://github.com/user-attachments/assets/ff145ebd-9674-4d2a-8df1-189d1b903ec8)

![изображение](https://github.com/user-attachments/assets/9610f4a3-47c9-4f0d-afc8-37d1da6f2655)

![изображение](https://github.com/user-attachments/assets/b0fa6888-ba9a-4812-b21a-be1821c1b1cc)

Ansible:

Устанавливаем на ВМ Бастион Ansible:

![image](https://github.com/user-attachments/assets/5ed948de-b49c-4bd1-bbad-c82b42e9efb9)
![image](https://github.com/user-attachments/assets/106ad159-e8f2-45bb-b043-7bf9d087c71e)
![image](https://github.com/user-attachments/assets/60503ed4-1f5a-409d-9ac4-8cb478ca611b)

Проверяем, что ansible установился:

![image](https://github.com/user-attachments/assets/36238085-2851-4c9d-bb3f-354a2eed46a2)

Делаем проверку серверров:

![image](https://github.com/user-attachments/assets/1e88762d-2417-4d49-a81a-be7e1dad7267)

![image](https://github.com/user-attachments/assets/319873fb-fb22-40f1-9bb0-03d822bee3ba)

Установка nginx с помощью Ansible:

![изображение](https://github.com/user-attachments/assets/05206c74-3eec-43df-9104-a5305b7f7b01)

![изображение](https://github.com/user-attachments/assets/a0a7bea8-ec7c-4088-a443-eee2e6573158)

![изображение](https://github.com/user-attachments/assets/d148267c-f3f6-4685-b823-8c329775bf77)


Zabbix:

![изображение](https://github.com/user-attachments/assets/df5ad3b2-391f-40cb-b3fc-9d8eab046617)


![изображение](https://github.com/user-attachments/assets/bedc69bf-1bcc-4855-8ddf-7c080649310e)
