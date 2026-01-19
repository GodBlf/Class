```json
{
    "axiom set theory":"math", //具体参见/Class/Math/集合论 
    "ram":"理论,算法,工程以计算机内存和集合论为基础",
    //
    //
    "type var":["type facilitate compiler malloc var and operate ","variable is one field of memory","state is the variables' value " ],
    //type方便编译器分配给变量大小和运算规则,variable是计算机内存ram的一块区域,具体取值是state,系统多个变量取值组合也可是系统整体状态
    "pointer":"a var stores the memory address of another variable",
    //directed graph模型 方便变量的传递
    //
    //
    "function":"简单起见,类计算机io stack这种称作函数,在计算机底层函数是通过函数栈来实现得", 
    //函数调用底层是通过函数栈实现,调用函数入栈,return出栈.例如f(g(x)) ->f->g ; g return ->f ; f return ->
    "relation":"简单起见,类数学中研究的连续函数 order_set 点的集合叫做关系"
}
```

# 算法-工程
- 算法考虑var state function relation偏多
- 工程考虑 type var pointer较多