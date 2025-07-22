

@echo off
setlocal

REM 设置仓库路径和提交信息
set "repo_path=D:\Projects\HelloWorld"
set "commit_message=Batch commit changes"

REM 更改当前工作目录到仓库路径
cd /d %repo_path%

REM 暂存所有的更改
git add .

REM 提交更改
git commit -m "%commit_message%"

REM 推送更改到远程仓库
REM git push

endlocal



@echo off
setlocal

REM 设置仓库路径和提交信息
set "repo_path=D:\Projects\Class"
set "commit_message=Batch commit changes"

REM 更改当前工作目录到仓库路径
cd /d %repo_path%

REM 暂存所有的更改
git add .

REM 提交更改
git commit -m "%commit_message%"

REM 推送更改到远程仓库
REM git push

endlocal




@echo off
setlocal

REM 设置仓库路径和提交信息
set "repo_path=D:\Projects\Me"
set "commit_message=Batch commit changes"

REM 更改当前工作目录到仓库路径
cd /d %repo_path%

REM 暂存所有的更改
git add .

REM 提交更改
git commit -m "%commit_message%"

REM 推送更改到远程仓库
REM git push

endlocal






@echo off
setlocal

REM 设置仓库路径和提交信息
set "repo_path=D:\Projects\ACG_Songs_and_Lyrics"
set "commit_message=Batch commit changes"

REM 更改当前工作目录到仓库路径
cd /d %repo_path%

REM 暂存所有的更改
git add .

REM 提交更改
git commit -m "%commit_message%"

REM 推送更改到远程仓库
REM git push

endlocal



ping 127.0.0.1 -n 6 >nul


