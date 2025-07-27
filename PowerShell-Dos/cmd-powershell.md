# 打开方式
win+r cmd enter
win+x A
进入项目目录,右键 ctrl+shift+左键终端管理员启动

# 环境变量设置
- 用户变量和系统变量一个是用户一个是所有用户作用范围
- 环境变量是windows的全变量
- 值可以为int string等 用%variable% 来引用变量
## Path变量
- 存的是路径使得windows终端能找到应用.exe二进制文件
- 建议把.exe所在目录设置单独的变量再在path中引用 e.g. %Maven%\bin
- 设置完成可以在任意位置使用 git  python等命令 git --version 这个git就是调用git.exe这个程序

# 
- cls  清屏

# 目录操作
## cd
cd d:/lol  d可以大写
cd d:\lol   /可以和\  \\互换
cd /dota
cd ./dota  /同./ 相对路径
cd  ../   转到父目录
简易使用/ 正斜杠

## tree
- tree [路径] [/F] [/A]

-  参数空
 树结构展开当前目录
 展开所有文件夹不展开具体文件
- /f 
展开所有到具体文件

- /a
用accic字符输出

- tree /F | clip
重新定向到剪贴板

- tree /f | more
more：逐屏显示输出内容。按回车键向下滚动一行，按空格键向下滚动一页，按 Q 退出。

