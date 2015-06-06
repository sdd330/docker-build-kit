# Docker Maven 项目助手 (Maven, Docker Compose, Alpine Linux)
==================

## 主要功能 ##

面向开发者的镜像

提供了Maven的项目管理和生命周期管理功能，结合Docker Compose解决同一个项目同时在多个目标环境下的软件生命周期管理问题（编译/测试/发布/启动）

使用者需要具备一定的Maven基础知识

## 使用方法 ##

### 运行Docker Maven项目助手 ###
```shell
docker run --rm -v /Users/myuser/Documents/workspace:/workspace -w /workspace -v /var/run/docker.sock:/var/run/docker.sock -it index.alauda.cn/yangleijun/docker-maven-kit bash
```

说明：必须将主机的某个目录（比如/Users/admin/Documents/workspace
 ）mount到容器当中，否则创建的项目文件将会丢失

### 创建一个Maven项目Hello World ###

在容器中执行命令
```shell
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

进入项目所在的目录
```shell
cd my-app
```

修改pom.xml文件并添加插件配置
```xml
<build>
	<plugins>
		<plugin>
			<groupId>com.github.sdd330</groupId>
			<artifactId>dockerbuild-maven-plugin</artifactId>
			<version>1.1-SNAPSHOT</version>
			<configuration>
				<mountDirectory>/Users/myuser/Documents/workspace/hello</mountDirectory>
				<containers>
					<container>
						<name>oraclejdk</name>
						<image>index.alauda.cn/yangleijun/maven-oraclejdk</image>
						<sourceIncludes>
							<sourceInclude>**/*.java</sourceInclude>
						</sourceIncludes>
						<testSourceIncludes>
							<testSourceInclude>**/*.java</testSourceInclude>
						</testSourceIncludes>
					</container>
					<container>
						<name>openjdk</name>
						<image>index.alauda.cn/yangleijun/maven-oraclejdk</image>
						<sourceIncludes>
							<sourceInclude>**/*.java</sourceInclude>
						</sourceIncludes>
						<testSourceIncludes>
							<testSourceInclude>**/*.java</testSourceInclude>
						</testSourceIncludes>
					</container>
				</containers>
			</configuration>
			<executions>
				<execution>
					<id>dockerBuildInstall</id>
					<goals>
						<goal>install</goal>
					</goals>
					<phase>install</phase>
				</execution>
				<execution>
					<id>dockerBuildClean</id>
					<goals>
						<goal>clean</goal>
					</goals>
					<phase>clean</phase>
				</execution>
			</executions>
		</plugin>
	</plugins>
</build>
```

注意：mountDirectory 必须设置为主机上mount的目录加项目名称

创建一个settings.xml配置文件，可以通过该配置文件指定Maven仓库（比如artifactory的地址）
```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd"
          xmlns="http://maven.apache.org/SETTINGS/1.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
</settings>
```

执行mvn命令构建项目
```shell
mvn install
```

编译结束后生成的文件在target目录下，可以通过如下命令测试你的Hello World程序
```shell
java -cp target/openjdk/target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```
```shell
java -cp target/oraclejdk/target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```

其它项目生命周期中的步骤同样适用，比如：
mvn compile测试项目
mvn test测试项目
mvn clean清理（编译所使用的容器会被删除）
