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



# 数据库结构
用户->多个数据库->每个数据库中有若干张表

# IDE配置
数据库服务启动->ip和端口链接

# sql语句
- 分类
DDL DML DQL DCL
定义 操作 查询 访问权限
## DDL
### 数据库
- show databases;
- select database();
- use 数据库名;
- create database [if not exists] 数据库名 [default charset utf8mb4];
- drop database [if exists] 数据库名;

### 表
```sql
create table user(
    --主键 自增
    id int primary key auto_increment comment 'ID,唯一标识',
    --非空唯一
    username varchar(50) not null unique comment '用户名',
    --非空
    name varchar(10) not null comment '姓名',
    age int comment '年龄',
    --默认值
    gender char(1) default '男' comment '性别'
) comment '用户信息表';
```
**字段是行向量**

## 数据类型
- tinyint : 1 byte
- smallint: 2byte
- int: 4byte
- bigint:8byte
- float: 4byte
- double : 8byte

unsigned 无符号 varchar(10) char(10)变长字符串和定长字符串

- date datetime year time


### 
```sql
create table emp(
    id int unsigned auto_increment primary key comment '主键id',
    create_time datetime comment '创建时间',
    update_time datetime comment '更新时间',
    username varchar(20) not null unique comment '用户名',
    name varchar(10) not null comment  '姓名',
    gender tinyint unsigned not null comment '性别,1nan,2nv',
    phone_number char(11) not null unique comment '手机号',
    job tinyint unsigned unique comment '职位,1,2,3,4,5',
    salary int unsigned comment '薪资',
    entry_date date comment '入职日期',
    image varchar(255) comment '图片地址',
    password varchar(32) default '123456' comment '密码,加密算法md5最后生成32位'
)comment '员工表';
```

## DML

