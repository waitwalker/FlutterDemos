
env

echo "---++++++===   开始打包,获取依赖   ===++++++---"
/Users/waitwalker/fvm/versions/2.0.1/bin/flutter packages get
echo "---++++++===   获取依赖完成   ===++++++---"

/Users/waitwalker/fvm/versions/2.0.1/bin/flutter clean
echo "---++++++===   清空缓存完成   ===++++++---"

/Users/waitwalker/fvm/versions/2.0.1/bin/flutter build ios --release --dart-define=APP_ENVIRONMENT=Production --dart-define=OTHER=MyTest

JOB_NAME=${JOB_NAME-online-wangxiao-ios}
echo "---++++++===   JOB_NAME   ===++++++---"$JOB_NAME
WORKSPACE=${WORKSPACE-.}
echo "---++++++===   工作区WORKSPACE   ===++++++---"$WORKSPACE

## 版本号
APP_VERSION=$(cat ios/Runner.xcodeproj/project.pbxproj | grep MARKETING_VERSION | cut -d' ' -f3 | cut -d';' -f 1 | uniq)
echo "版本号"
echo $APP_VERSION

BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c 'Print CFBundleVersion' ios/Runner/Info.plist)
echo "---++++++===   BUILD_NUMBER   ===++++++---"$BUILD_NUMBER

APP_NAME=WangXiao
APP_SCHEME=Runner
WORKSPACE_NAME=Runner
BUILT_IPA_NAME=muilt_channel_package.ipa

# 当前时间 精确到秒 210414115030
export JENKINS_TIME=$(date +%y%m%d%H%M)

# ipa 名称 由名字+时间拼接
IPA_NAME=$APP_NAME-$JENKINS_TIME.ipa

# archive 目录
EXPORT_IPA_PATH=./build/ios/$JOB_NAME/$BUILD_NUMBER

# 判断路径是否存在 不存在创建
mkdir -p $EXPORT_IPA_PATH

# xcworkspace 名称
XCWORKSPACE_NAME=$WORKSPACE/ios/$WORKSPACE_NAME.xcworkspace

# archive 存储路径
ARCHIVE_PATH=$EXPORT_IPA_PATH/$APP_NAME.xcarchive

# ipa 导出路径
EXPORT_IPA_PATH=./build/ios/$JOB_NAME/$BUILD_NUMBER

echo "App Store 签名"
echo $BUILD_TYPE
ExportOptionsPlistPath=/Users/waitwalker/Desktop/工作/证书/MultiExportOptions.plist

echo "============== 开始编译 准备导出 archive =================="
xcodebuild archive -workspace $XCWORKSPACE_NAME \
    -scheme $APP_SCHEME \
    -configuration Release \
    -archivePath $ARCHIVE_PATH \
    -allowProvisioningUpdates
echo "============== 导出 archive 成功 =================="

# ipa
echo "============== 开始编译 准备导出 ipa =================="
xcodebuild -exportArchive -archivePath $ARCHIVE_PATH \
    -exportPath $EXPORT_IPA_PATH \
    -exportOptionsPlist $ExportOptionsPlistPath \
    -allowProvisioningUpdates
echo "============== 导出 ipa成功 =================="

echo "ipa的存储路径是:"$EXPORT_IPA_PATH/$BUILT_IPA_NAME

echo "准备移动文件:"$EXPORT_IPA_PATH/$BUILT_IPA_NAME
mv $EXPORT_IPA_PATH/$BUILT_IPA_NAME apps/$JENKINS_TIME-$BUILD_NUMBER-ios.ipa

i=1;
while((i<60));
  do
    echo "---++++++===   正在拷贝文件,请稍等   ===++++++--- "$((i));
    sleep 1
    if [ ! -f apps/$JENKINS_TIME-$BUILD_NUMBER-ios.ipa ];
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