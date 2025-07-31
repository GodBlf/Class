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