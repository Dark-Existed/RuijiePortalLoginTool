#!/bin/bash
# set -ex

#If received parameters is less than 2, print usage
if [ "$#" -lt "2" ]; then
  echo "Usage: ./ruijie_general.sh username password"
  echo "Example: ./ruijie_general.sh 200327001 123456"
  exit 1
fi

#Exit the script when is already online, use www.google.cn/generate_204 to check the online status
captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "$captiveReturnCode" = "204" ]; then
  echo "You are already online!"
  exit 0
fi

#If not online, begin Ruijie Auth

#Get Ruijie login page URL
loginPageURL=`curl -s "http://www.baidu.com" | awk -F \' '{print $2}'`

#Structure loginURL
loginURL=`echo $loginPageURL | awk -F \? '{print $1}'`
loginURL=${loginURL:0:-10}
loginURL="${loginURL}/InterFace.do?method=login"

#Structure quertString
queryString=`echo $loginPageURL | awk -F \? '{print $2}'`
queryString="${queryString//=/%253D}"
queryString="${queryString//&/%2526}"


if [ -n "$loginURL" ]; then
  curl "$loginURL" \
  -X POST \
  -H "Connection: keep-alive"\
  -H "Content-Length: 633" \
  -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36" \
  -H "Accept: */*" \
  -H "Accept-Language: zh-CN,zh;q=0.9" \
  -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
  -H "Referer: $loginPageURL" \
  --cookie "EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_OPERATORPWD=; " \
  --data-raw "userId=$1&password=$2&service=&queryString=$queryString&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false"
fi