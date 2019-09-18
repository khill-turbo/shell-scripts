-web.external-url=http://myserver

./alertmanager -notification.smtp.smarthost localhost:25 -config.file alertmanager.conf
./alertmanager -notification.smtp.smarthost 127.0.0.1:25 -config.file alertmanager.conf

You'll generally want an alert on up == 0 and depending on your setup possibly also absent(up).

tar cvf /tmp/TAR-FILENAME.tar DIR-NAME

If you just want to build PRs, set refspec to 
+refs/pull/${ghprbPullId}/*:refs/remotes/origin/pr/${ghprbPullId}/*

# gives cpu usage
cat /proc/cpuinfo

#gives memory usage
cat /proc/meminfo

https://linuxconfig.org/learning-linux-commands-sed

find /var/lib/jenkins -maxdepth 1 -type f -printf "%f\n"
find /var/lib/jenkins -maxdepth 1 -type f -name log*.txt -printf "%f\n"
find . -maxdepth 1 -type f -name log*.txt -printf "%f\n"
find . -maxdepth 1 -type f -name *.jsbundle -printf "%f\n"

TESTER=$(find . -maxdepth 1 -type f -name .*ogin -printf "%f\n")
sed "s/og/ap/I" tester.txt > new_tester.txt
TESTER_B=$(cat newest_tester.txt)
echo $TESTER_B
mv $TESTER $TESTER_B

TESTER=$(find . -maxdepth 1 -type f -name .*ogin -printf "%f\n")
echo $TESTER
TESTER2=$(echo $TESTER | sed "s/og/ap/I")
echo $TESTER2

find /Users/build/jenkins/workspace/DIR-NAME -maxdepth 14 -type f -name *.*bundle*

find . 2>/dev/null -name “pom.xml”

jenkins@SERVER-NAME:/$ find . 2>/dev/null -name “alertmanager”
./usr/include/python2.7/Python.h

#/usr/bin/python3.4
#/usr/local/bin/virtualenv
#/usr/bin/python2.7

grep --include={config.xml} -rnw '/var/lib/jenkins/' -e "REPO-NAME.git"
find . -name 'config.xml' -exec grep -i 'REPO-NAME.git' {} \; -print

cd /var/lib/jenkins/jobs/
find . -name 'config.xml' -exec grep -i 'jenkins.plugins.nodejs.tools.NpmPackagesBuildWrapper' {} \; -print

which chromedriver
chromedriver --version

which google-chrome
google-chrome --version

tail -f /var/log/jenkins/jenkins.log
tail -f /var/log/system.log
tail -f /var/log/apache2/logs/access.log

du -hs /path/to/dir
# to view nodes used up run
df -i 
df -h
shows file usage for all dirs in this dir ------->  du -h /var/lib/jenkins/builds -d 1

df -h
500G  177G  324G  36% /var/lib/jenkins/builds

jenkins@SERVER-NAME:~$ du -hs /var/lib/jenkins/
671G-->583G-->580G    /var/lib/jenkins/

find . 2>/dev/null -name "main.js"

# search all DIR-NAME dirs for the file name *.log
find */DIR-NAME/* 2>/dev/null -name "*.log"

find */DIR-NAME/* 2>/dev/null -name "*.log"
builds/DIR-NAME/1/archive/FILE-NAME.log
workspaces/DIR-NAME/FILE-NAME.log

grep "insufficient memory" FILE-NAME-*-*.log

grep "insufficient memory" FILE-NAME-23-.log

ps axuwww | grep chrome | grep -v grep jenkins

log into server and type in "uptime" to see how long server has been up

ps axuwww | grep chrome | grep -v grep jenkins
ps -aefw | grep chrome
ps -aefw | grep jenkins
