---
title: "Type"
date: 2022-02-15T15:25:33+08:00
draft: false
---

## PEP

帮助 IDE 为我们提供更智能的提示

这些新特性不会影响语言本身，只是增加一点提示

Python 3.5、3.6 新增了两个特性 PEP 484 和 PEP 526

+ PEP 484：https://www.python.org/dev/peps/pep-0484/
    - 函数参数提示
+ PEP 526：https://www.python.org/dev/peps/pep-0526/
    - 变量提示

```python
from typing import List, ClassVar, Dict

# int 变量，默认值为 0
num: int = 0

# bool 变量，默认值为 True
bool_var: bool = True

# 字典变量，默认为空
dict_var: Dict = {}

# 列表变量，且列表元素为 int
primes: List[int] = []


class Starship(object):
    # 类变量,字典类型,键-字符串,值-整型
    stats: ClassVar[Dict[str, int]] = {}

    # 实例变量，标注了是一个整型
    num: int
```

这个类型提示更像是一个规范约束，并不是一个语法限制

## 示例

### 变量类型提示-元组打包

```python

# 正常的元组打包
a = 1, 2, 3

# 加上类型提示的元组打包
t: Tuple[int, ...] = (1, 2, 3)
print(t)

t = 1, 2, 3
print(t)

# py3.8+ 才有的写法
t: Tuple[int, ...] = 1, 2, 3
print(t)

t = 1, 2, 3
print(t)

# 输出结果
(1, 2, 3)
(1, 2, 3)
(1, 2, 3)
(1, 2, 3)
```

### 变量类型提示-元组解包

```python
# 正常元组解包
message = (1, 2, 3)
a, b, c = message
print(a, b, c)  # 输出 1 2 3

# 加上类型提示的元组解包
header: str
kind: int
body: Optional[List[str]]

# 不会 warning 的栗子
header, kind, body = ("str", 123, ["1", "2", "3"])

# 会提示 warning 的栗子
header, kind, body = (123, 123, ["1", "2", "3"])
```

### 在类里面使用

```python
class BasicStarship(object):
    captain: str = 'Picard'               # 实例变量，有默认值
    damage: int                           # 实例变量，没有默认值
    stats: ClassVar[Dict[str, int]] = {}  # 类变量，有默认值
```

>ClassVar
是 typing 模块的一个特殊类
向静态类型检查器指示不应在类实例上设置此变量

```python

```

```python

```

```python

```