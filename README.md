# AWS_MFA_Configurator

## 简介：Introduction

只需输入你的mfa，剩余的交给它。

Just type your MFA and give it the rest.

## 配置文件：Configuration File

config 文件为配置文件。

The config file is the configuration file.

```shell
duration-seconds=129600
serial-number=arn:aws:iam::xxxxxxxxxxx:xxx/xxx
credentials-path=/Users/xxxxxx/.aws/credentials
```

`credentials-path`是credentials文件的绝对路径。

`credentials-path`is the absolute path of the credentials file.

## 使用步骤：Use steps

执行命令文件即可：

Execute the command file to:

```shell
$ sh ./awsgogogo.sh
```

```shell
/Users/liuweijia/.aws/credentials file has been backed up!

==================== Your configuration: ====================
duration-seconds = 129600
serial-number = arn:aws:iam::xxx:xxx/xxx
credentials-path = /Users/xxx/.aws/credentials
=============================================================


(The most fu**king tedious step) Please input token-code:
Fu*king write here: 
```

在上面输入你正确的的mfa即可完成配置。

Input your correct MFA above to complete the configuration.



如果输入错误，会得到：

If the input is wrong, you will get:

```shell
An error occurred (AccessDenied) when calling the GetSessionToken operation: MultiFactorAuthentication failed with invalid MFA one time pass code. 
result=


bad!!!
Wrong!!! Something bad.
```



## 注意事项：matters needing attention

使用过程中，credentials文件会自动备份，在原目录下生成一个`credentials.backup`的文件。

During use, the credentials file will be automatically backed up and a `credentials.backup` file will be generated in the original directory.