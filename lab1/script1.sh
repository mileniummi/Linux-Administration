#!/bin/sh
cd ~
#(1) Создать каталог test в домашнем каталоге пользователя.
	if [ ! -e test ]
	then
		mkdir test
	fi
#(2) Создать в нем файл list, содержащий список всех файлов и поддиректориев каталога /etc (включая
     #скрытые) в таком виде, что можно однозначно определить какая из записей является именем файла, а
     #какая — названием директории.
	ls -aFR /etc 2>/dev/null > test/list

#(3) Вывести в конец этого файла два числа. Сначала количество поддиректориев в каталоге /etc, а
    #затем количество скрытых файлов в каталоге /etc.
	echo "number of	directories in /etc:" >> test/list
	grep '/' test/list  | wc -l >> test/list
	echo "number of hidden files in /etc:">> test/list
	grep "^\.[a-zA-z]" test/list | wc -l >> test/list
#(4) Создать в каталоге test каталог links.
	cd test
	if [ ! -e links ]
	then
		mkdir links
	fi
#(5) Создать в каталоге links жесткую ссылку на файл list с именем list_hlink.
	if [ ! -e links/list_hlink ]
	then
	  ln list links/list_hlink
	fi
#(6) Создать в каталоге links символическую ссылку на файл list с именем list_slink.
	if [ ! -e links/list_slink ]
	then
	  cd links
	  ln -s ../list list_slink
	  cd ..
	fi
	cd ..
#(7) Вывести на экран количество имен (жестких ссылок) файла list_hlink, количество имен (жестких
     #ссылок) файла list и количество имен (жестких ссылок) файла list_slink.
	echo "number of hard links of file list:"
	ls -lR | grep "[^/]list$" | cut -d " " -f 2

	echo "number of hard links of file list_hlink:"
	ls -lR | grep "list_hlink$" | cut -d " " -f 2

	echo "number of hard links of file list_slink:"
	ls -lR | grep "list_slink -> ../list$" | cut -d " " -f 2
#(8) Дописать в конец файла list_hlink число строк в файле links.
	echo "number of lines in file list:" >> test/list
	cat test/list | wc -l >> test/list
#(9) Сравнить содержимое файлов list_hlink и list_slink. Вывести на экран YES, если файлы
     #идентичны.
  echo "файлы list_hlink и list_slink идентичны?"
  cmp -s test/links/list_hlink test/links/list_slink && echo "YES" || echo "NO"
#(10) Переименовать файл list в list1.
  mv test/list test/list1
#(11) Сравнить содержимое файлов list_hlink и list_slink. Вывести на экран YES, если файлы
      #идентичны.
  echo "файлы list_hlink и list_slink идентичны после переименования list на list1?"
  cmp -s test/links/list_hlink test/links/list_slink && echo "YES" || echo "NO"
#(12) Создать в домашнем каталоге пользователя жесткую ссылку на файл list_link с именем list1. WTFFFFFFFFFFFFFFFFFFFFFFFFFFFF?

#(13) Создать в домашнем каталоге файл list_conf, содержащий список файлов с расширением .conf, из
      #каталога /etc и всех его подкаталогов.
  ls -aFR /etc 2>/dev/null | grep "\.conf$"  > list_conf
#(14) Создать в домашнем каталоге файл list_d, содержащий список всех подкаталогов каталога /etc,
      #расширение которых .d.
  ls -aFR /etc 2>/dev/null | grep "\.d/$"  > list_d
#(15) Создать файл list_conf_d, включив в него последовательно содержимое list_conf и list_d.
  cat list_conf > list_conf_d
  cat list_d >> list_conf_d
#(16) Создать в каталоге test скрытый каталог sub.
  if [ ! -e test/.sub ]
  then
    mkdir test/.sub
#(17) Скопировать в него файл list_conf_d.
    cp list_conf_d test/.sub/list_conf_d
  fi
#(18) Еще раз скопировать туда же этот же файл в режиме автоматического создания резервной копии
      #замещаемых файлов.
  cp --backup=numbered list_conf_d test/.sub/list_conf_d
#(19) Вывести на экран полный список файлов (включая все подкаталоги и их содержимое) каталога
      #test.
  ls -aRF test/
#(20) Создать в домашнем каталоге файл man.txt, содержащий документацию на команду man.
  man man > man.txt
#(21) Разбить файл man.txt на несколько файлов, каждый из которых будет иметь размер не более 1
      #килобайта.
  split --bytes=1000 man.txt 98
#(22) Переместить одной командой все файлы, полученные в пункте 21 в каталог man.dir.
    if [ ! -e man.dir ]
      then
        mkdir man.dir
      fi
#(23) Переместить одной командой все файлы, полученные в пункте 21 в каталог man.dir.
  mv 98* man.dir
#(24) Собрать файлы в каталоге man.dir обратно в файл с именем man.txt.
  cd man.dir
  cat 98* > man.txt
  cd ..
#(25) Сравнить файлы man.txt в домашней каталоге и в каталоге man.dir и вывести YES, если файлы
      #идентичны.
  echo "Одинаковы ли файлы man.txt?"
  cmp -s man.txt man.dir/man.txt && echo "YES" || echo "NO"
#(26) Добавить в файл man.txt, находящийся в домашнем каталоге несколько строчек с произвольными
      #символами в начало файла и несколько строчек в конце файла.
      echo "pkjb \n lkjhbnv m,kjhgvbkl \n poijhgbv" >> man.txt
#(27) Одной командой получить разницу между файлами в отдельный файл в стандартном формате для
      #наложения патчей.
  diff -u man.txt man.dir/man.txt > man.diff
#(28) Переместить файл с разницей в каталог man.dir.
  mv man.diff man.dir/
#(29) Наложить патч из файла с разницей на man.txt в каталоге man.dir.
  cd man.dir
  patch man.txt man.diff
  cd ..
#(30) Сравнить файлы man.txt в домашней каталоге и в каталоге man.dir и вывести YES, если файлы
      #идентичны.
  echo "Одинаковы ли файлы man.txt?"
  cmp -s man.txt man.dir/man.txt && echo "YES" || echo "NO"

cd ..