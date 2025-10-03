# 安装
- wsl --install or wsl --update
- 如果失败就下载.msi镜像来安装https://github.com/microsoft/wsl/releases
- 别去wsl的说明页面下那个是垃圾艹了--version都不能用的too old版本艹!!!!
- 下载一个发行版例如ubuntu https://ubuntu.com/desktop/wsl
- 安装到文件夹wsl --import Ubuntu D:\wsl_ubuntu\faxing D:\wsl_ubuntu\ubuntu-24.04.3-wsl-amd64.gz --version 2


# 快照
WSL 官方 wsl --export / --import （推荐）
WSL 提供了导出整个发行版到压缩包的功能，相当于保存当前文件系统状态（不包含内存状态），之后可以用导入的方式恢复，非常适合当做“快照”。

## 保存快照
在 PowerShell 或 CMD 中：

 查看当前所有 WSL 发行版
wsl --list --verbose
 假设你的 Ubuntu 名为 "Ubuntu"
wsl --export Ubuntu D:\backup\ubuntu_snapshot_2024_07_01.tar
这个 tar 文件就是整个 Ubuntu 环境的快照。

## 恢复到快照

先删除原来的（会丢失当前数据）
wsl --unregister Ubuntu
从快照导入
wsl --import Ubuntu D:\WSL\Ubuntu D:\backup\ubuntu_snapshot_2024_07_01.tar
这样新的 WSL 环境会替换成快照时的状态。

📌 特点：

类似“关机状态的快照”，不包含当时的运行中进程。
快照文件可以跨机器用，非常适合备份和迁移。
需要手动导出/恢复，不如 VMware 一键快照方便，但灵活、可脚本化。

- 本机:wsl --export Ubuntu D:\wsl_ubuntu\backup\ubuntu_snapshot_2025_9_29.tar

# 命令
- wsl -d Ubuntu
- 设置默认发行版
wsl --set-default Ubuntu-22.04


# docker for wsl

## 汉化
https://github.com/asxez/DockerDesktop-CN

