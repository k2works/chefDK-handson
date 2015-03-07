ChefDKハンズオン
===

# 目的
[ChefDKハンズオン with すごい広島の資料](http://qiita.com/eielh/items/adb173ffcd6389c12e36)を仮想マシン環境でやってみる

![001](https://farm9.staticflickr.com/8665/16737657351_332ceac053_z.jpg)

![002](https://farm9.staticflickr.com/8600/16118910563_e4803f366f_z.jpg)

# 前提
| ソフトウェア     | バージョン    | 備考         |
|:---------------|:-------------|:------------|
| ChefDK    　　　|0.3.5        |             |
| vagrant        |1.7.2        |             |
|           　　　|        |             |

# 構成
+ [セットアップ](#1)
+ [ChefDK添付のRubyを使う](#2)
+ [クックブックの作成](#3)
+ [Docker](#4)
+ [Test Kitchen](#5)
+ [Serverspec](#6)
+ [ChefSpec](#7)
+ [test-kitchenでのchefの実行](#8)
+ [Foodcritic](#9)
+ [Berkshelf](#10)

# 参照
+ [ChefDKハンズオン with すごい広島の資料](http://qiita.com/eielh/items/adb173ffcd6389c12e36)
+ [VirtualBox 用 Ubuntu 14.04 LTS 日本語デスクトップ イメージ](http://qiita.com/yuki-takei/items/1a5fc4ab66f58e9536f0)
+ [Chef-DK Cookbook](https://supermarket.chef.io/cookbooks/chef-dk)
+ [docker](https://supermarket.chef.io/cookbooks/docker)

# 詳細
## <a name="1">セットアップ</a>
```
$ vagrant up
```

## <a name="2">ChefDK添付のRubyを使う</a>
```

    ﻿vagrant@ubuntu-trusty64-ja:~$ cd /vagrant/
    vagrant@ubuntu-trusty64-ja:/vagrant$ eval "$(chef shell-init `basename $SHELL`)"
    vagrant@ubuntu-trusty64-ja:/vagrant$ which ruby
    /opt/chefdk/embedded/bin/ruby
    
```

## <a name="3">クックブックの作成</a>
```

    ﻿vagrant@ubuntu-trusty64-ja:/vagrant$ chef generate cookbook myweb
    Compiling Cookbooks...
    Recipe: code_generator::cookbook
      * directory[/vagrant/myweb] action create
        - create new directory /vagrant/myweb
      * template[/vagrant/myweb/metadata.rb] action create_if_missing
        - create new file /vagrant/myweb/metadata.rb
        - update content in file /vagrant/myweb/metadata.rb from none to e75704
        (diff output suppressed by config)
      * template[/vagrant/myweb/README.md] action create_if_missing
        - create new file /vagrant/myweb/README.md
        - update content in file /vagrant/myweb/README.md from none to 965c91
        (diff output suppressed by config)
      * cookbook_file[/vagrant/myweb/chefignore] action create
        - create new file /vagrant/myweb/chefignore
        - update content in file /vagrant/myweb/chefignore from none to 9727b1
        (diff output suppressed by config)
      * cookbook_file[/vagrant/myweb/Berksfile] action create_if_missing
        - create new file /vagrant/myweb/Berksfile
        - update content in file /vagrant/myweb/Berksfile from none to 4a0cca
        (diff output suppressed by config)
      * template[/vagrant/myweb/.kitchen.yml] action create_if_missing
        - create new file /vagrant/myweb/.kitchen.yml
        - update content in file /vagrant/myweb/.kitchen.yml from none to 63c90a
        (diff output suppressed by config)
      * directory[/vagrant/myweb/test/integration/default/serverspec] action create
        - create new directory /vagrant/myweb/test/integration/default/serverspec
      * cookbook_file[/vagrant/myweb/test/integration/default/serverspec/spec_helper.rb] action create_if_missing
        - create new file /vagrant/myweb/test/integration/default/serverspec/spec_helper.rb
        - update content in file /vagrant/myweb/test/integration/default/serverspec/spec_helper.rb from none to 482d33
        (diff output suppressed by config)
      * template[/vagrant/myweb/test/integration/default/serverspec/default_spec.rb] action create_if_missing
        - create new file /vagrant/myweb/test/integration/default/serverspec/default_spec.rb
        - update content in file /vagrant/myweb/test/integration/default/serverspec/default_spec.rb from none to f7e3f7
        (diff output suppressed by config)
      * directory[/vagrant/myweb/spec/unit/recipes] action create
        - create new directory /vagrant/myweb/spec/unit/recipes
      * cookbook_file[/vagrant/myweb/spec/spec_helper.rb] action create_if_missing
        - create new file /vagrant/myweb/spec/spec_helper.rb
        - update content in file /vagrant/myweb/spec/spec_helper.rb from none to 945e09
        (diff output suppressed by config)
      * template[/vagrant/myweb/spec/unit/recipes/default_spec.rb] action create_if_missing
        - create new file /vagrant/myweb/spec/unit/recipes/default_spec.rb
        - update content in file /vagrant/myweb/spec/unit/recipes/default_spec.rb from none to 6b179b
        (diff output suppressed by config)
      * directory[/vagrant/myweb/recipes] action create
        - create new directory /vagrant/myweb/recipes
      * template[/vagrant/myweb/recipes/default.rb] action create_if_missing
        - create new file /vagrant/myweb/recipes/default.rb
        - update content in file /vagrant/myweb/recipes/default.rb from none to 5cb47d
    (diff output suppressed by config)
      * cookbook_file[/vagrant/myweb/.gitignore] action create
        - create new file /vagrant/myweb/.gitignore
        - update content in file /vagrant/myweb/.gitignore from none to dd37b2
        (diff output suppressed by config)
        vagrant@ubuntu-trusty64-ja:/vagrant$ cd myweb/
        
```

## <a name="4">Dockerの動作確認</a>

```
﻿$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

## <a name="5">Test Kitchen</a>

```

    vagrant@ubuntu-trusty64-ja:~/myweb$ kitchen list
    Instance             Driver     Provisioner  Last Action
    default-ubuntu-1404  DockerCli  ChefZero     <Not Created>
    vagrant@ubuntu-trusty64-ja:~/myweb$ kitchen test default-ubuntu-1404
    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen test default-ubuntu-1404
    -----> Starting Kitchen (v1.3.1)
    -----> Cleaning up any prior instances of <default-ubuntu-1404>
    -----> Destroying <default-ubuntu-1404>...
           docker: "rm" requires a minimum of 1 argument. See 'docker rm --help'.
           Finished destroying <default-ubuntu-1404> (0m0.07s).
    -----> Testing <default-ubuntu-1404>
    -----> Creating <default-ubuntu-1404>...
           Sending build context to Docker daemon 2.048 kB
           Sending build context to Docker daemon
           Step 0 : FROM ubuntu:14.04
           Pulling repository ubuntu
           2d24f826cb16: Pulling image (14.04) from ubuntu
           2d24f826cb16: Pulling image (14.04) from ubuntu, endpoint: https://registry-1.docker.io/v1/
           2d24f826cb16: Pulling dependent layers
           511136ea3c5a: Pulling metadata
           511136ea3c5a: Pulling fs layer
           511136ea3c5a: Download complete
           fa4fd76b09ce: Pulling metadata
           fa4fd76b09ce: Pulling fs layer
           fa4fd76b09ce: Download complete
           1c8294cc5160: Pulling metadata
           1c8294cc5160: Pulling fs layer
           1c8294cc5160: Download complete
           117ee323aaa9: Pulling metadata
           117ee323aaa9: Pulling fs layer
           117ee323aaa9: Download complete
           2d24f826cb16: Pulling metadata
           2d24f826cb16: Pulling fs layer
           2d24f826cb16: Download complete
           2d24f826cb16: Download complete
           Status: Downloaded newer image for ubuntu:14.04
            ---> 2d24f826cb16
           Step 1 : RUN apt-get update
            ---> Running in d4ebd62f7b43
           Ign http://archive.ubuntu.com trusty InRelease
           Ign http://archive.ubuntu.com trusty-updates InRelease
           Ign http://archive.ubuntu.com trusty-security InRelease
           Hit http://archive.ubuntu.com trusty Release.gpg
           Get:1 http://archive.ubuntu.com trusty-updates Release.gpg [933 B]
           Get:2 http://archive.ubuntu.com trusty-security Release.gpg [933 B]
           Hit http://archive.ubuntu.com trusty Release
           Get:3 http://archive.ubuntu.com trusty-updates Release [62.0 kB]
           Get:4 http://archive.ubuntu.com trusty-security Release [62.0 kB]
           Get:5 http://archive.ubuntu.com trusty/main Sources [1335 kB]
           Get:6 http://archive.ubuntu.com trusty/restricted Sources [5335 B]
           Get:7 http://archive.ubuntu.com trusty/universe Sources [7926 kB]
           Get:8 http://archive.ubuntu.com trusty/main amd64 Packages [1743 kB]
           Get:9 http://archive.ubuntu.com trusty/restricted amd64 Packages [16.0 kB]
           Get:10 http://archive.ubuntu.com trusty/universe amd64 Packages [7589 kB]
           Get:11 http://archive.ubuntu.com trusty-updates/main Sources [231 kB]
           Get:12 http://archive.ubuntu.com trusty-updates/restricted Sources [2310 B]
           Get:13 http://archive.ubuntu.com trusty-updates/universe Sources [132 kB]
           Get:14 http://archive.ubuntu.com trusty-updates/main amd64 Packages [566 kB]
           Get:15 http://archive.ubuntu.com trusty-updates/restricted amd64 Packages [15.1 kB]
           Get:16 http://archive.ubuntu.com trusty-updates/universe amd64 Packages [331 kB]
           Get:17 http://archive.ubuntu.com trusty-security/main Sources [88.7 kB]
           Get:18 http://archive.ubuntu.com trusty-security/restricted Sources [1874 B]
           Get:19 http://archive.ubuntu.com trusty-security/universe Sources [19.6 kB]
           Get:20 http://archive.ubuntu.com trusty-security/main amd64 Packages [278 kB]
           Get:21 http://archive.ubuntu.com trusty-security/restricted amd64 Packages [14.8 kB]
           Get:22 http://archive.ubuntu.com trusty-security/universe amd64 Packages [113 kB]
           Fetched 20.5 MB in 28s (720 kB/s)
           Reading package lists...
            ---> 087c63a9cf3e
           Removing intermediate container d4ebd62f7b43
           Step 2 : RUN apt-get -y install sudo curl tar
            ---> Running in 6e3f99f25bbb
           Reading package lists...
           Building dependency tree...
           Reading state information...
           sudo is already the newest version.
           tar is already the newest version.
           The following extra packages will be installed:
             ca-certificates krb5-locales libasn1-8-heimdal libcurl3 libgssapi-krb5-2
             libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal
             libheimntlm0-heimdal libhx509-5-heimdal libidn11 libk5crypto3 libkeyutils1
             libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2
             libroken18-heimdal librtmp0 libsasl2-2 libsasl2-modules libsasl2-modules-db
             libwind0-heimdal openssl
           Suggested packages:
             krb5-doc krb5-user libsasl2-modules-otp libsasl2-modules-ldap
             libsasl2-modules-sql libsasl2-modules-gssapi-mit
             libsasl2-modules-gssapi-heimdal
           The following NEW packages will be installed:
             ca-certificates curl krb5-locales libasn1-8-heimdal libcurl3
             libgssapi-krb5-2 libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal
             libheimntlm0-heimdal libhx509-5-heimdal libidn11 libk5crypto3 libkeyutils1
             libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2
             libroken18-heimdal librtmp0 libsasl2-2 libsasl2-modules libsasl2-modules-db
             libwind0-heimdal openssl
           0 upgraded, 25 newly installed, 0 to remove and 7 not upgraded.
           Need to get 2686 kB of archives.
           After this operation, 11.6 MB of additional disk space will be used.
           Get:1 http://archive.ubuntu.com/ubuntu/ trusty/main libroken18-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [40.0 kB]
           Get:2 http://archive.ubuntu.com/ubuntu/ trusty/main libasn1-8-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [160 kB]
           Get:3 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libkrb5support0 amd64 1.12+dfsg-2ubuntu5.1 [30.4 kB]
           Get:4 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libk5crypto3 amd64 1.12+dfsg-2ubuntu5.1 [79.8 kB]
           Get:5 http://archive.ubuntu.com/ubuntu/ trusty/main libkeyutils1 amd64 1.5.6-1 [7318 B]
           Get:6 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libkrb5-3 amd64 1.12+dfsg-2ubuntu5.1 [262 kB]
           Get:7 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libgssapi-krb5-2 amd64 1.12+dfsg-2ubuntu5.1 [113 kB]
           Get:8 http://archive.ubuntu.com/ubuntu/ trusty/main libhcrypto4-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [84.0 kB]
           Get:9 http://archive.ubuntu.com/ubuntu/ trusty/main libheimbase1-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [29.0 kB]
           Get:10 http://archive.ubuntu.com/ubuntu/ trusty/main libwind0-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [47.8 kB]
           Get:11 http://archive.ubuntu.com/ubuntu/ trusty/main libhx509-5-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [104 kB]
           Get:12 http://archive.ubuntu.com/ubuntu/ trusty/main libkrb5-26-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [197 kB]
           Get:13 http://archive.ubuntu.com/ubuntu/ trusty/main libheimntlm0-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [15.2 kB]
           Get:14 http://archive.ubuntu.com/ubuntu/ trusty/main libgssapi3-heimdal amd64 1.6~git20131207+dfsg-1ubuntu1 [90.1 kB]
           Get:15 http://archive.ubuntu.com/ubuntu/ trusty/main libidn11 amd64 1.28-1ubuntu2 [93.0 kB]
           Get:16 http://archive.ubuntu.com/ubuntu/ trusty/main libsasl2-modules-db amd64 2.1.25.dfsg1-17build1 [14.9 kB]
           Get:17 http://archive.ubuntu.com/ubuntu/ trusty/main libsasl2-2 amd64 2.1.25.dfsg1-17build1 [56.5 kB]
           Get:18 http://archive.ubuntu.com/ubuntu/ trusty/main libldap-2.4-2 amd64 2.4.31-1+nmu2ubuntu8 [154 kB]
           Get:19 http://archive.ubuntu.com/ubuntu/ trusty/main librtmp0 amd64 2.4+20121230.gitdf6c518-1 [57.5 kB]
           Get:20 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libcurl3 amd64 7.35.0-1ubuntu2.3 [172 kB]
           Get:21 http://archive.ubuntu.com/ubuntu/ trusty-updates/main openssl amd64 1.0.1f-1ubuntu2.8 [489 kB]
           Get:22 http://archive.ubuntu.com/ubuntu/ trusty-updates/main ca-certificates all 20141019ubuntu0.14.04.1 [189 kB]
           Get:23 http://archive.ubuntu.com/ubuntu/ trusty-updates/main krb5-locales all 1.12+dfsg-2ubuntu5.1 [13.2 kB]
           Get:24 http://archive.ubuntu.com/ubuntu/ trusty/main libsasl2-modules amd64 2.1.25.dfsg1-17build1 [64.3 kB]
           Get:25 http://archive.ubuntu.com/ubuntu/ trusty-updates/main curl amd64 7.35.0-1ubuntu2.3 [123 kB]
           debconf: unable to initialize frontend: Dialog
           debconf: (TERM is not set, so the dialog frontend is not usable.)
           debconf: falling back to frontend: Readline
           debconf: unable to initialize frontend: Readline
           debconf: (This frontend requires a controlling tty.)
           debconf: falling back to frontend: Teletype
           dpkg-preconfigure: unable to re-open stdin:
           Fetched 2686 kB in 17s (156 kB/s)
           Selecting previously unselected package libroken18-heimdal:amd64.
           (Reading database ... 11527 files and directories currently installed.)
           Preparing to unpack .../libroken18-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libroken18-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libasn1-8-heimdal:amd64.
           Preparing to unpack .../libasn1-8-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libasn1-8-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libkrb5support0:amd64.
           Preparing to unpack .../libkrb5support0_1.12+dfsg-2ubuntu5.1_amd64.deb ...
           Unpacking libkrb5support0:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Selecting previously unselected package libk5crypto3:amd64.
           Preparing to unpack .../libk5crypto3_1.12+dfsg-2ubuntu5.1_amd64.deb ...
           Unpacking libk5crypto3:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Selecting previously unselected package libkeyutils1:amd64.
           Preparing to unpack .../libkeyutils1_1.5.6-1_amd64.deb ...
           Unpacking libkeyutils1:amd64 (1.5.6-1) ...
           Selecting previously unselected package libkrb5-3:amd64.
           Preparing to unpack .../libkrb5-3_1.12+dfsg-2ubuntu5.1_amd64.deb ...
           Unpacking libkrb5-3:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Selecting previously unselected package libgssapi-krb5-2:amd64.
           Preparing to unpack .../libgssapi-krb5-2_1.12+dfsg-2ubuntu5.1_amd64.deb ...
           Unpacking libgssapi-krb5-2:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Selecting previously unselected package libhcrypto4-heimdal:amd64.
           Preparing to unpack .../libhcrypto4-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libhcrypto4-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libheimbase1-heimdal:amd64.
           Preparing to unpack .../libheimbase1-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libheimbase1-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libwind0-heimdal:amd64.
           Preparing to unpack .../libwind0-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libwind0-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libhx509-5-heimdal:amd64.
           Preparing to unpack .../libhx509-5-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libhx509-5-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libkrb5-26-heimdal:amd64.
           Preparing to unpack .../libkrb5-26-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libkrb5-26-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libheimntlm0-heimdal:amd64.
           Preparing to unpack .../libheimntlm0-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libheimntlm0-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libgssapi3-heimdal:amd64.
           Preparing to unpack .../libgssapi3-heimdal_1.6~git20131207+dfsg-1ubuntu1_amd64.deb ...
           Unpacking libgssapi3-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Selecting previously unselected package libidn11:amd64.
           Preparing to unpack .../libidn11_1.28-1ubuntu2_amd64.deb ...
           Unpacking libidn11:amd64 (1.28-1ubuntu2) ...
           Selecting previously unselected package libsasl2-modules-db:amd64.
           Preparing to unpack .../libsasl2-modules-db_2.1.25.dfsg1-17build1_amd64.deb ...
           Unpacking libsasl2-modules-db:amd64 (2.1.25.dfsg1-17build1) ...
           Selecting previously unselected package libsasl2-2:amd64.
           Preparing to unpack .../libsasl2-2_2.1.25.dfsg1-17build1_amd64.deb ...
           Unpacking libsasl2-2:amd64 (2.1.25.dfsg1-17build1) ...
           Selecting previously unselected package libldap-2.4-2:amd64.
           Preparing to unpack .../libldap-2.4-2_2.4.31-1+nmu2ubuntu8_amd64.deb ...
           Unpacking libldap-2.4-2:amd64 (2.4.31-1+nmu2ubuntu8) ...
           Selecting previously unselected package librtmp0:amd64.
           Preparing to unpack .../librtmp0_2.4+20121230.gitdf6c518-1_amd64.deb ...
           Unpacking librtmp0:amd64 (2.4+20121230.gitdf6c518-1) ...
           Selecting previously unselected package libcurl3:amd64.
           Preparing to unpack .../libcurl3_7.35.0-1ubuntu2.3_amd64.deb ...
           Unpacking libcurl3:amd64 (7.35.0-1ubuntu2.3) ...
           Selecting previously unselected package openssl.
           Preparing to unpack .../openssl_1.0.1f-1ubuntu2.8_amd64.deb ...
           Unpacking openssl (1.0.1f-1ubuntu2.8) ...
           Selecting previously unselected package ca-certificates.
           Preparing to unpack .../ca-certificates_20141019ubuntu0.14.04.1_all.deb ...
           Unpacking ca-certificates (20141019ubuntu0.14.04.1) ...
           Selecting previously unselected package krb5-locales.
           Preparing to unpack .../krb5-locales_1.12+dfsg-2ubuntu5.1_all.deb ...
           Unpacking krb5-locales (1.12+dfsg-2ubuntu5.1) ...
           Selecting previously unselected package libsasl2-modules:amd64.
           Preparing to unpack .../libsasl2-modules_2.1.25.dfsg1-17build1_amd64.deb ...
           Unpacking libsasl2-modules:amd64 (2.1.25.dfsg1-17build1) ...
           Selecting previously unselected package curl.
           Preparing to unpack .../curl_7.35.0-1ubuntu2.3_amd64.deb ...
           Unpacking curl (7.35.0-1ubuntu2.3) ...
           Setting up libroken18-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libasn1-8-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libkrb5support0:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Setting up libk5crypto3:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Setting up libkeyutils1:amd64 (1.5.6-1) ...
           Setting up libkrb5-3:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Setting up libgssapi-krb5-2:amd64 (1.12+dfsg-2ubuntu5.1) ...
           Setting up libhcrypto4-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libheimbase1-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libwind0-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libhx509-5-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libkrb5-26-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libheimntlm0-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libgssapi3-heimdal:amd64 (1.6~git20131207+dfsg-1ubuntu1) ...
           Setting up libidn11:amd64 (1.28-1ubuntu2) ...
           Setting up libsasl2-modules-db:amd64 (2.1.25.dfsg1-17build1) ...
           Setting up libsasl2-2:amd64 (2.1.25.dfsg1-17build1) ...
           Setting up libldap-2.4-2:amd64 (2.4.31-1+nmu2ubuntu8) ...
           Setting up librtmp0:amd64 (2.4+20121230.gitdf6c518-1) ...
           Setting up libcurl3:amd64 (7.35.0-1ubuntu2.3) ...
           Setting up openssl (1.0.1f-1ubuntu2.8) ...
           Setting up ca-certificates (20141019ubuntu0.14.04.1) ...
           debconf: unable to initialize frontend: Dialog
           debconf: (TERM is not set, so the dialog frontend is not usable.)
           debconf: falling back to frontend: Readline
           debconf: unable to initialize frontend: Readline
           debconf: (This frontend requires a controlling tty.)
           debconf: falling back to frontend: Teletype
           Setting up krb5-locales (1.12+dfsg-2ubuntu5.1) ...
           Setting up libsasl2-modules:amd64 (2.1.25.dfsg1-17build1) ...
           Setting up curl (7.35.0-1ubuntu2.3) ...
           Processing triggers for libc-bin (2.19-0ubuntu6.5) ...
           Processing triggers for ca-certificates (20141019ubuntu0.14.04.1) ...
       Updating certificates in /etc/ssl/certs... 173 added, 0 removed; done.
       Running hooks in /etc/ca-certificates/update.d....done.
        ---> d2aef7fc72c2
       Removing intermediate container 6e3f99f25bbb
       Step 3 : RUN curl -L https://www.chef.io/chef/install.sh | bash
        ---> Running in d061c7d55ddd
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
    100 18358  100 18358    0     0   5776      0  0:00:03  0:00:03 --:--:--  5778
           Downloading Chef  for ubuntu...
           downloading https://www.chef.io/chef/metadata?v=&prerelease=false&nightlies=false&p=ubuntu&pv=14.04&m=x86_64
             to file /tmp/install.sh.9/metadata.txt
           trying curl...
           url      https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.1.0-1_amd64.deb
           md5      b86c3dd0171e896ab3fb42f26e688fef
           sha256   9bbde88f2eeb846a862512ab6385dff36278ff2ba8bd2e07a237a23337c4165a
           downloaded metadata file looks valid...
           downloading https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.1.0-1_amd64.deb
             to file /tmp/install.sh.9/chef_12.1.0-1_amd64.deb
           trying curl...
           Comparing checksum with sha256sum...
           Installing Chef
           installing with dpkg...
           Selecting previously unselected package chef.
           (Reading database ... 11996 files and directories currently installed.)
           Preparing to unpack .../chef_12.1.0-1_amd64.deb ...
           Unpacking chef (12.1.0-1) ...
           Setting up chef (12.1.0-1) ...
           Thank you for installing Chef!
            ---> 81a2853fb7dd
           Removing intermediate container d061c7d55ddd
           Successfully built 81a2853fb7dd
           fee9d4e86156e7ed7e72d7a46e0d02248ee143b789d8a5e737394ea7ba21a691
           Finished creating <default-ubuntu-1404> (7m1.37s).
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           Creating a new client identity for default-ubuntu-1404 using the validator key.
           [2015-03-07T01:13:53+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           [2015-03-07T01:13:53+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           [2015-03-07T01:13:53+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           Synchronizing Cookbooks:
             - myweb
           Compiling Cookbooks...
           Converging 0 resources
    
           Running handlers:
           Running handlers complete
           Chef Client finished, 0/0 resources updated in 1.362167123 seconds
           Finished converging <default-ubuntu-1404> (0m7.71s).
    -----> Setting up <default-ubuntu-1404>...
    Fetching: thor-0.19.0.gem (100%)
           Successfully installed thor-0.19.0
    Fetching: busser-0.6.2.gem (100%)
           Successfully installed busser-0.6.2
           2 gems installed
    -----> Setting up Busser
           Creating BUSSER_ROOT in /tmp/busser
           Creating busser binstub
           Plugin serverspec installed (version 0.5.3)
    -----> Running postinstall for serverspec plugin
           Finished setting up <default-ubuntu-1404> (0m18.22s).
    -----> Verifying <default-ubuntu-1404>...
           Suite path directory /tmp/busser/suites does not exist, skipping.
           Uploading /tmp/busser/suites/serverspec/default_spec.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
    -----> Running serverspec test suite
    -----> Installing Serverspec..
    Fetching: net-ssh-2.9.2.gem (100%)
    Fetching: net-scp-1.2.1.gem (100%)
    Fetching: specinfra-2.18.2.gem (100%)
    Fetching: multi_json-1.11.0.gem (100%)
    Fetching: diff-lcs-1.2.5.gem (100%)
    Fetching: rspec-support-3.2.2.gem (100%)
    Fetching: rspec-expectations-3.2.0.gem (100%)
    Fetching: rspec-core-3.2.1.gem (100%)
    Fetching: rspec-its-1.2.0.gem (100%)
    Fetching: rspec-mocks-3.2.1.gem (100%)
    Fetching: rspec-3.2.0.gem (100%)
    Fetching: serverspec-2.10.0.gem (100%)
    -----> serverspec installed (version 2.10.0)
           /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec
    
           myweb::default
             does something (PENDING: Replace this with meaningful tests)
    
           Pending: (Failures listed here are expected and do not affect your suite's status)
    
             1) myweb::default does something
                # Replace this with meaningful tests
                # /tmp/busser/suites/serverspec/default_spec.rb:8
    
    
           Finished in 0.00066 seconds (files took 0.42479 seconds to load)
           1 example, 0 failures, 1 pending
    
           Finished verifying <default-ubuntu-1404> (0m19.47s).
    -----> Destroying <default-ubuntu-1404>...
           fee9d4e86156e7ed7e72d7a46e0d02248ee143b789d8a5e737394ea7ba21a691
           Finished destroying <default-ubuntu-1404> (0m0.26s).
           Finished testing <default-ubuntu-1404> (7m47.12s).
    -----> Kitchen is finished. (7m47.48s)
    vagrant@ubuntu-trusty64-ja:~/myweb$ kitchen list
    Instance             Driver     Provisioner  Last Action
    default-ubuntu-1404  DockerCli  ChefZero     <Not Created>
    
```

## <a name="6">Serverspec</a>

```
    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen test
    -----> Starting Kitchen (v1.3.1)
    -----> Cleaning up any prior instances of <default-ubuntu-1404>
    -----> Destroying <default-ubuntu-1404>...
           c7152ddb8c4cd54ff8a48955d277357543238581d1a7feb8674658c7739fe463
           Finished destroying <default-ubuntu-1404> (0m0.26s).
    -----> Testing <default-ubuntu-1404>
    -----> Creating <default-ubuntu-1404>...
           Sending build context to Docker daemon 2.048 kB
           Sending build context to Docker daemon
           Step 0 : FROM ubuntu:14.04
            ---> 2d24f826cb16
           Step 1 : RUN apt-get update
            ---> Using cache
            ---> 087c63a9cf3e
           Step 2 : RUN apt-get -y install sudo curl tar
            ---> Using cache
            ---> d2aef7fc72c2
           Step 3 : RUN curl -L https://www.chef.io/chef/install.sh | bash
            ---> Using cache
            ---> 81a2853fb7dd
           Successfully built 81a2853fb7dd
           5cccd190a3724215640054195620946cbd9b71e3295acd9cf5e0188419bb9d98
           Finished creating <default-ubuntu-1404> (0m0.48s).
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           Creating a new client identity for default-ubuntu-1404 using the validator key.
           [2015-03-07T01:55:54+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           [2015-03-07T01:55:54+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           [2015-03-07T01:55:54+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           Synchronizing Cookbooks:
             - myweb
           Compiling Cookbooks...
           Converging 0 resources
    
    
           Running handlers complete
           Chef Client finished, 0/0 resources updated in 1.273229935 seconds
           Finished converging <default-ubuntu-1404> (0m3.53s).
    -----> Setting up <default-ubuntu-1404>...
    Fetching: thor-0.19.0.gem (100%)
           Successfully installed thor-0.19.0
    Fetching: busser-0.6.2.gem (100%)
       Successfully installed busser-0.6.2
       2 gems installed
    -----> Setting up Busser
           Creating BUSSER_ROOT in /tmp/busser
           Creating busser binstub
           Plugin serverspec installed (version 0.5.3)
    -----> Running postinstall for serverspec plugin
           Finished setting up <default-ubuntu-1404> (0m17.07s).
    -----> Verifying <default-ubuntu-1404>...
           Suite path directory /tmp/busser/suites does not exist, skipping.
           Uploading /tmp/busser/suites/serverspec/default_spec.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/default_spec.rb~ (mode=0664)
    -----> Running serverspec test suite
    -----> Installing Serverspec..
    Fetching: net-ssh-2.9.2.gem (100%)
    Fetching: net-scp-1.2.1.gem (100%)
    Fetching: specinfra-2.18.2.gem (100%)
    Fetching: multi_json-1.11.0.gem (100%)
    Fetching: diff-lcs-1.2.5.gem (100%)
    Fetching: rspec-support-3.2.2.gem (100%)
    Fetching: rspec-expectations-3.2.0.gem (100%)
    Fetching: rspec-core-3.2.1.gem (100%)
    Fetching: rspec-its-1.2.0.gem (100%)
    Fetching: rspec-mocks-3.2.1.gem (100%)
    Fetching: rspec-3.2.0.gem (100%)
    Fetching: serverspec-2.10.0.gem (100%)
    -----> serverspec installed (version 2.10.0)
           /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec

       myweb::default
         Service "nginx"
           should be enabled (FAILED - 1)
           should be running (FAILED - 2)

           should be listening (FAILED - 3)

       Failures:

         1) myweb::default Service "nginx" should be enabled
            Failure/Error: it { should be_enabled }
              expected Service "nginx" to be enabled
              /bin/sh -c ls\ /etc/rc3.d/\ \|\ grep\ --\ \'\^S..nginx\'\ \|\|\ grep\ \'start\ on\'\ /etc/init/nginx.conf
              grep: /etc/init/nginx.conf: No such file or directory

            # /tmp/busser/suites/serverspec/default_spec.rb:5:in `block (3 levels) in <top (required)>'

         2) myweb::default Service "nginx" should be running
            Failure/Error: it { should be_running }
              expected Service "nginx" to be running
              /bin/sh -c ps\ aux\ \|\ grep\ -w\ --\ nginx\ \|\ grep\ -qv\ grep

            # /tmp/busser/suites/serverspec/default_spec.rb:6:in `block (3 levels) in <top (required)>'

         3) myweb::default Port "80" should be listening
            Failure/Error: it { should be_listening.with('tcp') }
              expected Port "80" to be listening
              /bin/sh -c netstat\ -tunl\ \|\ grep\ --\ \\\^tcp\\\ .\\\*:80\\\



       Finished in 0.33981 seconds (files took 0.39423 seconds to load)
       3 examples, 3 failures

       Failed examples:

       rspec /tmp/busser/suites/serverspec/default_spec.rb:5 # myweb::default Service "nginx" should be enabled
       rspec /tmp/busser/suites/serverspec/default_spec.rb:6 # myweb::default Service "nginx" should be running
       rspec /tmp/busser/suites/serverspec/default_spec.rb:10 # myweb::default Port "80" should be listening

       /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec failed
       Ruby Script [/tmp/busser/gems/gems/busser-serverspec-0.5.3/lib/busser/runner_plugin/../serverspec/runner.rb /tmp/busser/suites/serverspec] exit code was 1
    >>>>>> ------Exception-------
    >>>>>> Class: Kitchen::ActionFailed
    >>>>>> Message: Failed to complete #verify action: [Expected process to exit with [0], but received '1'
    ---- Begin output of docker exec -t 5cccd190a3724215640054195620946cbd9b71e3295acd9cf5e0188419bb9d98 sh -c '
    BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache"
    export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE
    
    sudo -E /tmp/busser/bin/busser test
    ' ----
    STDOUT: -----> Running serverspec test suite
    -----> Installing Serverspec..
    Fetching: net-ssh-2.9.2.gem (100%)
    Fetching: net-scp-1.2.1.gem (100%)
    Fetching: specinfra-2.18.2.gem (100%)
    Fetching: multi_json-1.11.0.gem (100%)
    Fetching: diff-lcs-1.2.5.gem (100%)
    Fetching: rspec-support-3.2.2.gem (100%)
    Fetching: rspec-expectations-3.2.0.gem (100%)
    Fetching: rspec-core-3.2.1.gem (100%)
    Fetching: rspec-its-1.2.0.gem (100%)
    Fetching: rspec-mocks-3.2.1.gem (100%)
    Fetching: rspec-3.2.0.gem (100%)
    Fetching: serverspec-2.10.0.gem (100%)
    -----> serverspec installed (version 2.10.0)
    /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec
    
    myweb::default
      Service "nginx"
        should be enabled (FAILED - 1)
        should be running (FAILED - 2)
      Port "80"
        should be listening (FAILED - 3)
    
    Failures:
    
      1) myweb::default Service "nginx" should be enabled
         Failure/Error: it { should be_enabled }
           expected Service "nginx" to be enabled
           /bin/sh -c ls\ /etc/rc3.d/\ \|\ grep\ --\ \'\^S..nginx\'\ \|\|\ grep\ \'start\ on\'\ /etc/init/nginx.conf
           grep: /etc/init/nginx.conf: No such file or directory
    
         # /tmp/busser/suites/serverspec/default_spec.rb:5:in `block (3 levels) in <top (required)>'
    
      2) myweb::default Service "nginx" should be running
         Failure/Error: it { should be_running }
           expected Service "nginx" to be running
           /bin/sh -c ps\ aux\ \|\ grep\ -w\ --\ nginx\ \|\ grep\ -qv\ grep
    
         # /tmp/busser/suites/serverspec/default_spec.rb:6:in `block (3 levels) in <top (required)>'
    
      3) myweb::default Port "80" should be listening
         Failure/Error: it { should be_listening.with('tcp') }
           expected Port "80" to be listening
           /bin/sh -c netstat\ -tunl\ \|\ grep\ --\ \\\^tcp\\\ .\\\*:80\\\
    
         # /tmp/busser/suites/serverspec/default_spec.rb:10:in `block (3 levels) in <top (required)>'
    
    Finished in 0.33981 seconds (files took 0.39423 seconds to load)
    3 examples, 3 failures
    
    Failed examples:
    
    rspec /tmp/busser/suites/serverspec/default_spec.rb:5 # myweb::default Service "nginx" should be enabled
    rspec /tmp/busser/suites/serverspec/default_spec.rb:6 # myweb::default Service "nginx" should be running
    rspec /tmp/busser/suites/serverspec/default_spec.rb:10 # myweb::default Port "80" should be listening
    
    /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec failed
    Ruby Script [/tmp/busser/gems/gems/busser-serverspec-0.5.3/lib/busser/runner_plugin/../serverspec/runner.rb /tmp/busser/suites/serverspec] exit code was 1
    STDERR:
    ---- End output of docker exec -t 5cccd190a3724215640054195620946cbd9b71e3295acd9cf5e0188419bb9d98 sh -c '
    BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache"
    export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE
    
    sudo -E /tmp/busser/bin/busser test
    ' ----
    Ran docker exec -t 5cccd190a3724215640054195620946cbd9b71e3295acd9cf5e0188419bb9d98 sh -c '
    BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache"
    export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE
    
    sudo -E /tmp/busser/bin/busser test
    ' returned 1]
    >>>>>> ----------------------
    >>>>>> Please see .kitchen/logs/kitchen.log for more details
    >>>>>> Also try running `kitchen diagnose --all` for configuration
    
    ```
    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen login
    root@5cccd190a372:/# apt-get -y install nginx
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following extra packages will be installed:
      fontconfig-config fonts-dejavu-core geoip-database libfontconfig1
      libfreetype6 libgd3 libgeoip1 libjbig0 libjpeg-turbo8 libjpeg8 libtiff5
      libvpx1 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxml2 libxpm4
      libxslt1.1 nginx-common nginx-core sgml-base xml-core
    Suggested packages:
      libgd-tools geoip-bin fcgiwrap nginx-doc sgml-base-doc debhelper
    The following NEW packages will be installed:
      fontconfig-config fonts-dejavu-core geoip-database libfontconfig1
      libfreetype6 libgd3 libgeoip1 libjbig0 libjpeg-turbo8 libjpeg8 libtiff5
      libvpx1 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxml2 libxpm4
      libxslt1.1 nginx nginx-common nginx-core sgml-base xml-core
    0 upgraded, 25 newly installed, 0 to remove and 7 not upgraded.
    Need to get 5612 kB of archives.
    After this operation, 19.8 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu/ trusty/main libgeoip1 amd64 1.6.0-1 [71.0 kB]
    Get:2 http://archive.ubuntu.com/ubuntu/ trusty/main libxau6 amd64 1:1.0.8-1 [8376 B]
    Get:3 http://archive.ubuntu.com/ubuntu/ trusty/main libxdmcp6 amd64 1:1.1.1-1 [12.8 kB]
    Get:4 http://archive.ubuntu.com/ubuntu/ trusty/main libxcb1 amd64 1.10-2ubuntu1 [38.0 kB]
    Get:5 http://archive.ubuntu.com/ubuntu/ trusty/main libx11-data all 2:1.6.2-1ubuntu2 [111 kB]
    Get:6 http://archive.ubuntu.com/ubuntu/ trusty/main libx11-6 amd64 2:1.6.2-1ubuntu2 [560 kB]
    Get:7 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libxml2 amd64 2.9.1+dfsg1-3ubuntu4.4 [570 kB]
    Get:8 http://archive.ubuntu.com/ubuntu/ trusty/main sgml-base all 1.26+nmu4ubuntu1 [12.5 kB]
    Get:9 http://archive.ubuntu.com/ubuntu/ trusty/main fonts-dejavu-core all 2.34-1ubuntu1 [1024 kB]
    Get:10 http://archive.ubuntu.com/ubuntu/ trusty-updates/main fontconfig-config all 2.11.0-0ubuntu4.1 [47.4 kB]
    Get:11 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libfreetype6 amd64 2.5.2-1ubuntu2.4 [305 kB]
    Get:12 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libfontconfig1 amd64 2.11.0-0ubuntu4.1 [123 kB]
    Get:13 http://archive.ubuntu.com/ubuntu/ trusty/main libjpeg-turbo8 amd64 1.3.0-0ubuntu2 [104 kB]
    Get:14 http://archive.ubuntu.com/ubuntu/ trusty/main libjpeg8 amd64 8c-2ubuntu8 [2194 B]
    Get:15 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libjbig0 amd64 2.0-2ubuntu4.1 [26.1 kB]
    Get:16 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libtiff5 amd64 4.0.3-7ubuntu0.1 [142 kB]
    Get:17 http://archive.ubuntu.com/ubuntu/ trusty/main libvpx1 amd64 1.3.0-2 [556 kB]
    Get:18 http://archive.ubuntu.com/ubuntu/ trusty/main libxpm4 amd64 1:3.5.10-1 [38.3 kB]
    Get:19 http://archive.ubuntu.com/ubuntu/ trusty/main libgd3 amd64 2.1.0-3 [147 kB]
    Get:20 http://archive.ubuntu.com/ubuntu/ trusty/main libxslt1.1 amd64 1.1.28-2build1 [145 kB]
    Get:21 http://archive.ubuntu.com/ubuntu/ trusty/main geoip-database all 20140313-1 [1196 kB]
    Get:22 http://archive.ubuntu.com/ubuntu/ trusty/main xml-core all 0.13+nmu2 [23.3 kB]
    Get:23 http://archive.ubuntu.com/ubuntu/ trusty-updates/main nginx-common all 1.4.6-1ubuntu3.2 [18.1 kB]
    Get:24 http://archive.ubuntu.com/ubuntu/ trusty-updates/main nginx-core amd64 1.4.6-1ubuntu3.2 [325 kB]
    Get:25 http://archive.ubuntu.com/ubuntu/ trusty-updates/main nginx all 1.4.6-1ubuntu3.2 [5420 B]
    Fetched 5612 kB in 38s (146 kB/s)
    Selecting previously unselected package libgeoip1:amd64.
    (Reading database ... 28119 files and directories currently installed.)
    Preparing to unpack .../libgeoip1_1.6.0-1_amd64.deb ...
    Unpacking libgeoip1:amd64 (1.6.0-1) ...
    Selecting previously unselected package libxau6:amd64.
    Preparing to unpack .../libxau6_1%3a1.0.8-1_amd64.deb ...
    Unpacking libxau6:amd64 (1:1.0.8-1) ...
    Selecting previously unselected package libxdmcp6:amd64.
    Preparing to unpack .../libxdmcp6_1%3a1.1.1-1_amd64.deb ...
    Unpacking libxdmcp6:amd64 (1:1.1.1-1) ...
    Selecting previously unselected package libxcb1:amd64.
    Preparing to unpack .../libxcb1_1.10-2ubuntu1_amd64.deb ...
    Unpacking libxcb1:amd64 (1.10-2ubuntu1) ...
    Selecting previously unselected package libx11-data.
    Preparing to unpack .../libx11-data_2%3a1.6.2-1ubuntu2_all.deb ...
    Unpacking libx11-data (2:1.6.2-1ubuntu2) ...
    Selecting previously unselected package libx11-6:amd64.
    Preparing to unpack .../libx11-6_2%3a1.6.2-1ubuntu2_amd64.deb ...
    Unpacking libx11-6:amd64 (2:1.6.2-1ubuntu2) ...
    Selecting previously unselected package libxml2:amd64.
    Preparing to unpack .../libxml2_2.9.1+dfsg1-3ubuntu4.4_amd64.deb ...
    Unpacking libxml2:amd64 (2.9.1+dfsg1-3ubuntu4.4) ...
    Selecting previously unselected package sgml-base.
    Preparing to unpack .../sgml-base_1.26+nmu4ubuntu1_all.deb ...
    Unpacking sgml-base (1.26+nmu4ubuntu1) ...
    Selecting previously unselected package fonts-dejavu-core.
    Preparing to unpack .../fonts-dejavu-core_2.34-1ubuntu1_all.deb ...
    Unpacking fonts-dejavu-core (2.34-1ubuntu1) ...
    Selecting previously unselected package fontconfig-config.
    Preparing to unpack .../fontconfig-config_2.11.0-0ubuntu4.1_all.deb ...
    Unpacking fontconfig-config (2.11.0-0ubuntu4.1) ...
    Selecting previously unselected package libfreetype6:amd64.
    Preparing to unpack .../libfreetype6_2.5.2-1ubuntu2.4_amd64.deb ...
    Unpacking libfreetype6:amd64 (2.5.2-1ubuntu2.4) ...
    Selecting previously unselected package libfontconfig1:amd64.
    Preparing to unpack .../libfontconfig1_2.11.0-0ubuntu4.1_amd64.deb ...
    Unpacking libfontconfig1:amd64 (2.11.0-0ubuntu4.1) ...
    Selecting previously unselected package libjpeg-turbo8:amd64.
    Preparing to unpack .../libjpeg-turbo8_1.3.0-0ubuntu2_amd64.deb ...
    Unpacking libjpeg-turbo8:amd64 (1.3.0-0ubuntu2) ...
    Selecting previously unselected package libjpeg8:amd64.
    Preparing to unpack .../libjpeg8_8c-2ubuntu8_amd64.deb ...
    Unpacking libjpeg8:amd64 (8c-2ubuntu8) ...
    Selecting previously unselected package libjbig0:amd64.
    Preparing to unpack .../libjbig0_2.0-2ubuntu4.1_amd64.deb ...
    Unpacking libjbig0:amd64 (2.0-2ubuntu4.1) ...
    Selecting previously unselected package libtiff5:amd64.
    Preparing to unpack .../libtiff5_4.0.3-7ubuntu0.1_amd64.deb ...
    Unpacking libtiff5:amd64 (4.0.3-7ubuntu0.1) ...
    Selecting previously unselected package libvpx1:amd64.
    Preparing to unpack .../libvpx1_1.3.0-2_amd64.deb ...
    Unpacking libvpx1:amd64 (1.3.0-2) ...
    Selecting previously unselected package libxpm4:amd64.
    Preparing to unpack .../libxpm4_1%3a3.5.10-1_amd64.deb ...
    Unpacking libxpm4:amd64 (1:3.5.10-1) ...
    Selecting previously unselected package libgd3:amd64.
    Preparing to unpack .../libgd3_2.1.0-3_amd64.deb ...
    Unpacking libgd3:amd64 (2.1.0-3) ...
    Selecting previously unselected package libxslt1.1:amd64.
    Preparing to unpack .../libxslt1.1_1.1.28-2build1_amd64.deb ...
    Unpacking libxslt1.1:amd64 (1.1.28-2build1) ...
    Selecting previously unselected package geoip-database.
    Preparing to unpack .../geoip-database_20140313-1_all.deb ...
    Unpacking geoip-database (20140313-1) ...
    Selecting previously unselected package xml-core.
    Preparing to unpack .../xml-core_0.13+nmu2_all.deb ...
    Unpacking xml-core (0.13+nmu2) ...
    Selecting previously unselected package nginx-common.
    Preparing to unpack .../nginx-common_1.4.6-1ubuntu3.2_all.deb ...
    Unpacking nginx-common (1.4.6-1ubuntu3.2) ...
    Selecting previously unselected package nginx-core.
    Preparing to unpack .../nginx-core_1.4.6-1ubuntu3.2_amd64.deb ...
    Unpacking nginx-core (1.4.6-1ubuntu3.2) ...
    Selecting previously unselected package nginx.
    Preparing to unpack .../nginx_1.4.6-1ubuntu3.2_all.deb ...
    Unpacking nginx (1.4.6-1ubuntu3.2) ...
    Processing triggers for ureadahead (0.100.0-16) ...
    Setting up libgeoip1:amd64 (1.6.0-1) ...
    Setting up libxau6:amd64 (1:1.0.8-1) ...
    Setting up libxdmcp6:amd64 (1:1.1.1-1) ...
    Setting up libxcb1:amd64 (1.10-2ubuntu1) ...
    Setting up libx11-data (2:1.6.2-1ubuntu2) ...
    Setting up libx11-6:amd64 (2:1.6.2-1ubuntu2) ...
    Setting up libxml2:amd64 (2.9.1+dfsg1-3ubuntu4.4) ...
    Setting up sgml-base (1.26+nmu4ubuntu1) ...
    Setting up fonts-dejavu-core (2.34-1ubuntu1) ...
    Setting up fontconfig-config (2.11.0-0ubuntu4.1) ...
    Setting up libfreetype6:amd64 (2.5.2-1ubuntu2.4) ...
    Setting up libfontconfig1:amd64 (2.11.0-0ubuntu4.1) ...
    Setting up libjpeg-turbo8:amd64 (1.3.0-0ubuntu2) ...
    Setting up libjpeg8:amd64 (8c-2ubuntu8) ...
    Setting up libjbig0:amd64 (2.0-2ubuntu4.1) ...
    Setting up libtiff5:amd64 (4.0.3-7ubuntu0.1) ...
    Setting up libvpx1:amd64 (1.3.0-2) ...
    Setting up libxpm4:amd64 (1:3.5.10-1) ...
    Setting up libgd3:amd64 (2.1.0-3) ...
    Setting up libxslt1.1:amd64 (1.1.28-2build1) ...
    Setting up geoip-database (20140313-1) ...
    Setting up xml-core (0.13+nmu2) ...
    Setting up nginx-common (1.4.6-1ubuntu3.2) ...
    Processing triggers for ureadahead (0.100.0-16) ...
    Setting up nginx-core (1.4.6-1ubuntu3.2) ...
    invoke-rc.d: policy-rc.d denied execution of start.
    Setting up nginx (1.4.6-1ubuntu3.2) ...
    Processing triggers for libc-bin (2.19-0ubuntu6.5) ...
    Processing triggers for sgml-base (1.26+nmu4ubuntu1) ...
    root@5cccd190a372:/# service nginx start
    root@5cccd190a372:/# exit
    exit
    ```
    
    ```
    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen verify
    -----> Starting Kitchen (v1.3.1)
    -----> Verifying <default-ubuntu-1404>...
           Removing /tmp/busser/suites/serverspec
           Uploading /tmp/busser/suites/serverspec/default_spec.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/default_spec.rb~ (mode=0664)
    -----> Running serverspec test suite
           /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec
    
           myweb::default
    
               should be enabled
               should be running
             Port "80"
               should be listening
    
           Finished in 0.26159 seconds (files took 0.40098 seconds to load)
           3 examples, 0 failures
    
           Finished verifying <default-ubuntu-1404> (0m3.98s).
    -----> Kitchen is finished. (0m4.36s)
    ```
    
    ## <a name="7">ChefSpec</a>
    
    [動かない](https://github.com/k2works/chefDK-handson/issues/1)
    
    ## <a name="8">test-kitchenでのchefの実行</a>
    仮想マシンのUbuntuデスクトップならばFirFoxを起動して_﻿http://localhost:8100/_にアクセスする。
    コマンドラインからは以下の操作で確認する。
    
    ```
    
        vagrant@ubuntu-trusty64-ja:~$ curl localhost:8100
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to nginx!</title>
        <style>
            body {
                width: 35em;
                margin: 0 auto;
                font-family: Tahoma, Verdana, Arial, sans-serif;
            }
        </style>
        </head>
        <body>
        <h1>Welcome to nginx!</h1>
        <p>If you see this page, the nginx web server is successfully installed and
        working. Further configuration is required.</p>
    
        <p>For online documentation and support please refer to
        <a href="http://nginx.org/">nginx.org</a>.<br/>
        Commercial support is available at
        <a href="http://nginx.com/">nginx.com</a>.</p>
    
        <p><em>Thank you for using nginx.</em></p>
        </body>
        </html>
    
    ```
    
    
    ```
    
        vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen test -d never
        -----> Starting Kitchen (v1.3.1)
        -----> Cleaning up any prior instances of <default-ubuntu-1404>
        -----> Destroying <default-ubuntu-1404>...
               5cccd190a3724215640054195620946cbd9b71e3295acd9cf5e0188419bb9d98
               Finished destroying <default-ubuntu-1404> (0m0.90s).
        -----> Testing <default-ubuntu-1404>
        -----> Creating <default-ubuntu-1404>...
               Sending build context to Docker daemon 2.048 kB
               Sending build context to Docker daemon
               Step 0 : FROM ubuntu:14.04
                ---> 2d24f826cb16
               Step 1 : RUN apt-get update
                ---> Using cache
                ---> 087c63a9cf3e
               Step 2 : RUN apt-get -y install sudo curl tar
                ---> Using cache
                ---> d2aef7fc72c2
               Step 3 : RUN curl -L https://www.chef.io/chef/install.sh | bash
                ---> Using cache
                ---> 81a2853fb7dd
               Successfully built 81a2853fb7dd
               61ea5d837c0e55acefb5bc5fa6a5a2da6858240e5e66f7133248549f92cfc492
               Finished creating <default-ubuntu-1404> (0m0.50s).
        -----> Converging <default-ubuntu-1404>...
               Preparing files for transfer
               Preparing dna.json
               Resolving cookbook dependencies with Berkshelf 3.2.3...
               Removing non-cookbook files before transfer
               Preparing validation.pem
               Preparing client.rb
               Starting Chef Client, version 12.1.0
               Creating a new client identity for default-ubuntu-1404 using the validator key.
               [2015-03-07T02:48:46+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
               [2015-03-07T02:48:46+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
               resolving cookbooks for run list: ["myweb::default"]
               [2015-03-07T02:48:46+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
               Synchronizing Cookbooks:
                 - myweb
               Compiling Cookbooks...
           Converging 2 resources
           Recipe: myweb::default

           - install version 1.4.6-1ubuntu3.2 of package nginx

           - start service service[nginx]

           Running handlers:
           Running handlers complete
           Chef Client finished, 2/2 resources updated in 232.648714674 seconds
           Finished converging <default-ubuntu-1404> (3m56.88s).
    -----> Setting up <default-ubuntu-1404>...
    Fetching: thor-0.19.0.gem (100%)
           Successfully installed thor-0.19.0
    Fetching: busser-0.6.2.gem (100%)
           Successfully installed busser-0.6.2
           2 gems installed
    -----> Setting up Busser

           Creating busser binstub
           Plugin serverspec installed (version 0.5.3)
    -----> Running postinstall for serverspec plugin
           Finished setting up <default-ubuntu-1404> (0m18.32s).
    -----> Verifying <default-ubuntu-1404>...
           Suite path directory /tmp/busser/suites does not exist, skipping.
           Uploading /tmp/busser/suites/serverspec/default_spec.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/default_spec.rb~ (mode=0664)
    -----> Running serverspec test suite
    -----> Installing Serverspec..
    Fetching: net-ssh-2.9.2.gem (100%)
    Fetching: net-scp-1.2.1.gem (100%)
    Fetching: specinfra-2.18.2.gem (100%)
    Fetching: multi_json-1.11.0.gem (100%)
    Fetching: diff-lcs-1.2.5.gem (100%)
    Fetching: rspec-support-3.2.2.gem (100%)
    Fetching: rspec-expectations-3.2.0.gem (100%)
    Fetching: rspec-core-3.2.1.gem (100%)
    Fetching: rspec-its-1.2.0.gem (100%)
    Fetching: rspec-mocks-3.2.1.gem (100%)
    Fetching: rspec-3.2.0.gem (100%)
    Fetching: serverspec-2.10.0.gem (100%)
    -----> serverspec installed (version 2.10.0)
           /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec

           myweb::default

               should be enabled
               should be running
             Port "80"
               should be listening

           Finished in 0.38016 seconds (files took 0.42433 seconds to load)
           3 examples, 0 failures

           Finished verifying <default-ubuntu-1404> (0m18.59s).
           Finished testing <default-ubuntu-1404> (4m35.21s).
    -----> Kitchen is finished. (4m35.60s)

```

```
vagrant@ubuntu-trusty64-ja:~/myweb$ chef generate template index.html
Compiling Cookbooks...
Recipe: code_generator::template
  * directory[/home/vagrant/myweb/templates/default] action create
    - create new directory /home/vagrant/myweb/templates/default
  * template[/home/vagrant/myweb/templates/default/index.html.erb] action create
    - create new file /home/vagrant/myweb/templates/default/index.html.erb
    - update content in file /home/vagrant/myweb/templates/default/index.html.erb from none to e3b0c4
    (diff output suppressed by config)
```

```

    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen converge
    -----> Starting Kitchen (v1.3.1)
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           [2015-03-07T02:58:01+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           Synchronizing Cookbooks:
             - myweb
           Compiling Cookbooks...
           Converging 3 resources
           Recipe: myweb::default
             * apt_package[nginx] action install (up to date)
             * service[nginx] action start (up to date)
             * template[/usr/share/nginx/html/index.html] action create
               - update content in file /usr/share/nginx/html/index.html from 38ffd4 to 3a5393
               --- /usr/share/nginx/html/index.html 2014-03-04 11:46:45.000000000 +0000
               +++ /tmp/chef-rendered-template20150307-900-8kei5r   2015-03-07 02:58:13.947233190 +0000
               @@ -1,26 +1,2 @@
           -<!DOCTYPE html>
               -<html>
               -<head>
           -<title>Welcome to nginx!</title>
               -<style>
               -    body {
               -        width: 35em;
               -        margin: 0 auto;
               -        font-family: Tahoma, Verdana, Arial, sans-serif;
               -    }
               -</style>
               -</head>
               -<body>
               -<h1>Welcome to nginx!</h1>
               -<p>If you see this page, the nginx web server is successfully installed and
               -working. Further configuration is required.</p>
               -
               -<p>For online documentation and support please refer to
               -<a href="http://nginx.org/">nginx.org</a>.<br/>
               -Commercial support is available at
               -<a href="http://nginx.com/">nginx.com</a>.</p>
               -
               -<p><em>Thank you for using nginx.</em></p>
               -</body>
               -</html>

               - change mode from '0644' to '01204'
               - change owner from 'root' to 'www-data'


           Running handlers:
           Running handlers complete
           Chef Client finished, 1/3 resources updated in 14.010527644 seconds
           Finished converging <default-ubuntu-1404> (0m16.19s).
    -----> Kitchen is finished. (0m16.56s)

```

## <a name="9">Foodcritic</a>

```
vagrant@ubuntu-trusty64-ja:~/myweb$ foodcritic .
FC006: Mode should be quoted or fully specified when setting file permissions: ./recipes/default.rb:12
```

```

    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen converge
    -----> Starting Kitchen (v1.3.1)
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           [2015-03-07T03:00:37+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           Synchronizing Cookbooks:
             - myweb
           Compiling Cookbooks...
           Converging 3 resources

             * apt_package[nginx] action install (up to date)
             * service[nginx] action start (up to date)
             * template[/usr/share/nginx/html/index.html] action create (up to date)

           Running handlers:
           Running handlers complete
           Chef Client finished, 0/3 resources updated in 13.872739739 seconds
           Finished converging <default-ubuntu-1404> (0m17.96s).
    -----> Kitchen is finished. (0m18.34s)
    vagrant@ubuntu-trusty64-ja:~/myweb$ curl localhost:8100
    Hello default-ubuntu-1404

```

## <a name="10">Berkshelf</a>

```

    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen converge
    -----> Starting Kitchen (v1.3.1)
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           [2015-03-07T03:04:23+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           Synchronizing Cookbooks:
             - myweb
             - nginx
             - apt
             - bluepill
             - build-essential
             - ohai
             - runit
             - yum-epel
             - rsyslog
             - yum
           Compiling Cookbooks...
           Recipe: ohai::default
           * remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action create
             Recipe: <Dynamically Defined Resource>
           * cookbook_file[/etc/chef/ohai_plugins/README] action create (up to date)
            (up to date)
           Recipe: ohai::default
           [2015-03-07T03:04:24+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.chef.io/ohai_custom.html

           - re-run ohai and merge results into node attributes
           [2015-03-07T03:04:26+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
           [2015-03-07T03:04:26+00:00] WARN: Previous service[nginx]: /tmp/kitchen/cache/cookbooks/nginx/recipes/package.rb:46:in `from_file'
           [2015-03-07T03:04:26+00:00] WARN: Current  service[nginx]: /tmp/kitchen/cache/cookbooks/nginx/recipes/default.rb:24:in `from_file'
             Converging 19 resources
           Recipe: nginx::ohai_plugin
             * ohai[reload_nginx] action nothing (skipped due to action :nothing)
            (up to date)

             * remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action nothing (skipped due to action :nothing)
             * ohai[custom_plugins] action nothing (skipped due to action :nothing)
           Recipe: nginx::package
            (skipped due to not_if)
             * service[nginx] action enable (up to date)
           Recipe: nginx::commons_dir
            (up to date)
             * directory[/var/log/nginx] action create (up to date)
             * directory[/var/run] action create (up to date)
             * directory[/etc/nginx/sites-available] action create (up to date)
             * directory[/etc/nginx/sites-enabled] action create (up to date)
             * directory[/etc/nginx/conf.d] action create (up to date)
           Recipe: nginx::commons_script
             * template[/usr/sbin/nxensite] action create (up to date)
             * template[/usr/sbin/nxdissite] action create (up to date)
           Recipe: nginx::commons_conf
            (up to date)
           * template[/etc/nginx/sites-available/default] action create (up to date)
           * execute[nxensite default] action run (skipped due to not_if)
           Recipe: nginx::default

           - start service service[nginx]
           Recipe: myweb::default
           * template[/usr/share/nginx/html/index.html] action create (up to date)

           Running handlers:
           Running handlers complete
           Chef Client finished, 2/17 resources updated in 6.809011578 seconds
           Finished converging <default-ubuntu-1404> (0m11.14s).
    -----> Kitchen is finished. (0m11.55s)
    vagrant@ubuntu-trusty64-ja:~/myweb$ curl localhost:8100
    <html>
    <head><title>404 Not Found</title></head>
    <body bgcolor="white">
    <center><h1>404 Not Found</h1></center>
    <hr><center>nginx/1.4.6 (Ubuntu)</center>
    </body>
    </html>

```

```

    ﻿vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen converge
    -----> Starting Kitchen (v1.3.1)
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           [2015-03-07T03:06:00+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           Synchronizing Cookbooks:
             - myweb
             - apt
             - nginx
             - bluepill
             - build-essential
             - ohai
             - yum-epel
             - runit
             - rsyslog
             - yum
           Compiling Cookbooks...
           Recipe: ohai::default
             * remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action create
             Recipe: <Dynamically Defined Resource>
           * cookbook_file[/etc/chef/ohai_plugins/README] action create (up to date)
                (up to date)
           Recipe: ohai::default
           [2015-03-07T03:06:01+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.chef.io/ohai_custom.html

           - re-run ohai and merge results into node attributes
           [2015-03-07T03:06:02+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
           [2015-03-07T03:06:02+00:00] WARN: Previous service[nginx]: /tmp/kitchen/cache/cookbooks/nginx/recipes/package.rb:46:in `from_file'

             Converging 19 resources
           Recipe: nginx::ohai_plugin
             * ohai[reload_nginx] action nothing (skipped due to action :nothing)
            (up to date)
           Recipe: ohai::default
             * remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action nothing (skipped due to action :nothing)

           Recipe: nginx::package
            (skipped due to not_if)
            (up to date)
           Recipe: nginx::commons_dir
             * directory[/etc/nginx] action create (up to date)
             * directory[/var/log/nginx] action create (up to date)
           * directory[/var/run] action create (up to date)
           * directory[/etc/nginx/sites-available] action create (up to date)
           * directory[/etc/nginx/sites-enabled] action create (up to date)
            (up to date)
           Recipe: nginx::commons_script
            (up to date)
            (up to date)
           Recipe: nginx::commons_conf
            (up to date)

               - update content in file /etc/nginx/sites-available/default from d8363e to 9eeefd
               --- /etc/nginx/sites-available/default	2015-03-07 03:04:05.563245480 +0000
               +++ /tmp/chef-rendered-template20150307-2679-1mzjsff	2015-03-07 03:06:03.035249586 +0000
               @@ -5,7 +5,7 @@
           access_log  /var/log/nginx/localhost.access.log;

           location / {
               -    root   /var/www/nginx-default;
               +    root   /usr/share/nginx/html;
             index  index.html index.htm;
           }
                }
             * execute[nxensite default] action run (skipped due to not_if)
           Recipe: nginx::default


           Recipe: myweb::default
            (up to date)
           Recipe: nginx::default
             * service[nginx] action reload (up to date)

           Running handlers:
           Running handlers complete
           Chef Client finished, 3/18 resources updated in 6.706450234 seconds
           Finished converging <default-ubuntu-1404> (0m11.02s).
    -----> Kitchen is finished. (0m11.39s)
    vagrant@ubuntu-trusty64-ja:~/myweb$ curl localhost:8100
    Hello default-ubuntu-1404

```

```
    vagrant@ubuntu-trusty64-ja:~/myweb$ sudo kitchen test -d never
    -----> Starting Kitchen (v1.3.1)
    -----> Cleaning up any prior instances of <default-ubuntu-1404>
    -----> Destroying <default-ubuntu-1404>...
           25e7ea4640a5893616339c3942696d596ce34bdd5fb1fc55f0d2e1f7c6249fe0
           Finished destroying <default-ubuntu-1404> (0m0.84s).
    -----> Testing <default-ubuntu-1404>
    -----> Creating <default-ubuntu-1404>...
           Sending build context to Docker daemon 2.048 kB
           Sending build context to Docker daemon
           Step 0 : FROM ubuntu:14.04
            ---> 2d24f826cb16
           Step 1 : RUN apt-get update
            ---> Using cache
            ---> 087c63a9cf3e
           Step 2 : RUN apt-get -y install sudo curl tar
            ---> Using cache
            ---> d2aef7fc72c2
           Step 3 : RUN curl -L https://www.chef.io/chef/install.sh | bash
            ---> Using cache
            ---> 81a2853fb7dd
           Successfully built 81a2853fb7dd
           c81cea74d8c13dcfe7a89138ea34d7d7a8d28e5f517a04ec62066a88dba9c097
           Finished creating <default-ubuntu-1404> (0m0.53s).
    -----> Converging <default-ubuntu-1404>...
           Preparing files for transfer
           Preparing dna.json
           Resolving cookbook dependencies with Berkshelf 3.2.3...
           Removing non-cookbook files before transfer
           Preparing validation.pem
           Preparing client.rb
           Starting Chef Client, version 12.1.0
           Creating a new client identity for default-ubuntu-1404 using the validator key.
           [2015-03-07T03:59:14+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           [2015-03-07T03:59:14+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           resolving cookbooks for run list: ["myweb::default"]
           [2015-03-07T03:59:14+00:00] WARN: Child with name 'dna.json' found in multiple directories: /tmp/kitchen/dna.json and /tmp/kitchen/dna.json
           Synchronizing Cookbooks:
             - myweb
             - nginx
             - apt
             - bluepill
             - build-essential
             - ohai
             - runit
             - yum-epel
             - rsyslog
             - yum
           Compiling Cookbooks...
           Recipe: ohai::default
           * remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action create
           - create new directory /etc/chef/ohai_plugins
    
             Recipe: <Dynamically Defined Resource>
    
    
                 - update content in file /etc/chef/ohai_plugins/README from none to 775fa7
                 --- /etc/chef/ohai_plugins/README  2015-03-07 03:59:20.454228349 +0000
                 +++ /etc/chef/ohai_plugins/.README20150307-39-lyjype       2015-03-07 03:59:20.454228349 +0000
                 @@ -1 +1,2 @@
                 +This directory contains custom plugins for Ohai.
                 - change mode from '' to '0644'
    
           Recipe: ohai::default
    
           - re-run ohai and merge results into node attributes
           [2015-03-07T03:59:21+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
           [2015-03-07T03:59:21+00:00] WARN: Previous service[nginx]: /tmp/kitchen/cache/cookbooks/nginx/recipes/package.rb:46:in `from_file'
           [2015-03-07T03:59:21+00:00] WARN: Current  service[nginx]: /tmp/kitchen/cache/cookbooks/nginx/recipes/default.rb:24:in `from_file'
             Converging 19 resources
           Recipe: nginx::ohai_plugin
             * ohai[reload_nginx] action nothing (skipped due to action :nothing)
    
    
               - update content in file /etc/chef/ohai_plugins/nginx.rb from none to 9f7e82
               --- /etc/chef/ohai_plugins/nginx.rb  2015-03-07 03:59:21.682228392 +0000
               +++ /tmp/chef-rendered-template20150307-39-1uu40iq   2015-03-07 03:59:21.682228392 +0000
               @@ -1 +1,67 @@
               +#
               +# Author:: Jamie Winsor (<jamie@vialstudios.com>)
               +#
               +# Copyright 2012, Riot Games
               +#
               +# Licensed under the Apache License, Version 2.0 (the "License");
               +# you may not use this file except in compliance with the License.
               +# You may obtain a copy of the License at
               +#
               +#     http://www.apache.org/licenses/LICENSE-2.0
           +#
               +# Unless required by applicable law or agreed to in writing, software
               +# distributed under the License is distributed on an "AS IS" BASIS,
               +# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
               +# See the License for the specific language governing permissions and
               +# limitations under the License.
               +#
               +
               +provides "nginx"
               +provides "nginx/version"
               +provides "nginx/configure_arguments"
               +provides "nginx/prefix"
               +provides "nginx/conf_path"
               +
               +def parse_flags(flags)
               +  prefix = nil
               +  conf_path = nil
               +
               +  flags.each do |flag|
               +    case flag
               +    when /^--prefix=(.+)$/
               +      prefix = $1
               +    when /^--conf-path=(.+)$/
               +      conf_path = $1
               +    end
               +  end
               +
               +  [ prefix, conf_path ]
               +end
               +
               +nginx Mash.new unless nginx
               +nginx[:version]             = nil unless nginx[:version]
               +nginx[:configure_arguments] = Array.new unless nginx[:configure_arguments]
               +nginx[:prefix]              = nil unless nginx[:prefix]
               +nginx[:conf_path]           = nil unless nginx[:conf_path]
               +
               +status, stdout, stderr = run_command(:no_status_check => true, :command => "/usr/sbin/nginx -V")
               +
               +if status == 0
               +  stderr.split("\n").each do |line|
               +    case line
               +    when /^configure arguments:(.+)/
               +      # This could be better: I'm splitting on configure arguments which removes them and also
               +      # adds a blank string at index 0 of the array. This is why we drop index 0 and map to
               +      # add the '--' prefix back to the configure argument.
               +      nginx[:configure_arguments] = $1.split(/\s--/).drop(1).map { |ca| "--#{ca}" }
               +
               +      prefix, conf_path = parse_flags(nginx[:configure_arguments])
               +
               +      nginx[:prefix] = prefix
               +      nginx[:conf_path] = conf_path
               +    when /^nginx version: nginx\/(\d+\.\d+\.\d+)/
               +      nginx[:version] = $1
               +    end
               +  end
    
               - change mode from '' to '0755'
               - change owner from '' to 'root'
               - change group from '' to 'root'
           [2015-03-07T03:59:21+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.chef.io/ohai_custom.html
    
           - re-run ohai and merge results into node attributes
           Recipe: ohai::default
    
             * ohai[custom_plugins] action nothing (skipped due to action :nothing)
    
    
           - install version 1.4.6-1ubuntu3.2 of package nginx
           Recipe: nginx::ohai_plugin
           [2015-03-07T04:02:37+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.chef.io/ohai_custom.html
    
           - re-run ohai and merge results into node attributes
           Recipe: nginx::package
            (up to date)
           Recipe: nginx::commons_dir
             * directory[/etc/nginx] action create (up to date)
             * directory[/var/log/nginx] action create
    
             * directory[/var/run] action create (up to date)
             * directory[/etc/nginx/sites-available] action create (up to date)
             * directory[/etc/nginx/sites-enabled] action create (up to date)
             * directory[/etc/nginx/conf.d] action create (up to date)
           Recipe: nginx::commons_script
           * template[/usr/sbin/nxensite] action create
    
    
               --- /usr/sbin/nxensite       2015-03-07 04:02:37.422235233 +0000
               +++ /tmp/chef-rendered-template20150307-39-gq9bal    2015-03-07 04:02:37.422235233 +0000
               @@ -1 +1,39 @@
               +#!/bin/sh -e
           +
           +SYSCONFDIR='/etc/nginx'
           +
               +if [ -z $1 ]; then
               +        echo "Which site would you like to enable?"
               +        echo -n "Your choices are: "
           +        ls $SYSCONFDIR/sites-available/* | \
               +        sed -e "s,$SYSCONFDIR/sites-available/,,g" | xargs echo
           +        echo -n "Site name? "
               +        read SITENAME
           +else
    
               +fi
           +
           +if [ $SITENAME = "default" ]; then
               +        PRIORITY="000"
               +fi
               +
               +if [ -e $SYSCONFDIR/sites-enabled/$SITENAME -o \
               +     -e $SYSCONFDIR/sites-enabled/"$PRIORITY"-"$SITENAME" ]; then
    
               +        exit 0
           +fi
               +
               +if ! [ -e $SYSCONFDIR/sites-available/$SITENAME ]; then
               +        echo "This site does not exist!"
               +        exit 1
    
               +
               +if [ $SITENAME = "default" ]; then
               +        ln -sf $SYSCONFDIR/sites-available/$SITENAME \
               +               $SYSCONFDIR/sites-enabled/"$PRIORITY"-"$SITENAME"
               +else
               +        ln -sf $SYSCONFDIR/sites-available/$SITENAME $SYSCONFDIR/sites-enabled/$SITENAME
               +fi
               +
    
               - change mode from '' to '0755'
               - change owner from '' to 'root'
    
    
    
    
           --- /usr/sbin/nxdissite  2015-03-07 04:02:37.450235234 +0000
               +++ /tmp/chef-rendered-template20150307-39-1i7pk7a   2015-03-07 04:02:37.450235234 +0000
    
           +#!/bin/sh -e
               +
               +SYSCONFDIR='/etc/nginx'
               +
    
           +        echo "Which site would you like to disable?"
               +        echo -n "Your choices are: "
               +        ls $SYSCONFDIR/sites-enabled/* | \
    
               +        echo -n "Site name? "
               +        read SITENAME
               +else
               +        SITENAME=$1
               +fi
               +
    
               +        PRIORITY="000"
               +fi
               +
               +if ! [ -e $SYSCONFDIR/sites-enabled/$SITENAME -o \
               +       -e $SYSCONFDIR/sites-enabled/"$PRIORITY"-"$SITENAME" ]; then
               +        echo "This site is already disabled, or does not exist!"
               +        exit 1
               +fi
               +
               +if ! rm $SYSCONFDIR/sites-enabled/$SITENAME 2>/dev/null; then
               +        rm -f $SYSCONFDIR/sites-enabled/"$PRIORITY"-"$SITENAME"
               +fi
    
           - change mode from '' to '0755'
               - change owner from '' to 'root'
    
           Recipe: nginx::commons_conf
    
           - update content in file /etc/nginx/nginx.conf from 9492ca to 1c38f0
               --- /etc/nginx/nginx.conf    2014-03-04 22:25:36.000000000 +0000
              +++ /tmp/chef-rendered-template20150307-39-pfz2ac    2015-03-07 04:02:37.478235235 +0000
           @@ -1,96 +1,40 @@
            user www-data;
           -worker_processes 4;
           -pid /run/nginx.pid;
           +worker_processes  2;

           +error_log  /var/log/nginx/error.log;
           +pid        /var/run/nginx.pid;
           +
            events {
           -    worker_connections 768;
           -    # multi_accept on;
           +  worker_connections  1024;
            }

            http {

           -    ##
           -    # Basic Settings
           -    ##
           +  include       /etc/nginx/mime.types;
           +  default_type  application/octet-stream;

           -    sendfile on;
           -    tcp_nopush on;
           -    tcp_nodelay on;
           -    keepalive_timeout 65;
           -    types_hash_max_size 2048;
           -    # server_tokens off;
           +  access_log        /var/log/nginx/access.log;

           -    # server_names_hash_bucket_size 64;
           -    # server_name_in_redirect off;
           +  sendfile on;
           +  tcp_nopush on;
           +  tcp_nodelay on;

           -    include /etc/nginx/mime.types;
           -    default_type application/octet-stream;
           +  keepalive_timeout  65;

           -    ##
           -    # Logging Settings
           -    ##
           +  gzip  on;
           +  gzip_http_version 1.0;
           +  gzip_comp_level 2;
           +  gzip_proxied any;
           +  gzip_vary off;
           +  gzip_types text/plain text/css application/x-javascript text/xml application/xml application/rss+xml application/atom+xml text/javascript application/javascript application/json text/mathml;
           +  gzip_min_length  1000;
           +  gzip_disable     "MSIE [1-6]\.";

           -    access_log /var/log/nginx/access.log;
           -    error_log /var/log/nginx/error.log;
           +  server_names_hash_bucket_size 64;
           +  types_hash_max_size 2048;
           +  types_hash_bucket_size 64;

           -    ##
           -    # Gzip Settings
           -    ##
           -
           -    gzip on;
           -    gzip_disable "msie6";

           -    # gzip_vary on;
           -    # gzip_proxied any;
           -    # gzip_comp_level 6;
           -    # gzip_buffers 16 8k;
           -    # gzip_http_version 1.1;
           -    # gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
           -
           -    ##
           -    # nginx-naxsi config
           -    ##
           -    # Uncomment it if you installed nginx-naxsi
           -    ##
           -
           -    #include /etc/nginx/naxsi_core.rules;
           -
           -    ##
           -    # nginx-passenger config
           -    ##
           -    # Uncomment it if you installed nginx-passenger
           -    ##
           -
           -    #passenger_root /usr;
           -    #passenger_ruby /usr/bin/ruby;
           -
           -    ##
           -    # Virtual Host Configs
           -    ##
           -
           -    include /etc/nginx/conf.d/*.conf;
           -    include /etc/nginx/sites-enabled/*;
           +  include /etc/nginx/conf.d/*.conf;
           +  include /etc/nginx/sites-enabled/*;
            }
           -
           -
           -#mail {
           -#   # See sample authentication script at:
           -#   # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
           -#
           -#   # auth_http localhost/auth.php;
           -#   # pop3_capabilities "TOP" "USER";
           -#   # imap_capabilities "IMAP4rev1" "UIDPLUS";
           -#
           -#   server {
           -#           listen     localhost:110;
           -#           protocol   pop3;
           -#           proxy      on;
           -#   }
       -#
           -#   server {
           -#           listen     localhost:143;
           -#           protocol   imap;
           -#           proxy      on;
           -#   }
           -#}

           - update content in file /etc/nginx/sites-available/default from cda500 to bb2ac0
           --- /etc/nginx/sites-available/default       2014-03-04 22:25:36.000000000 +0000
           +++ /tmp/chef-rendered-template20150307-39-y18xdh    2015-03-07 04:02:37.546235238 +0000
           @@ -1,113 +1,12 @@
           -# You may add here your
           -# server {
           -#   ...
           -# }
           -# statements for each of your virtual hosts to this file
           -
           -##
           -# You should look at the following URL's in order to grasp a solid understanding
           -# of Nginx configuration files in order to fully unleash the power of Nginx.
           -# http://wiki.nginx.org/Pitfalls
           -# http://wiki.nginx.org/QuickStart
           -# http://wiki.nginx.org/Configuration
           -#
           -# Generally, you will want to move this file somewhere, and start with a clean
           -# file but keep this around for reference. Or just disable in sites-enabled.
           -#
           -# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
           -##
           -
            server {
           -    listen 80 default_server;
           -    listen [::]:80 default_server ipv6only=on;
           +  listen   80;
           +  server_name  c81cea74d8c1;

           -    root /usr/share/nginx/html;
           -    index index.html index.htm;
           +  access_log  /var/log/nginx/localhost.access.log;

           -    # Make site accessible from http://localhost/
           -    server_name localhost;
           -
           -    location / {
           -            # First attempt to serve request as file, then
           -            # as directory, then fall back to displaying a 404.
           -            try_files $uri $uri/ =404;
           -            # Uncomment to enable naxsi on this location
           -            # include /etc/nginx/naxsi.rules
           -    }
           -
           -    # Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
           -    #location /RequestDenied {
           -    #       proxy_pass http://127.0.0.1:8080;
           -    #}
           -
           -    #error_page 404 /404.html;
           -
           -    # redirect server error pages to the static page /50x.html
           -    #
       -        #error_page 500 502 503 504 /50x.html;
           -    #location = /50x.html {
           -    #       root /usr/share/nginx/html;
           -    #}
           -
           -    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
           -    #
           -    #location ~ \.php$ {
           -    #       fastcgi_split_path_info ^(.+\.php)(/.+)$;
           -    #       # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
           -    #
           -    #       # With php5-cgi alone:
           -    #       fastcgi_pass 127.0.0.1:9000;
           -    #       # With php5-fpm:
           -    #       fastcgi_pass unix:/var/run/php5-fpm.sock;
           -    #       fastcgi_index index.php;
           -    #       include fastcgi_params;
           -    #}
           -
           -    # deny access to .htaccess files, if Apache's document root
           -    # concurs with nginx's one
           -    #
           -    #location ~ /\.ht {
           -    #       deny all;
           -    #}
           +  location / {
           +    root   /usr/share/nginx/html;
           +    index  index.html index.htm;
           +  }
            }
           -
           -
           -# another virtual host using mix of IP-, name-, and port-based configuration
           -#
           -#server {
           -#   listen 8000;
           -#   listen somename:8080;
           -#   server_name somename alias another.alias;
           -#   root html;
           -#   index index.html index.htm;
           -#
           -#   location / {
           -#           try_files $uri $uri/ =404;
           -#   }
           -#}
           -
           -
           -# HTTPS server
           -#
           -#server {
           -#   listen 443;
           -#   server_name localhost;
           -#

           -#   index index.html index.htm;
           -#
           -#   ssl on;
           -#   ssl_certificate cert.pem;
           -#   ssl_certificate_key cert.key;
           -#
           -#   ssl_session_timeout 5m;
           -#
           -#   ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
           -#   ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
           -#   ssl_prefer_server_ciphers on;
           -#
           -#   location / {
           -#           try_files $uri $uri/ =404;
           -#   }
           -#}
         * execute[nxensite default] action run (skipped due to not_if)
       Recipe: nginx::default
       * service[nginx] action start
           - start service service[nginx]
       Recipe: myweb::default

           - update content in file /usr/share/nginx/html/index.html from 38ffd4 to 3a5393
           --- /usr/share/nginx/html/index.html 2014-03-04 11:46:45.000000000 +0000
       2015-03-07 04:02:37.754235245 +0000
           @@ -1,26 +1,2 @@
           -<!DOCTYPE html>
           -<html>
           -<head>
           -<title>Welcome to nginx!</title>
           -<style>
           -    body {
           -        width: 35em;

           -        font-family: Tahoma, Verdana, Arial, sans-serif;
           -    }
           -</style>
           -</head>
           -<body>
           -<h1>Welcome to nginx!</h1>
           -<p>If you see this page, the nginx web server is successfully installed and
           -working. Further configuration is required.</p>
           -
           -<p>For online documentation and support please refer to
           -<a href="http://nginx.org/">nginx.org</a>.<br/>
           -Commercial support is available at
           -<a href="http://nginx.com/">nginx.com</a>.</p>
           -
           -<p><em>Thank you for using nginx.</em></p>
           -</body>
           -</html>

           - change owner from 'root' to 'www-data'

       Recipe: nginx::default

           - reload service service[nginx]

       Running handlers:
       Running handlers complete
       Chef Client finished, 15/21 resources updated in 205.288077762 seconds
       Finished converging <default-ubuntu-1404> (3m27.85s).
    -----> Setting up <default-ubuntu-1404>...
    Fetching: thor-0.19.0.gem (100%)
           Successfully installed thor-0.19.0
    Fetching: busser-0.6.2.gem (100%)
           Successfully installed busser-0.6.2
           2 gems installed
    -----> Setting up Busser
           Creating BUSSER_ROOT in /tmp/busser
           Creating busser binstub
           Plugin serverspec installed (version 0.5.3)
    -----> Running postinstall for serverspec plugin
           Finished setting up <default-ubuntu-1404> (0m19.41s).
    -----> Verifying <default-ubuntu-1404>...
           Suite path directory /tmp/busser/suites does not exist, skipping.
           Uploading /tmp/busser/suites/serverspec/default_spec.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0664)
           Uploading /tmp/busser/suites/serverspec/default_spec.rb~ (mode=0664)
    -----> Running serverspec test suite
    -----> Installing Serverspec..
    Fetching: net-ssh-2.9.2.gem (100%)
    Fetching: net-scp-1.2.1.gem (100%)
    Fetching: specinfra-2.18.2.gem (100%)
    Fetching: multi_json-1.11.0.gem (100%)
    Fetching: diff-lcs-1.2.5.gem (100%)
    Fetching: rspec-support-3.2.2.gem (100%)
    Fetching: rspec-expectations-3.2.0.gem (100%)
    Fetching: rspec-core-3.2.1.gem (100%)
    Fetching: rspec-its-1.2.0.gem (100%)
    Fetching: rspec-mocks-3.2.1.gem (100%)
    Fetching: rspec-3.2.0.gem (100%)
    Fetching: serverspec-2.10.0.gem (100%)
    -----> serverspec installed (version 2.10.0)
           /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -I/tmp/busser/gems/gems/rspec-support-3.2.2/lib:/tmp/busser/gems/gems/rspec-core-3.2.1/lib /opt/chef/embedded/bin/rspec --pattern /tmp/busser/suites/serverspec/\*\*/\*_spec.rb --color --format documentation --default-path /tmp/busser/suites/serverspec
    
           myweb::default
    
               should be enabled
               should be running
    
               should be listening
    
           Finished in 0.34437 seconds (files took 0.41628 seconds to load)
           3 examples, 0 failures
    
           Finished verifying <default-ubuntu-1404> (0m23.51s).
           Finished testing <default-ubuntu-1404> (4m12.15s).
    -----> Kitchen is finished. (4m12.52s)
    vagrant@ubuntu-trusty64-ja:~/myweb$ curl localhost:8100
    Hello default-ubuntu-1404

```