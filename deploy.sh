#!/usr/bin/env bash
# 编译+部署order站点

# 需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径

# 输入你的环境上tomcat的全路径
# export TOMCAT_APP_PATH=tomcat在部署机器上的路径

### base 函数
killTomcat()
{
    pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      kill -9 $pid
    fi
}
# 进入order工程根目录
cd $PROJ_PATH/order
# 执行maven命令
mvn clean package

# 停tomcat
killTomcat

# 删除ROOT目录
#rm -rf $TOMCAT_APP_PATH/webapps/ROOT
# 删除Root.war文件
rm -f $TOMCAT_APP_PATH/webapps/ROOT.war
# 删除order.war文件
rm -f $TOMCAT_APP_PATH/webapps/order.war

# 复制新的工程
cp $PROJ_PATH/order/target/order.war $TOMCAT_APP_PATH/webapps/

# 进入到tomcat的webapps目录
cd $TOMCAT_APP_PATH/webapps/
# 重命名order.war为ROOT.war
#mv order.war ROOT.war

# 加载tomcat路径
cd $TOMCAT_APP_PATH/
# 启动Tomcat
sh bin/startup.sh



