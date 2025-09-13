# 单元测试
- 注意test启动会执行原文件的init方法
- test执行会在当前目录开辟一个单独的工作空间注意路径问题
建议重新配置原文件的依赖路径

# assert断言测试 期望和真实值

# 表驱动单元测试
关心是否报错 / 关心错误信息 / 关心错误类型
这样可以让单元测试代码更简洁。

---

## 1. 只关心是否报错 (`wantErr bool`)
```go
func TestExe2DvsId_BoolErr(t *testing.T) {
	tests := []struct {
		input    string
		expected string
		wantErr  bool
	}{
		{"123_456", "123", false},
		{"abc_def", "abc", false},
		{"xyz_", "xyz", false},
		{"_123", "", false},
		{"no_underscore", "", true},
		{"", "", true},
	}

	for _, tt := range tests {
		got, err := Exe2DvsId(tt.input)
		if tt.wantErr {
			assert.Error(t, err, "input=%v", tt.input)
		} else {
			assert.NoError(t, err, "input=%v", tt.input)
			assert.Equal(t, tt.expected, got, "input=%v", tt.input)
		}
	}
}
```

---

## 2. 关心错误消息 (`wantErrMsg string`)
```go
func TestExe2DvsId_ErrMsg(t *testing.T) {
	tests := []struct {
		input      string
		expected   string
		wantErrMsg string
	}{
		{"123_456", "123", ""},
		{"no_underscore", "", "execution格式错误"},
		{"", "", "execution格式错误"},
	}

	for _, tt := range tests {
		got, err := Exe2DvsId(tt.input)
		if tt.wantErrMsg != "" {
			assert.EqualError(t, err, tt.wantErrMsg, "input=%v", tt.input)
		} else {
			assert.NoError(t, err, "input=%v", tt.input)
			assert.Equal(t, tt.expected, got, "input=%v", tt.input)
		}
	}
}
```

---

## 3. 关心错误类型 (`wantErr error`)
这种方式往往和 **自定义 error** 或 **`var ErrXYZ = errors.New(...)`** 结合。
例如我们把函数定义里改一下：

```go
var ErrInvalidFormat = errors.New("execution格式错误")

func Exe2DvsId(execution string) (string, error) {
	index := strings.Index(execution, "_")
	if index == -1 {
		return "", ErrInvalidFormat
	}
	return execution[0:index], nil
}
```

测试：

```go
func TestExe2DvsId_ErrType(t *testing.T) {
	tests := []struct {
		input    string
		expected string
		wantErr  error
	}{
		{"123_456", "123", nil},
		{"abc_def", "abc", nil},
		{"no_underscore", "", ErrInvalidFormat},
	}

	for _, tt := range tests {
		got, err := Exe2DvsId(tt.input)
		if tt.wantErr != nil {
			assert.ErrorIs(t, err, tt.wantErr, "input=%v", tt.input)
		} else {
			assert.NoError(t, err, "input=%v", tt.input)
			assert.Equal(t, tt.expected, got, "input=%v", tt.input)
		}
	}
}
```

---

✅ 小结
- `assert.Error` / `assert.NoError` 👉 判断是否报错。
- `assert.EqualError` 👉 判断错误消息是否匹配。
- `assert.ErrorIs` 👉 判断错误类型（支持 `errors.Is` 语义）。

这样三个场景你都能玩转。

## 例子
func TestExe2DvsId(t *testing.T) {
	test := []struct {
		input        string
		expectOutput string
		exepectError error
	}{
		{"device123_exec456", "device123", nil},
		{"node_789_task_1011", "node", nil},
		{"invalidformat", "", errors.New("execution格式错误")},
		{"no_underscore", "no", nil},
		{"_leadingunderscore", "", nil},
		{"trailingunderscore_", "trailingunderscore", nil},
	}

	for _, tt := range test {
		output, err := Exe2DvsId(tt.input)
		assert.Equal(t, tt.expectOutput, output)
		assert.Equal(t, tt.exepectError, err)
	}
}