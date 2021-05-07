#!/bin/bash
echo "####################______Задание номер 1______####################"
sleep 2
echo "Создание пользователей, установка паролей, правка /etc/ssh/sshd_config"
sleep 5
for user in day night friday admin; do 
	sudo useradd $user
	echo "Otus2019" | sudo passwd --stdin $user
	sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service;
	done

echo "Установка\добавление репозитория epel-release.noarch, для установки pam_script"
sleep 5
yum install -y  epel-release.noarch
yum install -y pam_script

echo "Добавим в группу admin уз day"
sleep 5
usermod -G admin day

echo "Правим /etc/pam.d/sshd для разрешения группы admin подключаться по ssh. Создание Скрипта. Выставляем права +x на файл"
sleep 5
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

echo "Команда для изменения даты, чтобы проверить вход выходные timedatectl set-time '2021-05-01 19:03:20'"
sleep 5

echo "####################______Задание номер 2______####################"
sleep 5

cat >> /etc/sudoers.d/docker << 'EOF'
night ALL=(root) NOPASSWD:/usr/bin/systemctl status docker
night ALL=(root) NOPASSWD:/usr/bin/systemctl start docker 
night ALL=(root) NOPASSWD:/usr/bin/systemctl stop docker
night ALL=(root) NOPASSWD:/usr/bin/systemctl restart docker
night ALL=(root) NOPASSWD:/usr/bin/docker *
EOF
chmod 0440 /etc/sudoers.d/docker

