# 配置环境
https://heuqqdmbyk.feishu.cn/wiki/ZRSFwACsRiBD2NkV7bmcrJhInme
- 环境变量
- 管理员终端
- mysqld --initialize-insecure
- mysqld -install
- net start mysql 启动服务
- mysqladmin -u root password 1234
- net stop mysql终止服务
- mysqld -remove mysql 卸载


# 启动
- 登录 mysql -h 127.0.0.1 -P3306 -uroot -pasd456
-h ip
-P(大写) 端口 3306默认mysql端口
-u root用户
-p 密码asd456

# sql语句
- 分类
DDL DML DQL DCL
定义 操作 查询 访问权限

# 数据库结构
用户->多个数据库->每个数据库中有若干张表

# IDE配置
数据库服务启动->ip和端口链接


## DDL
### 数据库
- show databases;
- select database();
- use 数据库名;
- create database [if not exists] 数据库名 [default charset utf8mb4];
- drop database [if exists] 数据库名;




