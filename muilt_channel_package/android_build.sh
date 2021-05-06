
#!/bin/sh
env
set -e


echo "---++++++===   开始打包,获取依赖   ===++++++---"
/Users/waitwalker/fvm/versions/2.0.1/bin/flutter packages get
#flutter2 packages get
echo "---++++++===   获取依赖完成   ===++++++---"
/Users/waitwalker/fvm/versions/2.0.1/bin/flutter clean
#flutter2 clean
echo "---++++++===   清空缓存完成   ===++++++---"
/Users/waitwalker/fvm/versions/2.0.1/bin/flutter build apk --release --dart-define=APP_ENVIRONMENT=OK --dart-define=OTHER=NO
#flutter2 build apk --release --dart-define=APP_ENVIRONMENT=OK --dart-define=OTHER=NO
echo "---++++++===   打包完成   ===++++++---"

# 后续操作可以继续操作
# 获取当前时间 精确到分钟
currentTime=$(date +%y%m%d%H%M)
echo "---++++++===   当前时间   ===++++++---"
echo $currentTime
apkName=$currentTime-release.apk
echo "---++++++===   apk名称   ===++++++---"
echo $apkName

# 移动&重命名apk
mv build/app/outputs/flutter-apk/app-release.apk apps/$apkName
i=1;
while((i<60));
  do
    echo "---++++++===   正在拷贝文件,请稍等   ===++++++--- "$((i));
    sleep 1
    if [ ! -f apks/$apkName ];
      then
      echo "---++++++===   文件不存在   ===++++++---"
    else
      echo "---++++++===   文件存在   ===++++++---"
      i=60;
    fi
    i=$((i))+1;
done
cd apps
echo "---++++++===   文件拷贝完成   ===++++++---"
echo "---++++++===   目前目录中存在的文件   ===++++++---"
ls


