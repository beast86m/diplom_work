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




