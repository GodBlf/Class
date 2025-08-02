# 导论
- mybatis springdata等底层都是jdbc
- JDBC：（Java DataBase Connectivity），就是使用Java语言操作关系型数据库的一套API。
本质：
- sun公司官方定义的一套操作所有关系型数据库的规范，即接口。
- 各个数据库厂商去实现这套接口，提供数据库驱动jar包。
- 我们可以使用这套接口(JDBC)编程，真正执行的代码是驱动jar包中的实现类。

# JDBC
- 预编译
缓存 sql语句性能更好
防止sql语句注入:静态拼接的时候容易污染代码
```java
public class jdbcUpdateTest {
    
    @Test
    public void testSelect() throws Exception{
        //反射加载jdbc的一个实例对象
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url="jdbc:mysql://127.0.0.1:3306/web01";
        String username="root";
        String password="asd456";
        String sql="select * from user where username = ?  and\n" +
                "password= ?";
        //factory pattern 
        Connection connection = DriverManager.getConnection(url, username, password);
        //缓存;预编译
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1,"daqiao");
        statement.setString(2,"123456");
        ResultSet resultSet = statement.executeQuery();
        while(resultSet.next()){
            User user = new User(
                    resultSet.getInt("id"),
                    resultSet.getString("username"),
                    resultSet.getString("password"),
                    resultSet.getString("name"),
                    resultSet.getInt("age")
            );
            System.out.println(user.toString());
        }

        //
        statement.close();
        connection.close();
    }
}
```

# mybatis
- 持久层DAO框架;简化jdbc

# 依赖引入
- lombook mybatis mysql

- 编码设置为utf-8;

#

# 数据库链接池
- 容器分配管理数据库链接(connection)
- 实现接口的 connection有druid和springboot默认链接产品
- 切换druid
```xml
<dependenies>
    <dependeny>
        <groupId>com.alibab</groupId>
        <artifactId>druid-spring-boot-starter</artifactId>
        <version>1.2.19</version>
    </dependeny>
</dependenies>

```

# 

# 预编译
- #{}相当于jdbc的?将函数中的参数传递到数据建库预编译
- ${}是直接拼接不是预编译方式不推荐使用
- 函数参数编译为字节码参数将没有名字 应该用@Param("")来对应占位符和传递的参数 官方springboot框架可以省略
- 参数传递封装的对象,占位符用对应的成员变量可以自动对应

# xml映射文件
在Mybatis中使用XML映射文件方式开发，需要符合一定的规范：
1. XML映射文件的名称与Mapper接口名称一致，并且将XML映射文件和Mapper接口放置在相同包下（同包同名）目录用/不用.
2. XML映射文件的namespace属性为Mapper接口全限定名一致
3. XML映射文件中sql语句的id与Mapper接口中的方法名一致，并保持返回类型一致。
4. 小的用注解 大的用xml映射文件

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.itheima.mapper.EmpMapper">

    <!--查询操作-->
    <select id="findAll" resultType="com.itheima.pojo.User">
        select * from user
    </select>
    
</mapper>

标签是对mapper类的描述