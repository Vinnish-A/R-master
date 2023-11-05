##### 测验 #####

# 有数据如下
#   type
# 1 a, b
# 2    -
# 3    a
# 需统计其出现位置，如下
#      a b -
# [1,] 1 1 0
# [2,] 0 0 1
# [3,] 1 0 0

data = data.frame(type = c("a, b", "-", "a"))

# 可采用以下若干方法

##### 1. 向量化 #####

type = data$type %>% 
  unique() %>% 
  str_split(", ") %>% 
  unlist() %>% 
  unique()

# 下面这种写法利用了R的参数传递机制
# 灵活、强大，但是不美观，表现为把传参过程写在函数的外面
# 但是有一些特定用途，比如说多个函数依赖于同一个参数
sapply(type, \(x, invec) as.numeric(grepl(x, invec)), invec = data$type)
# 在没有上述特定情况下，个人更喜欢以下写法
sapply(type, \(x, invec = data$type) as.numeric(grepl(x, invec)))
# 像下面这样写也是可以的，但是总让人觉得这段程序要崩溃
# 在定义不严格的动态语言中（如python和R）经常看到这种写法，让人觉得很不安全
# 但是只是看着不安全，如果你理解了上述的参数传递机制和R的命名空间知识后，就会觉得没什么大不了的
# 但是在极端情况下还是会崩溃，比如在r的shiny软件中惰性求值
sapply(type, \(x) as.numeric(grepl(x, data$type)))

# map函数同样可以，不过需要提前命名
# map函数是purrr中的函数，相当于apply函数簇的拓展，用法相似
names(type) = type
map(type, \(x, invec = data$type) as.numeric(grepl(x, invec))) %>% 
  as_tibble()
map_dfc(type, \(x, invec = data$type) as.numeric(grepl(x, invec)))

# purrr的匿名函数设计中因为没有显式的传参
# 所以只能用于单个参数，剩下一个参数只能从全局调用
# 等同于上述的那种写法
map_dfc(type, ~ as.numeric(grepl(.x, data$type)))

##### 2. tibble的nested tibble性质 #####

# tibble拓展了dataframe的范围
# 支持储存列表，甚至套娃另一个df

data %>%
  as_tibble() %>% 
  mutate(
    y = str_split(type, ", "), 
    y = map(y, ~ set_names(.x, .x))) %>% 
  unnest_wider(y) %>% 
  mutate(across(-type, ~ ifelse(is.na(.x), 0, 1)))

##### 3. dataframe操作 #####

# 利用tibble的性质确实有些超模了
# 只利用tidyr的数据框操作也可以
# 如果想单纯的使用mutate解决，无疑就陷入了误区
# 但是思路比较刁钻

data %>% 
  mutate(id = type, value = 1) %>% 
  separate_rows(type, sep = ", ") %>% 
  pivot_wider(names_from = type, values_from = value, values_fill = 0)

##### 4. 循环 #####

type = data$type %>% 
  unique() %>% 
  str_split(", ") %>% 
  unlist() %>% 
  unique()

result = list()
for (element in type) {
  result[[element]] = as.numeric(grepl(element, data$type))
}
as.data.frame(result)








