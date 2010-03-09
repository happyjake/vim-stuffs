from ftplib import FTP

cmd = "QUERY 0 20 0 0 0 jake"

ftp = FTP()
ftp.connect("127.0.0.1","27017")
ftp.login("jake","jake1234")
#ftp.retrlines()
#ftp.transfercmd(cmd)
ftp.putcmd(cmd)
res = ftp.getline()
rep = res.split(" ")
fcount = int(rep[2])
for i in range(fcount):print ftp.getline()
