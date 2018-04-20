#!/bin/sh

#
# Generated 2/8/14 10:06 AM
# Start of user configurable variables
#
LANG=C
export LANG

# SSO username and password
SSO_USERNAME=marius.chisa@atos.net
SSO_PASSWORD=0p3n.S0urc3



# Path to wget command
WGET=/usr/bin/wget

# Location of cookie file
COOKIE_FILE=/tmp/$$.cookies

# Log directory and file
LOGDIR=/tmp
LOGFILE=$LOGDIR/wgetlog-`date +%m-%d-%y-%H:%M`.log

# Output directory and file
OUTPUT_DIR=/sapcd/sapgit

#
# End of user configurable variable
#

if [ "$SSO_PASSWORD " = " " ]
then
 echo "Please edit script and set SSO_PASSWORD"
 exit
fi

# Contact updates site so that we can get SSO Params for logging in
SSO_RESPONSE=`$WGET --user-agent="Mozilla/5.0" https://updates.oracle.com/Orion/Services/download 2>&1|grep Location`

# Extract request parameters for SSO
SSO_TOKEN=`echo $SSO_RESPONSE| cut -d '=' -f 2|cut -d ' ' -f 1`
SSO_SERVER=`echo $SSO_RESPONSE| cut -d ' ' -f 2|cut -d 'p' -f 1,2`
SSO_AUTH_URL=sso/auth
AUTH_DATA="ssousername=$SSO_USERNAME&password=$SSO_PASSWORD&site2pstoretoken=$SSO_TOKEN"

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL. Remove the --secure-protocol option
# if wget was not compiled with OpenSSL
# Depending on the preference, the other options are --secure-protocol= auto|SSLv2|SSLv3|TLSv1
$WGET --user-agent="Mozilla/5.0" --secure-protocol=auto --post-data $AUTH_DATA --save-cookies=$COOKIE_FILE --keep-session-cookies $SSO_SERVER$SSO_AUTH_URL -O sso.out >> $LOGFILE 2>&1

rm -f sso.out

$WGET  --user-agent="Mozilla/5.0"  --load-cookies=$COOKIE_FILE --save-cookies=$COOKIE_FILE --keep-session-cookies "https://updates.oracle.com/Orion/Services/download/p6880880_121010_Linux-x86-64.zip?file_id=99872177&aru=22116489&patch_file=p6880880_121010_Linux-x86-64.zip" -O $OUTPUT_DIR/p6880880_121010_Linux-x86-64.zip  >> $LOGFILE 2>&1 

# Cleanup
rm -f $COOKIE_FILE
rm -f download 

unzip -t $OUTPUT_DIR/p6880880_121010_Linux-x86-64.zip >> /dev/null 2>&1
if [ $? -ne 0 ]
then
        echo "opatch - Download error"
        exit 1
else
        echo "opatch - Download successful"
        exit 0
fi
