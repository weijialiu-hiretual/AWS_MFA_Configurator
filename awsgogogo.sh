# Fu*k AWS Config

# Author by Veeja.Liu(@Jobseer)
# 作者：刘伟佳
# Email: weijialiu@hiretual.com
# Time 2021.04.20

# Read config
durationSeconds=`sed '/^duration-seconds=/!d;s/.*=//' /home/weijialiu/code/AWS_MFA_Configurator/config`
serialNumber=`sed '/^serial-number=/!d;s/.*=//' /home/weijialiu/code/AWS_MFA_Configurator/config`
credentialsPath=$(sed '/^credentials-path=/!d;s/.*=//' /home/weijialiu/code/AWS_MFA_Configurator/config)

cp $credentialsPath $credentialsPath.backup
sudo echo "\033[32m"
echo "$credentialsPath file has been backed up!"

echo
echo '==================== Your configuration: ===================='
echo duration-seconds = $durationSeconds
echo serial-number = $serialNumber
echo credentials-path = $credentialsPath
echo '============================================================='
echo 

# input token-code
sudo echo "\033[31m"
echo "(The most fu**king tedious step) Please input token-code:"
read -p "Fu*king write here: " token
sudo echo "\033[32m"
echo

# print request command
sudo echo "\033[32m"
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

    echo result_AccessKeyId=$result_AccessKeyId
    echo result_SecretAccessKey=$result_SecretAccessKey
    echo result_SessionToken=$result_SessionToken

    # modify file
    echo
    echo 'Prepare to delete old configuration...'

    line=$(sed -n -e '/mfa/=' $credentialsPath)
    # line=`grep -n "[mfa]" $credentialsPath | cut -d ":" -f 1`
    
    if [ $line ]
    then
        echo 'find the old configuration begin line:'$line
        lastLine=$[line+3]
        echo 'the last line:'$lastLine
        echo
        sed -i "$line,$lastLine d" $credentialsPath
    else
        echo 'Do not find the old configuration'
    fi
    echo 'Add new configuration...'
    
    # add line
    echo '[mfa]' >> $credentialsPath
    echo 'aws_access_key_id='$result_AccessKeyId >> $credentialsPath
    echo 'aws_secret_access_key='$result_SecretAccessKey >> $credentialsPath
    echo 'aws_session_token='$result_SessionToken >> $credentialsPath
    echo 

    echo 'Dnoe !!! You can really dance!'
fi
