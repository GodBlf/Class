# NoSQL
- json格式存储
- 无关联没物理外键有逻辑外键
- 非SQL语言
- 事务特性:BASE sql的是ACID

# redis数据结构

## string
- keys 查找键
- del 删除键
- exists 判断键是否存在
- expire 设置键的多少秒后死亡
- ttl  查看键寿命 -1永久不死 -2死了 

- set 添加键值对
- mset 批量添加键值对
- incr 自增1
- incrby 自增自定义步长可以用负数自减法

- setnx 存在不在创建
- setex 组合命令set+expire

## hashmap
Hash类型的常见命令
Hash的常见命令有:
- HSET key field value：添加或者修改hash类型key的field的值
- HGET key field：获取一个hash类型key的field的值
- HMSET：批量添加多个hash类型key的field的值
- HMGET：批量获取多个hash类型key的field的值
- HGETALL：获取一个hash类型的key中的所有的field和value
- HKEYS：获取一个hash类型的key中的所有的field
- HVALS：获取一个hash类型的key中的所有的value
- HINCRBY:让一个hash类型key的字段值自增并指定步长
- HSETNX：添加一个hash类型的key的field值，前提是这个field不存在，否则不执行

## list
