# ClassBoot
一切皆从Class启动

# 树形结构

```mermaid
graph TD

A((Math/ZFC公理化集合论))
B{Algorithm/Skills}
C{DesignPattern}
D(Algorithm/Algorithm)
Java(Java)
Go(Golang)
Class(Class)
Class-->LLMs(LLMs)
Class-->W(Web)
Class-->Tool(ToolSoftware)
Class-->etc(...Tips)
Blf((Belief))--->|Class|A
A===|imitate|B
A===|imitate|C
B-->D
B-->Java
B-->Go
C-->Java
C-->Go
```

# 仓库依赖
```mermaid
graph TD
A(Class)-->B(Blog)
A-->C(GithubProjects)
C-->D
D(GithubProjects/README)-->B


```

# 格式导论
## json
- 每一部分开头写一个json来作为导论
- "重要内容":"辅助记忆的内容"//注释
- 辅助记忆的内容可以是符号 英文单词 或者自己造的专有名词例如Skills里的很多内容
(自己造专有名词/skills里的>符号>英文单词)注释可以随便修饰
- 目的就是轻量化记忆起到导论的作用总结重点,可以有的没有,不可以有的坚决没有
- 参考自数学的ZFC公理体系集合论
- 通过集合可以构造出代数分析体系
- skills对应集合论公理定理 json对应如何组合公理定理方便记忆
## mermaid
- mermaid 图 辅助记忆类似思维导图
## boot
- xxxboot
快速预览某个技术栈
## 模板
- 某个技术栈的模板直接copy

# 历史
```mermaid
graph TD

a(discord云盘化失败)-->b(auroradasiyGitHub私密账号当云盘用)

b-->c(需要总结一些网站小方法方法技巧创立Index 着重web/实用技巧)
c-->d(学java找工作转专业创立新github公开账号godblf邀请到私密账号的index维护)
d-->e(搬移到godblf上在学java 命名为Class 想着以后用面向对象思想组织)
e-->f(学算法整理了一些小技巧总结到skills)
f-->g(借鉴ZFC公理化集合论 将skills公理 定理化正式开启新Class构建篇章)
g-->h(用hexo搭建博客构建Class->Porjects/readme->Blog Class->Blog,维护Class的README文档管理结构)


```

https://discord.com/channels/1218507417533419531/1271304462656475167