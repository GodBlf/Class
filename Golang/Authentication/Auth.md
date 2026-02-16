# 身份认证
- cookie:令牌-令牌型
- jwt: 令牌-密钥型 

# Cookie
- 后端发给前端相同令牌,并cookie:id map类型存储在数据库中;
- 比较两个令牌进行身份认证,不存在则无权,存在就从map中取出用户信息完成身份认证
```go
const COOKIE_NAME = "dqq"

func Login(ctx *gin.Context) {
	uid := "8"
	key := util.RandStringRunes(20)
	rc := database.InitRedisClient()
	rc.Set(key, uid, 86400*7*time.Second)
	ctx.SetCookie(
		COOKIE_NAME,
		key,
		86400*7,
		"/",
		"localhost",
		false,
		true,
	)
	ctx.String(http.StatusOK, "login success")
}


func getUidFromCookie(ctx *gin.Context) string {
	for _, cookie := range ctx.Request.Cookies() {
		if cookie.Name == COOKIE_NAME {
			if uid, exists := loggedIn[cookie.Value]; exists {
				return uid
			}
		}
	}
	return ""
}

```

# JWT
- jwt库
- 后端用密钥对前端信息加密成令牌发给前端,后端不存储;
- 对令牌解密,不能解密的则无权,能解密的解密出身份信息完成身份认证
## jwt组成
- 由header.payload.digest组成
  头包含加密算法类型,载荷包含具体信息,digest为用密钥加密(header.payload)后的信息
- 具体实现
header和payload 字节数组->转成base64->用.拼接->转成字节数组->加密生成字节数组->转成base64->用.拼接
## jwtBoot
- 生成和校验
```go
package util

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

// JWT_SECRET 建议从环境变量获取
const JWT_SECRET = "myblog_secret"

// MyClaims 定义自己的声明结构体
type MyClaims struct {
	UserDefined map[string]any `json:"ud,omitempty"` // 对应你原有的自定义字段
	jwt.RegisteredClaims                // 包含 ID, Issuer, Audience, Subject, ExpiresAt, IssuedAt, NotBefore
}

// GenJwt 生成 JWT (对应你原有的 GenJwt)
func GenJwt(claims MyClaims) (string, error) {
	// 1. 创建声明实例
	// golang-jwt 会自动帮你处理 Header (alg: HS256, typ: JWT)
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// 2. 签名并获取完整字符串
	return token.SignedString([]byte(JWT_SECRET))
}

// VerifyJwt 验证并解析 JWT (对应你原有的 VerifyJwt)
func VerifyJwt(tokenString string) (*MyClaims, error) {
	// 解析 Token
	ans:=&MyClaims{}
	token, err := jwt.ParseWithClaims(tokenString, ans, func(token *jwt.Token) (interface{}, error) {
		// 校验签名算法是否匹配
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(JWT_SECRET), nil
	})

	if err != nil {
		return nil, err
	}

	// 校验并返回 Claims
	if token.Valid {
		return ans, nil
	}

	return nil, errors.New("invalid token")
}
```
- 中间件
```go
package middleware

import (
	"net/http"
	"strings"
	"your_project/util" // 替换为你的实际路径

	"github.com/gin-gonic/gin"
)

func JWTAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. 从 Header 获取 Token
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "msg": "未授权，请登录"})
			c.Abort()
			return
		}

		// 2. 检查 Bearer 格式
		parts := strings.SplitN(authHeader, " ", 2)
		if !(len(parts) == 2 && parts[0] == "Bearer") {
			c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "msg": "Token格式有误"})
			c.Abort()
			return
		}

		// 3. 验证 Token
		claims, err := util.VerifyJwt(parts[1])
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "msg": "Token已失效或不合法"})
			c.Abort()
			return
		}

		// 4. 将解析出的 Claims 存入上下文，方便后续接口使用
		c.Set("claims", claims)
		c.Set("user_id", claims.ID) // 也可以直接存具体字段
		
		c.Next()
	}
}
```
# 浏览器存储

# 双token验证
- jwt问题:时间长不安全,时间短用户频繁登录
- 解决方案:设置两个token jwt时间短,refreshtoken(cookie)时间长.将refreshtoken-jwt存入redis
- jwt过期redis通过发来的rtoken再发送新的jwt