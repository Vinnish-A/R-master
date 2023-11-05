library(tidyverse)

# 使用内置数据集iris
iris
# tibble是tidyverse的dataframe，是dataframe的超集
data = as_tibble(iris)
data

# %>% 名为管道符
# 其作用是将管道符前的数据传递给管道符后的函数的第一个参数
data %>% 
  View()

# 这里等同于
View(data)

# 在单个函数时管道符的作用并不明显
# 但是在操作数据框时，我们往往需要多个步骤
# 使用管道符可以减少中间变量的个数
# 但是注意不要过分依赖管道

# 以下是分组汇总每种花各个特征的平均数
# 使用管道显得简洁明了
data %>% 
  group_by(Species) %>% 
  summarise(across(everything(), mean))

# select

# select的作用是选择一列或多列
data %>% 
  select(Species)

# 选择iris中所有的数值列的列名
# sapply在example2中有介绍
features = colnames(data)[sapply(data, class) == "numeric"]

# 注意这个弹出警告
# select内只能选择列名，不能接受一个变量
data %>% 
  select(features)

# 如果我们想正确的查找一个变量内的若干列
# 应该用all_of等函数括起来
# 除了all_of外，还有诸如any_of的其他函数，请自行翻阅学习
data %>% 
  select(all_of(features))

# 如果只能这么做的话那tidyverse也称不上强大
# 毕竟原生的dataframe也支持变量索引
iris[, features]

# where、contains是dplyr里的函数
# 其作用是用于选择列，对列做判断
# 这些函数只能在select起作用
# 下文中提到的across是一种特殊的select，所以也可以在里面用
# 这里只简单介绍where
data %>% 
  select(where(is.numeric))

# R中!表示非门
!c(T, T, F)

# 同时在select中可以用-来删除列
# 以下方法可以用于删除列
data %>% 
  select(-Species)

data %>% 
  select(!Species)

data %>% 
  select(-where(is.numeric))

data %>% 
  select(!where(is.numeric))

# select还支持一些其它的索引方法

# 数字索引
data %>% 
  select(1:4)

# 行名顺序索引
data %>% 
  select(Sepal.Length:Petal.Width)

# 有的时候我们想什么都不做
# everything可以用来调换列的位置，书中有详解
data %>% 
  select(everything())

# mutate

# mutate是对列进行增改的函数

# 增添
data %>% 
  mutate(new = 1)

# 修改
data %>% 
  mutate(Species = 1)

# 变换
data %>% 
  mutate(sum = Sepal.Length + Sepal.Width)

# 有的时候我们想只修改特定条件下的列
# 这时候需要借助ifelse进行判断
# ifelse咋用请搜索
# ?ifelse可以在右下角弹出窗口查阅文档
data %>% 
  mutate(Sepal.Length_new = ifelse(Species == "setosa", Sepal.Length + 10, Sepal.Length))

# 有的时候我们相对多列进行相同的操作
# 难道我们要一个一个写出来吗？
data %>% 
  mutate(Sepal.Length = Sepal.Length ** 2, 
         Sepal.Width = Sepal.Width ** 2, 
         Petal.Length = Petal.Length ** 2, 
         Petal.Width = Petal.Width ** 2)

# 答案是no
# 我们应该用across
# across相当于在mutate内应用select

# 千万注意是where(is.numeric)不是where(is.numeric())
# 至于为什么就不能加那个括号在example2中有所涉及

# 之所以这个函数写法那么怪，在example2中有所涉及
square = function(vec) vec ** 2

data %>% 
  mutate(across(where(is.numeric), square))

# 更常见的是匿名函数写法
# 匿名函数就是没有名字的临时函数
# 括号里面的是临时变量名，随便起
data %>% 
  mutate(across(where(is.numeric), function(vec) vec ** 2))

# \()是匿名函数中function()的简写
data %>% 
  mutate(across(where(is.numeric), \(vec) vec ** 2))

# ~和.x是tidyverse中的新型匿名函数形式
# 它省略了为变量命名的步骤，认为变量就应该叫.x
# 等同于\(.x)，写起来简约一些
data %>% 
  mutate(across(where(is.numeric), ~ .x ** 2))

# 回到上面那个问题，如果我们非想在where里的函数加上括号，也应该用匿名函数

data %>% 
  mutate(across(where(~ is.numeric(.x)), ~ .x ** 2))

data %>% 
  mutate(across(where(\(.x) is.numeric(.x)), ~ .x ** 2))

# 我们可以这么理解，一旦一个函数加了括号，意思就是我们打算立即执行这个函数
function_test = function() features
function_test()
data %>% 
  select(all_of(function_test()))

# group_by + summarise

# group_by和summarise是对分组数据进行描述的方法
# 就是先分组，再汇总
data %>% 
  group_by(Species) %>% 
  summarise(Sepal.Length_mean = mean(Sepal.Length))

# 同理，summarise里也可以用across
data %>% 
  group_by(Species) %>% 
  summarise(across(everything(), mean))

# 同理，summarise里也可以用where匿名函数
data %>% 
  group_by(Species) %>% 
  summarise(across(where(is.numeric), ~ mean(.x)))

# 简单做个正态性检验
data %>% 
  group_by(Species) %>% 
  summarise(across(where(is.numeric), ~ shapiro.test(.x)$p.value))

# group_nest是group_by的一种变体，但是用法和group_by完全不一样
# group_nest利用了tibble的神奇特性，dataframe里可以嵌套列表或另一个dataframe
# 但是这种操作过于复杂了，并且不够通用
# 书中有详解，这里不过多介绍

# lm是R中用于建模的函数，下面第一个~是匿名函数，第二个函数是R的公式写法
data %>% 
  group_nest(Species) %>% 
  mutate(models = map(data, ~ lm(Sepal.Length ~ ., data = .x)))

# 下面是检验环节

data("diamonds")

# 生成不定比例的整数
random_int = function(ratio_min, size) {
  ratio = runif(1, ratio_min, 3*ratio_min)
  result = unique(round(runif(round(ratio*size), min = 1, max = size)))
  return(result)
}

# 计算众数
cal_mode = function(vec) {
  result = names(which.max(table(vec)))
  if (is.integer(vec)) {
    return(as.integer(result))
  } else {
    return(result)
  }
}

# 制造缺失值
## 波浪号是tidyr中匿名函数的简约写法，等同于function(x)
rows = nrow(diamonds)
data = diamonds %>% 
  select(carat:price) %>% 
  mutate(index = 1:nrow(.), 
         across(everything(), ~ ifelse(index %in% random_int(0.1, rows), NA, .x))) %>% 
  select(-index)

# 对整数列的缺失值进行众数插补，对浮点数列的缺失值进行均值插补
data_interpolated = data %>% 
  mutate(across(where(is.integer), ~ ifelse(is.na(.x), cal_mode(.x), .x)), 
         across(where(is.double), ~ ifelse(is.na(.x), mean(.x, na.rm = T), .x)))

# 汇总数据，包括所有浮点数的均值，每种cut的个数
## 注意为什么一个用了匿名函数，一个没有用匿名函数
data %>% 
  select(cut, where(is.double)) %>% 
  group_by(cut) %>% 
  summarise(n = n(), across(everything(), ~ mean(.x, na.rm = T)))

data_interpolated %>% 
  select(cut, where(is.double)) %>% 
  group_by(cut) %>% 
  summarise(num = n(), across(everything(), mean))
