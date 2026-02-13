# docker 容器
docker run -d \
  --name my-redis \
  -p 6379:6379 \
  -v /home/yourname/redis/data:/data \
  redis redis-server --appendonly yes --requirepass "your_password"
参数拆解：

-d: 后台运行。

--name my-redis: 给容器起个名字。

-p 6379:6379: 将容器的 6379 端口映射到主机的 6379 端口。

-v ...:/data: 挂载卷。把 Redis 数据存到 WSL 本地目录，防止容器删了数据也没了。

--appendonly yes: 开启持久化。

--requirepass "your_password": 设置访问密码（强烈建议设置）。

# nosql
- key-value类型数据库
- sql是容器->databases->tables sql有很多数据库,而redis仅有一张大表

# 通用命令
命令,作用,备注
KEYS *,查看匹配模式的所有键,生产环境慎用，如果键太多会阻塞服务器。
EXISTS key,检查某个键是否存在,返回 1 表示存在，0 表示不存在。
DEL key,删除指定的键,支持删除多个，如 DEL k1 k2。
EXPIRE key seconds,为键设置过期时间,单位为秒。非常适合做临时缓存。
TTL key,查看键还有多久过期,-1 表示永久，-2 表示已过期或不存在。
TYPE key,查看键的数据类型,"例如返回 string, hash, list 等。"

# 类型
## String
- value可以是整数浮点数,json字符串...
- 命令,描述,示例
SET,设置一个键值对,"SET user:1 ""John"""
GET,获取键的值,GET user:1
MSET,批量设置多个键值对,MSET k1 v1 k2 v2
MGET,批量获取多个键的值,MGET k1 k2
GETSET,设置新值并返回旧值,GETSET count 100
incr,数字自增1,incr key
incrby,数字自增指定树木,incrby key 2
incrbyfloat,数字自增小数
decr/decrby 相应的自减一般 使用 incr/incrby key 负数实现
SET key value [NX|XX] [EX seconds|PX milliseconds]:
    这是现代推荐的写法，将“判断是否存在”和“设置过期时间”合并成一个原子操作。

    NX: 不存在才执行。

    EX: 设置秒级过期。
setex key seconds value == set key value ; expire key seconds

## 键层级结构
- hh:user:1  hh:goods:1 区别不同类型的id

## Hash

# go-redis
- 单例设计 lazy init
```go
var (
	blog_mysql      *gorm.DB
	blog_mysql_once sync.Once
	dblog           ormlog.Interface

	blog_redis      *redis.Client
	blog_redis_once sync.Once
	schemaOnce      sync.Once
)
func InitRedisClient() *redis.Client {
	blog_redis_once.Do(func() {
		config := util.CreateConfig("redis")
		client := redis.NewClient(&redis.Options{
			Addr:     config.GetString("addr"),
			Password: config.GetString("password"),
			DB:       config.GetInt("db"),
		})
		result, err := client.Ping().Result()
		if err != nil {
			zap.L().Panic("failed to connect to redis", zap.Error(err))
			panic(err)
		}
		zap.L().Info("connected to redis", zap.String("result", result))
		blog_redis = client
	})
	return blog_redis
}

```





