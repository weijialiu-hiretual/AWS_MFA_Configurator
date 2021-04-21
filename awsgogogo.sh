# Fu*k AWS Config

# Author by Veeja.Liu(@Jobseer)
# 作者：刘伟佳
# Email: weijialiu@hiretual.com
# Time 2021.04.20

# Read config
durationSeconds=`sed '/^duration-seconds=/!d;s/.*=//' config`
serialNumber=`sed '/^serial-number=/!d;s/.*=//' config`
credentialsPath=`sed '/^credentials-path=/!d;s/.*=//' config`

cp $credentialsPath $credentialsPath.backup
echo "\033[32m"
echo "$credentialsPath file has been backed up!"

echo
echo '==================== Your configuration: ===================='
echo duration-seconds = $durationSeconds
echo serial-number = $serialNumber
echo credentials-path = $credentialsPath
echo '============================================================='
echo 

# input token-code
echo "\033[31m"
echo "(The most fu**king tedious step) Please input token-code:"
read -p "Fu*king write here: " token
echo "\033[32m"
echo

# print request command
echo "\033[32m"
echo '======================== Your Request ======================='
echo  Your request:
echo $ aws sts get-session-token --duration-seconds $durationSeconds --serial-number $serialNumber --token-code $token
echo '============================================================='
echo 

result=$(aws sts get-session-token --duration-seconds $durationSeconds --serial-number $serialNumber --token-code $token)

#result='{ "Credentials": { "AccessKeyId": "xxx", "SecretAccessKey": "xxx", "SessionToken": "xxxx", "Expiration": "2021-04-21T22:06:38Z" } }'
echo result=$result
echo
right="AccessKeyId"
flag=$(echo $result | grep "${right}")
if [[  "$result" == "" ]]
then
    echo "\033[31m"
    echo 'bad!!!'
    echo 'Wrong!!! Something bad.'
else
    echo 'good!'
    result_AccessKeyId=`echo $result | cut -d\" -f6 `
    result_SecretAccessKey=`echo $result | cut -d\" -f10 `
    result_SessionToken=`echo $result | cut -d\" -f14 `

    echo result_AccessKeyId = $result_AccessKeyId
    echo result_SecretAccessKey = $result_SecretAccessKey
    echo result_SessionToken = $result_SessionToken

    # modify file
    echo
    echo 'Delete old configuration...'

    line=$(sed -n -e '/mfa/=' $credentialsPath)
    # line=`grep -n "[mfa]" $credentialsPath | cut -d ":" -f 1`
    # echo $line
    lastLine=$[line+3]
    # echo $lastLine
    echo

    echo 'Add new configuration...'
    sed -i "" "$line,$lastLine d" $credentialsPath

    # add line
    echo '[mfa]' >> $credentialsPath
    echo 'aws_access_key_id =' $result_AccessKeyId >> $credentialsPath
    echo 'aws_secret_access_key =' $result_SecretAccessKey >> $credentialsPath
    echo 'aws_session_token =' $result_SessionToken >> $credentialsPath
    echo 

    echo 'Dnoe !!! You can really dance!'
fi