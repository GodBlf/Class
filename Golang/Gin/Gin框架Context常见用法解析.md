# Gin框架Context常见用法解析

## 🧑‍💻 User

讲解gin框架 context常见用法

---
## 🤖 Assistant

好的，我们来讲解一下 **Gin 框架中 `Context` 的常见用法**。
Gin 是 Go 语言中常用的 Web 框架，它的核心就是路由和中间件，而 `Context` 是每个请求在处理过程中传递的核心对象。通过 `Context`，我们可以获取请求、生成响应、控制流程等。

---

## 1. 获取请求参数
Gin 提供了多种方法从请求中获取参数。

### (1) 路由参数
```go
r.GET("/user/:id", func(c *gin.Context) {
    id := c.Param("id")   // 获取路径参数
    c.String(200, "user id: %s", id)
})
```

### (2) Query 参数（URL 中 `?key=value` 部分）
```go
r.GET("/search", func(c *gin.Context) {
    keyword := c.Query("q")                 // 获取查询参数
    page := c.DefaultQuery("page", "1")     // 带默认值
    c.JSON(200, gin.H{"q": keyword, "page": page})
})
```

### (3) POST Form 参数
```go
r.POST("/form", func(c *gin.Context) {
    name := c.PostForm("name")
    age := c.DefaultPostForm("age", "18")
    c.JSON(200, gin.H{"name": name, "age": age})
})
```

### (4) JSON Body
```go
type User struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

r.POST("/json", func(c *gin.Context) {
    var user User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }
    c.JSON(200, user)
})
```

---

## 2. 设置响应
`Context` 常用于返回响应。

```go
c.String(200, "Hello World")                          // 返回字符串
c.JSON(200, gin.H{"status": "ok"})                    // 返回JSON
c.XML(200, gin.H{"message": "ok"})                    // 返回XML
c.Data(200, "text/plain", []byte("raw data"))         // 返回字节流
c.Redirect(302, "https://example.com")                // 重定向
```

---

## 3. 中间件中的 Context 用法
`Context` 在中间件中常用来设置、获取值以及控制流程。

### (1) 设置和获取键值对
```go
r.Use(func(c *gin.Context) {
    c.Set("requestId", "123456") // 设置上下文变量
    c.Next()
})

r.GET("/test", func(c *gin.Context) {
    v, _ := c.Get("requestId")
    c.String(200, v.(string))
})
```

### (2) 控制中间件流程
- `c.Next()` 继续执行后续中间件/handler
- `c.Abort()` 阻止后续执行

```go
r.Use(func(c *gin.Context) {
    if c.Query("token") != "secret" {
        c.JSON(401, gin.H{"error": "unauthorized"})
        c.Abort()
        return
    }
    c.Next()
})
```

---

## 4. 响应状态码
```go
c.Status(204)   // 只返回状态码，不带body
```

---

## 5. 文件处理
```go
c.File("path/to/file")        // 直接下载文件
c.FileAttachment("file.zip", "rename.zip") // 带下载文件名
```

---

## 6. 重用 Context 来绑定其他格式
- `c.ShouldBindJSON()`：绑定 JSON
- `c.ShouldBindQuery()`：绑定 URL Query
- `c.ShouldBindXML()`：绑定 XML
- `c.ShouldBindYAML()`：绑定 YAML
常用于统一参数处理。

---

## 总结
Gin 的 `Context` 类似于一个 request-scoped 的上下文容器，它常用来：
1. 获取各种参数（路径、Query、Form、Body）
2. 返回各种响应（字符串、JSON、XML、文件）
3. 在中间件中存取数据、控制流程
4. 绑定请求数据到结构体

---

要不要我给你整理一份 **常见 `Context` 用法速查表**（表格形式，带常用方法说明，方便快速查阅）？
