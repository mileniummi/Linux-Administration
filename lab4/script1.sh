# 1. Установите из сетевого репозитория пакеты, входящие в группу «Development Tools».
    dnf update
    dnf groupinstall "Development Tools"
# 2. Установите из исходных кодов, приложенных к методическим указаниям пакет bastet-0.43. Для этого
# необходимо создать отдельный каталог и скопировать в него исходные коды проекта bastet. Вы
# можете использовать подключение сетевого каталога в хостовой операционной системе для передачи
# архива с исходными кодами в виртуальную машину. Далее следует распаковать архив до появления
# каталога с исходными файлами (в каталоге должен отображаться Makefile). После этого соберите
# пакет bastet и запустите его, чтобы удостовериться, что он правильно собрался. Затем модифицируйте
# Makefile, добавив в него раздел install. Обеспечьте при установке копирование исполняемого файла в
# /usr/bin с установкой соответствующих прав доступа. Выполните установку и проверьте, что любой
# пользователь может запустить установленный пакет.
    tar zxvf bastet-0.43.tgz         (x– extract an archive file, v – show the progress of the archive file, z – filter archive through gzip
                                                            f – filename of the archive file)
    dnf install boost-devel
    dnf install ncurses-devel
    make
    добавить в Makefile
    install:
        cp bastet /usr/local/bin
        chgrp games /usr/local/bin/bastet
        chmod g+s /usr/local/bin/bastet
        touch /var/games/bastet.scores2
        chgrp games /var/games/bastet.scores2
        chmod 664 /var/games/bastet.scores2
    make install
# 3. Создайте файл task3.log, в который выведите список всех установленных пакетов.
    dnf list installed > task3.log
# 4. Создайте файл task4_1.log, в который выведите список всех пакетов (зависимостей), необходимых
# для установки и работы компилятора gcc. Создайте файл task4_2.log, в который выведите список
# всех пакетов (зависимостей), установка которых требует установленного пакета libgcc.
    dnf deplist gcc > task4_1.log
    rpm -q --whatrequires libgcc > task4_2.log
# 5. Создайте каталог localrepo в домашнем каталоге пользователя root и скопируйте в него пакет
# checkinstall-1.6.2-3.el6.1.x86_64.rpm , приложенный к методическим указаниям. Создайте
# собственный локальный репозиторий с именем localrepo из получившегося каталога с пакетом.
    mkdir ~/localrepo
    cp /mnt/share/checkinstall-1.6.2-3.el6.1.x86_64.rpm ~/localrepo
    dnf install createrepo
    createrepo --database ~/localrepo
    nano /etc/yum.repos.d/localrepo.repo
    добавить в него 
    [localrepo]

    name = winter, yo know?

    baseurl=file:///root/localrepo

    enabled=1

    gpgcheck=0
# 6. Создайте файл task6.log, в который выведите список всех доступных репозиториев.
    dnf repolist > task6.log
# 7. Настройте систему на работу только с созданным локальным репозиторием (достаточно переименовать
# конфигурационные файлы других репозиториев). Выведите на экран список доступных для установки
# пакетов и убедитесь, что доступен только один пакет, находящийся в локальном репозитории. Установите
# этот пакет.
mv /etc/yum.repos.d/*.repo /tmp/
mv /tmp/localrepo.repo /etc/yum.repos.d/
dnf list available
dnf install checkinstall
# 8. Скопируйте в домашний каталог пакет fortunes-ru_1.52-2_all, приложенный к методическим
# рекомендациям, преобразуйте его в rpm пакет и установите.
cp fortunes-ru_1.52-2_all.deb /root/localrepo
    возвращаем репозитории:
    mv /tmp/*.repo /etc/yum.repos.d/
    утанавливаем alien:
        curl -sL https://sourceforge.net/projects/alien-pkg-convert/files/latest/download -o alien_8.95.tar.xz
        tar Jxf alien_8.95.tar.xz
        mv alien-8.95 alien
        tar zcf alien_8.95.tar.gz alien
        dnf install perl
        rpmbuild -ta alien_8.95.tar.gz
        ls -l rpmbuild/RPMS/noarch/alien-8.95-1.noarch.rpm
        rpm -i rpmbuild/RPMS/noarch/alien-8.95-1.noarch.rpm {i-install}
    
    alien -r fortunes-ru_1.52-2_all.deb

устанавливаем rpmrebuild
dnf install https://extras.getpagespeed.com/release-latest.rpm
dnf install rpmrebuild

# 9. Скачайте из сетевого репозитория пакет nano. Пересоберите пакет таким образом, чтобы после его
# установки менеджером пакетов, появлялась возможность запустить редактор nano из любого каталога,
# введя команду newnano.
whereis nano
cd /usr/bin
rpmrebuild nano
rpmrebuild -enp /root/rpmbuild/RPMS/x86_64/nano-2.9.8-1.el8.x86_64.rpm
alias newnano='/usr/bin/nano'

# # 10. Предъявите преподавателю изменения в системе и файл с описанием использованных команд.
