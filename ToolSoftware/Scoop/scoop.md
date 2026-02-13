# 包管理工具类似于npm

# 更改下载位置
## 1. 设置用户软件安装路径
$env:SCOOP='D:\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

## 2. 设置全局软件安装路径 (需管理员权限运行 PowerShell)
$env:SCOOP_GLOBAL='D:\ScoopGlobal'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')

# 下载
irm get.scoop.sh | iex

# 命令
命令,功能描述,常用示例
search,搜索软件,scoop search python
install,安装软件,scoop install git
uninstall,卸载软件,scoop uninstall nodejs
list,查看已安装列表,scoop list
info,查看软件详情,scoop info curl
status,检查可更新的软件,scoop status
update,更新软件/库,scoop update *
cleanup,清除旧版本缓存,scoop cleanup *
bucket add,添加软件仓库,scoop bucket add extras
cache rm,删除下载的安装包缓存,scoop cache rm *
checkup,系统健康检查,scoop checkup
alias,管理自定义别名,scoop alias add rm uninstall


# 版本管理/数据持久化
文件夹,角色,存放内容,为什么要这么做？
apps\node,程序主体,"node.exe, npm.cmd 等二进制文件。",方便你一键切换版本（比如从 v20 降级到 v18），直接替换整个文件夹即可。
persist\node,数据中心,"全局安装的工具（如 yarn, pnpm）和 npm-cache。",核心原因： 当你更新 Node 版本时，Scoop 会删除旧的 apps\node 文件夹，但它会保留 persist 里的内容，这样你的全局插件就不会丢失。