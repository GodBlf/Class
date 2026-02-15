# json库
- json是web间用字符串传输的方式 golang中字符串底层是[]byte or []rune 所以序列化是将json对象(struct`` map slice等)编码成[]byte字符串形式传输,byte可封装到redaer里供golang读取
- 反序列化解码将byte字符串解码到json对象(struct`` map slice等)或者通过gjson直接解析字符串
- 发送一般用map接受一般解码到struct
unmarshal这一步必须封装在结构体可以用匿名结构体

# gjson库
对字符串json的轻量解析

# sonic库
- 用法和json库一样,性能提升