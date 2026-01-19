# go mod init
初始化模块
# go mod tidy 
整理依赖

# go env
查看go环境变量
- $env:GOOS="windows"设置编译环境变量

go get -u github/.../@latest  go mod tidy
- GOROOT:gosdk所在的路径
- GOPATH:go install 下载的第三方库运行程序所在的路径
- GOPRIVATE:下载公司内部私有依赖时候使用
go env -w GOPRIVATE="*.gitee.cn"
- GOPROXY:代理
go env -w GOPROXY=https://goproxy.cn,direct


# go build <package-path>
- $env:GOOS="windows"设置编译环境变量 linux改为linux

用途： 编译 Go 源代码。它将源代码编译成一个可执行文件（对于 main 包），或者一个包归档文件（对于非 main 包），并将其放置在当前目录。
示例： go build (在当前目录下编译 main 包，生成可执行文件，文件名通常是当前目录名)
示例： go build -o myapp ./cmd/myapp (编译 cmd/myapp 目录下的 main 包，并命名为 myapp 可执行文件)
常用参数：
-o <output-name>: 指定输出文件的名称。
-v: 打印编译时所涉及的包名。
-ldflags "-s -w": 减小可执行文件大小，去除调试信息。
-tags <tag-name>: 根据构建标签选择性地编译代码。

# go get
下载添加依赖

# go install
- 将库的脚手架下载到go env中的go path里方便快速生成脚手架代码

