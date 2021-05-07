# Урок 13. Пользователи и группы. Авторизация и аутентификация 
В репозитори находятся файлы: [Cкрипт, для решения задания](lesson_13.sh), [Vagrantfile](Vagrantfile).
## 1. Создание пользователей, указанную группу. правим /etc/ssh/sshd_config;
```
for user in day night friday admin; do 
	sudo useradd $user
	echo "Otus2019" | sudo passwd --stdin $user
	sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service;
	done
	usermod -G admin day
```

## 2. Для того, чтобы могли ограничить доступ на сервер в выходные, кроме группы admin, вносим изменения /etc/pam.d/sshd. Указывая, что при подключении на сервер по 22 порту, будет выполнена проверка в соотвествии скрипта. Использую модуль pam_exec. Также выставляем права на запуск скрипта;
```
sed -i '/account    required     pam_nologin.so/ a account    required     pam_exec.so /usr/local/bin/test_login.sh' /etc/pam.d/sshd

cat >> /usr/local/bin/test_login.sh << 'EOF'
#!/bin/bash
day_week=$(date +%u)
if [ `grep $PAM_USER /etc/group | grep admin` ] 
then
exit 0
fi

if [ $day_week -gt 5 ]
then
exit 1
fi
EOF

chmod 744 /usr/local/bin/test_login.sh
```

## 3. Вторая задача - предоставить права пользователю на использования docker Предоставил права пользователю night на службу docker и /usr/bin/docker *. Звездочку небезопасно указывать, но точных данных нет, что конректно понадобится пользователю для работы с docker.
```
cat >> /etc/sudoers.d/docker << 'EOF'
night ALL=(root) NOPASSWD:/usr/bin/systemctl status docker
night ALL=(root) NOPASSWD:/usr/bin/systemctl start docker 
night ALL=(root) NOPASSWD:/usr/bin/systemctl stop docker
night ALL=(root) NOPASSWD:/usr/bin/systemctl restart docker
night ALL=(root) NOPASSWD:/usr/bin/docker *
EOF
chmod 0440 /etc/sudoers.d/docker
```
