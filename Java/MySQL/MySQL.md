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
数据库和表的定义语句
### 数据库
- show databases;
- select database();
- use 数据库名;
- create database [if not exists] 数据库名 [default charset utf8mb4];
- drop database [if exists] 数据库名;

### 表
操作是在数据库进行所以对某个表修改要指定表名
```sql
create table user(
    --主键 自增 
    -- 主键非空唯一==not null unique
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

- show tables 
- describe 表; show create table 表; 展示建表信息
- alter table 表 ...
```sql
-- 添加字段
alter table 表名 add  字段名  类型(长度)  [comment 注释]  [约束];

-- 比如： 为tb_emp表添加字段qq，字段类型为 varchar(11)
alter table tb_emp add  qq  varchar(11) comment 'QQ号码';

-- 修改字段类型
alter table 表名 modify  字段名  新数据类型(长度);

-- 比如： 修改qq字段的字段类型，将其长度由11修改为13
alter table tb_emp modify qq varchar(13) comment 'QQ号码';

-- 修改字段名，字段类型
alter table 表名 change  旧字段名  新字段名  类型(长度)  [comment 注释]  [约束];

-- 比如： 修改qq字段名为 qq_num，字段类型varchar(13)
alter table tb_emp change qq qq_num varchar(13) comment 'QQ号码';

-- 删除字段
alter table 表名 drop 字段名;

-- 比如： 删除tb_emp表中的qq_num字段
alter table tb_emp drop qq_num;

-- 修改表名
rename table 表名 to  新表名;

-- 比如: 将当前的emp表的表名修改为tb_emp
rename table emp to tb_emp;

-- 删除表
drop  table [ if exists ]  表名;

-- 比如：如果tb_emp表存在，则删除tb_emp表
drop table if exists tb_emp;  -- 在删除表时，表中的全部数据也会被删除。
```

## 数据类型
- tinyint : 1 byte
- smallint: 2byte
- int: 4byte
- bigint:8byte
- float: 4byte
- double : 8byte

unsigned 无符号 varchar(10) char(10)变长字符串和定长字符串

- date datetime year time
### 常用数据类型
- unsigned 无符号
- tinyint 1字节 genger
- smallint 2字节
- int 4字节 
- varchar() 变长字符 60k多字节
- char()定长字符 255字节最长
- date time datetime
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
对表数据增删改操作
操作是在数据库进行所以对某个表修改要指定表名

### insert into

insert into emp(username, name, gender, phone, create_time, update_time)
values ('Tom1', '汤姆1', 1, '13309091231', now(), now()),
       ('Tom2', '汤姆2', 1, '13309091232', now(), now());

- 对所有字段添加推荐全部写在表参数里

### update set
- 行向量
update emp set name='张三', update_time=now() where id=1;

### delete from
- 行向量
delete from emp where id = 1;