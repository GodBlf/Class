# VS Code 自动保存设置方法

## 🧑‍💻 User

如何设置vscode的自动保存

---
## 🤖 Assistant

在 VS Code 中设置**自动保存**非常简单，你可以通过以下几种方式来实现：

---

### **方法一：通过设置菜单启用自动保存**
1. 打开 VS Code。
2. 点击左下角的 **齿轮图标（管理） → Settings（设置）**，或者使用快捷键：
 - **Windows / Linux**：`Ctrl + ,`
 - **macOS**：`Cmd + ,`
3. 在搜索框中输入 **auto save**。
4. 找到 **Files: Auto Save** 选项，根据需要选择模式：
 - `off`：关闭自动保存（默认）。
 - `afterDelay`：在一段时间后自动保存（可在 `Files: Auto Save Delay` 中设置毫秒数）。
 - `onWindowChange`：当窗口失去焦点时自动保存。
 - `onWindowChangeFocus`：当切换到另一应用时自动保存。
5. 如果选择 `afterDelay` 模式，可以在 **Files: Auto Save Delay** 中设置延迟时间（默认 1000 毫秒）。

---

### **方法二：使用命令面板快速设置**
1. 按下：
 - **Windows / Linux**：`Ctrl + Shift + P`
 - **macOS**：`Cmd + Shift + P`
2. 输入 `auto save`。
3. 选择 **File: Auto Save**，然后选择你想要的保存模式。

---

### **方法三：直接修改配置文件**
1. 打开 **Settings (JSON)**：
 - 点击右上角**打开设置 JSON**图标，或者在命令面板中输入 `Preferences: Open Settings (JSON)`。
2. 添加如下配置：
```json
{
 "files.autoSave": "afterDelay",
 "files.autoSaveDelay": 1000
}
```
其中：
 - `"afterDelay"`：延迟保存。
 - `"onWindowChange"` 或 `"onFocusChange"`：按需要选择。
 - `"off"`：关闭自动保存。

---

💡 **建议：**
- 如果写代码时不希望频繁触发自动编译，可以用 `onWindowChange` 模式。
- 如果希望实时保存，推荐 `afterDelay` 并调成 500~1000 毫秒延迟。

---

你需要我帮你配一个**最佳 VS Code 自动保存加自动格式化配置**，这样修改代码会自动保存并格式化吗？这样写前端或后端都很爽。
