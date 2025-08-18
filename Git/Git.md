下载 github desktop 用github desktop登录后仅能用一个账号git 

所以把主力账号邀请到另一号的库就ok了

git bash 和cmd一样命令行工具 

---
ctrl+shift+管理员终端 可在本目录下打开 管理员powershell

git init 生成.git文件 把当前目录改造为一个本地仓库 .git里含有配置信息日志等

Git Bash 是 Git 自带的一个命令行工具（CLI），它为 Windows 用户提供了类似 Unix 的 Bash 环境，从而可以在 Windows 系统上流畅地使用 Git 的各种命令以及一些基本的 Linux 命令。gitbash可以在powershell中调用;

以下是关于 Git Bash 的详细讲解和使用教程：

---
## Git gpt
### 1. **Git Bash 的安装**
- **下载**：从 [Git 官网](https://git-scm.com/) 下载适合你操作系统的 Git 安装包。
- **安装**：在安装过程中，选择默认选项即可。如果你需要 Git Bash，请在安装过程中选择它。
- 安装完成后，你可以通过右键菜单或者开始菜单打开 Git Bash。

---

### 2. **Git Bash 的基本界面**
- 打开 Git Bash 后，你会看到一个命令行窗口，类似于 Linux 终端。
- 它支持基本的 Git 命令、一些常用的 Unix/Linux 命令（如 `ls`、`pwd`、`cd` 等），以及脚本操作。

---

### 3. **常用的 Git Bash 命令**
以下是一些在 Git Bash 中常用的 Git 命令及其功能：

#### **Git 初始化和基本配置**
```bash
git init
```
- 初始化一个 Git 仓库。

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```
- 配置全局用户名和邮箱。

```bash
git config --list
```
- 查看当前的 Git 配置。

---

#### **克隆远程仓库**
```bash
git clone <仓库的远程地址>
```
- 从远程仓库下载代码到本地。

---

#### **查看状态**
```bash
git status
```
- 查看当前仓库的状态，比如文件是否被修改、是否被跟踪等。

---

#### **添加文件到暂存区**
```bash
git add <文件名>
# 或者添加所有文件
git add .
```
- 将文件添加到暂存区，准备提交。

---

#### **提交到本地仓库**
```bash
git commit -m "提交信息"
```
- 提交代码到本地仓库，并附带简短的提交说明。

---

#### **查看提交历史**
```bash
git log
```
- 查看提交历史。

---

#### **推送到远程仓库**
```bash
git push origin <分支名>
```
- 将本地代码推送到远程仓库。

---

#### **从远程仓库拉取代码**
```bash
git pull origin <分支名>
```
- 拉取远程代码并合并到当前分支。

---

#### **创建新分支**
```bash
git branch <分支名>
```
- 创建一个新分支。

---

#### **切换分支**
```bash
git checkout <分支名>
```
- 切换到指定的分支。

---

#### **合并分支**
```bash
git merge <分支名>
```
- 将指定分支合并到当前分支。

---

### 4. **Git Bash 支持的常用 Linux 命令**
Git Bash 除了支持 Git 命令外，也支持以下一些常用的 Linux 命令：

- `pwd`：显示当前目录路径。
- `ls`：列出当前目录下的文件和文件夹。
- `cd`：切换目录。
- `touch`：创建空文件。
- `rm`：删除文件。
- `mkdir`：创建新文件夹。
- `cp`：复制文件。
- `mv`：移动或重命名文件。

---

### 5. **Git Bash 的快捷键**
- **Tab 补全**：在输入文件名或命令时，按下 `Tab` 键可以自动补全。
- **Ctrl + L**：清空终端屏幕。
- **上下箭头**：浏览历史命令。

---

### 6. **Git Bash 的使用场景**
- **版本控制**：使用 Git 进行代码的版本管理。
- **远程协作**：与团队成员协作，通过 Git 拉取、推送代码。
- **Bash 脚本执行**：运行 .sh 脚本文件。
- **终端操作**：在 Windows 环境中使用 Linux 风格的命令行操作。

---

### 7. **Git Bash 的优势**
- 对 Linux 用户非常友好，命令风格一致。
- 集成了 Git 和 Unix/Linux 的功能，适合 Windows 用户使用。
- 轻量级，简单易用。

---

### 8. **常见问题**
- **Git Bash 中文乱码**：可以通过修改 Git Bash 配置文件来设置字符编码为 `UTF-8`。
- **SSH 配置问题**：如果需要通过 SSH 连接远程仓库，可以在 Git Bash 中生成 SSH Key 并配置：
  ```bash
  ssh-keygen -t rsa -b 4096 -C "你的邮箱"
  ```
  然后将生成的公钥添加到远程仓库。

---

通过熟悉 Git Bash 的基本使用和常见命令，你可以高效地管理代码、协作开发，并利用 Bash 环境完成一些常见的终端操作。