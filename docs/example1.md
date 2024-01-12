



# 用tidyr读写、操作文件

## 使用内置数据集iris


```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
# tibble是tidyverse的dataframe，是dataframe的超集
data = as_tibble(iris)
data
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # ℹ 140 more rows
```

## %\>% 的使用

`%>%`名为管道符，是tidyr的重要组件,其作用是将管道符前的数据传递给管道符后的函数的第一个参数,快捷键是 Ctrl + Shift + M。

```r
data %>% 
  View()
# 这里等同于
View(data)
```

在单个函数时管道符的作用并不明显，但是在操作数据框时，我们往往需要多个步骤。使用管道符可以减少中间变量的个数，但是注意不要过分依赖管道。

以下是分组汇总每种花各个特征的平均数，使用管道显得简洁明了。


```r
data %>% 
  group_by(Species) %>% 
  summarise(across(everything(), mean))
```

```
## # A tibble: 3 × 5
##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
## 1 setosa             5.01        3.43         1.46       0.246
## 2 versicolor         5.94        2.77         4.26       1.33 
## 3 virginica          6.59        2.97         5.55       2.03
```

## select的使用

select的作用是选择一列或多列


```r
data %>% 
  select(Species)
```

```
## # A tibble: 150 × 1
##    Species
##    <fct>  
##  1 setosa 
##  2 setosa 
##  3 setosa 
##  4 setosa 
##  5 setosa 
##  6 setosa 
##  7 setosa 
##  8 setosa 
##  9 setosa 
## 10 setosa 
## # ℹ 140 more rows
```

选择iris中所有的数值列的列名,sapply在example2中有介绍。


```r
features = colnames(data)[sapply(data, class) == "numeric"]
```

注意这个弹出警告,select内只能选择列名，不能接受一个变量。


```r
data %>% 
  select(features)
```

```
## Warning: Using an external vector in selections was deprecated in tidyselect 1.1.0.
## ℹ Please use `all_of()` or `any_of()` instead.
##   # Was:
##   data %>% select(features)
## 
##   # Now:
##   data %>% select(all_of(features))
## 
## See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
## generated.
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

如果我们想正确的查找一个变量内的若干列,应该用all_of等函数括起来。

```r
data %>% 
  select(all_of(features))
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```
除了all_of外，还有诸如any_of的其他函数，请自行翻阅学习

如果只能这么做的话那tidyverse也称不上强大,毕竟原生的dataframe也支持变量索引。

```r
iris[, features]
```

```
##     Sepal.Length Sepal.Width Petal.Length Petal.Width
## 1            5.1         3.5          1.4         0.2
## 2            4.9         3.0          1.4         0.2
## 3            4.7         3.2          1.3         0.2
## 4            4.6         3.1          1.5         0.2
## 5            5.0         3.6          1.4         0.2
## 6            5.4         3.9          1.7         0.4
## 7            4.6         3.4          1.4         0.3
## 8            5.0         3.4          1.5         0.2
## 9            4.4         2.9          1.4         0.2
## 10           4.9         3.1          1.5         0.1
## 11           5.4         3.7          1.5         0.2
## 12           4.8         3.4          1.6         0.2
## 13           4.8         3.0          1.4         0.1
## 14           4.3         3.0          1.1         0.1
## 15           5.8         4.0          1.2         0.2
## 16           5.7         4.4          1.5         0.4
## 17           5.4         3.9          1.3         0.4
## 18           5.1         3.5          1.4         0.3
## 19           5.7         3.8          1.7         0.3
## 20           5.1         3.8          1.5         0.3
## 21           5.4         3.4          1.7         0.2
## 22           5.1         3.7          1.5         0.4
## 23           4.6         3.6          1.0         0.2
## 24           5.1         3.3          1.7         0.5
## 25           4.8         3.4          1.9         0.2
## 26           5.0         3.0          1.6         0.2
## 27           5.0         3.4          1.6         0.4
## 28           5.2         3.5          1.5         0.2
## 29           5.2         3.4          1.4         0.2
## 30           4.7         3.2          1.6         0.2
## 31           4.8         3.1          1.6         0.2
## 32           5.4         3.4          1.5         0.4
## 33           5.2         4.1          1.5         0.1
## 34           5.5         4.2          1.4         0.2
## 35           4.9         3.1          1.5         0.2
## 36           5.0         3.2          1.2         0.2
## 37           5.5         3.5          1.3         0.2
## 38           4.9         3.6          1.4         0.1
## 39           4.4         3.0          1.3         0.2
## 40           5.1         3.4          1.5         0.2
## 41           5.0         3.5          1.3         0.3
## 42           4.5         2.3          1.3         0.3
## 43           4.4         3.2          1.3         0.2
## 44           5.0         3.5          1.6         0.6
## 45           5.1         3.8          1.9         0.4
## 46           4.8         3.0          1.4         0.3
## 47           5.1         3.8          1.6         0.2
## 48           4.6         3.2          1.4         0.2
## 49           5.3         3.7          1.5         0.2
## 50           5.0         3.3          1.4         0.2
## 51           7.0         3.2          4.7         1.4
## 52           6.4         3.2          4.5         1.5
## 53           6.9         3.1          4.9         1.5
## 54           5.5         2.3          4.0         1.3
## 55           6.5         2.8          4.6         1.5
## 56           5.7         2.8          4.5         1.3
## 57           6.3         3.3          4.7         1.6
## 58           4.9         2.4          3.3         1.0
## 59           6.6         2.9          4.6         1.3
## 60           5.2         2.7          3.9         1.4
## 61           5.0         2.0          3.5         1.0
## 62           5.9         3.0          4.2         1.5
## 63           6.0         2.2          4.0         1.0
## 64           6.1         2.9          4.7         1.4
## 65           5.6         2.9          3.6         1.3
## 66           6.7         3.1          4.4         1.4
## 67           5.6         3.0          4.5         1.5
## 68           5.8         2.7          4.1         1.0
## 69           6.2         2.2          4.5         1.5
## 70           5.6         2.5          3.9         1.1
## 71           5.9         3.2          4.8         1.8
## 72           6.1         2.8          4.0         1.3
## 73           6.3         2.5          4.9         1.5
## 74           6.1         2.8          4.7         1.2
## 75           6.4         2.9          4.3         1.3
## 76           6.6         3.0          4.4         1.4
## 77           6.8         2.8          4.8         1.4
## 78           6.7         3.0          5.0         1.7
## 79           6.0         2.9          4.5         1.5
## 80           5.7         2.6          3.5         1.0
## 81           5.5         2.4          3.8         1.1
## 82           5.5         2.4          3.7         1.0
## 83           5.8         2.7          3.9         1.2
## 84           6.0         2.7          5.1         1.6
## 85           5.4         3.0          4.5         1.5
## 86           6.0         3.4          4.5         1.6
## 87           6.7         3.1          4.7         1.5
## 88           6.3         2.3          4.4         1.3
## 89           5.6         3.0          4.1         1.3
## 90           5.5         2.5          4.0         1.3
## 91           5.5         2.6          4.4         1.2
## 92           6.1         3.0          4.6         1.4
## 93           5.8         2.6          4.0         1.2
## 94           5.0         2.3          3.3         1.0
## 95           5.6         2.7          4.2         1.3
## 96           5.7         3.0          4.2         1.2
## 97           5.7         2.9          4.2         1.3
## 98           6.2         2.9          4.3         1.3
## 99           5.1         2.5          3.0         1.1
## 100          5.7         2.8          4.1         1.3
## 101          6.3         3.3          6.0         2.5
## 102          5.8         2.7          5.1         1.9
## 103          7.1         3.0          5.9         2.1
## 104          6.3         2.9          5.6         1.8
## 105          6.5         3.0          5.8         2.2
## 106          7.6         3.0          6.6         2.1
## 107          4.9         2.5          4.5         1.7
## 108          7.3         2.9          6.3         1.8
## 109          6.7         2.5          5.8         1.8
## 110          7.2         3.6          6.1         2.5
## 111          6.5         3.2          5.1         2.0
## 112          6.4         2.7          5.3         1.9
## 113          6.8         3.0          5.5         2.1
## 114          5.7         2.5          5.0         2.0
## 115          5.8         2.8          5.1         2.4
## 116          6.4         3.2          5.3         2.3
## 117          6.5         3.0          5.5         1.8
## 118          7.7         3.8          6.7         2.2
## 119          7.7         2.6          6.9         2.3
## 120          6.0         2.2          5.0         1.5
## 121          6.9         3.2          5.7         2.3
## 122          5.6         2.8          4.9         2.0
## 123          7.7         2.8          6.7         2.0
## 124          6.3         2.7          4.9         1.8
## 125          6.7         3.3          5.7         2.1
## 126          7.2         3.2          6.0         1.8
## 127          6.2         2.8          4.8         1.8
## 128          6.1         3.0          4.9         1.8
## 129          6.4         2.8          5.6         2.1
## 130          7.2         3.0          5.8         1.6
## 131          7.4         2.8          6.1         1.9
## 132          7.9         3.8          6.4         2.0
## 133          6.4         2.8          5.6         2.2
## 134          6.3         2.8          5.1         1.5
## 135          6.1         2.6          5.6         1.4
## 136          7.7         3.0          6.1         2.3
## 137          6.3         3.4          5.6         2.4
## 138          6.4         3.1          5.5         1.8
## 139          6.0         3.0          4.8         1.8
## 140          6.9         3.1          5.4         2.1
## 141          6.7         3.1          5.6         2.4
## 142          6.9         3.1          5.1         2.3
## 143          5.8         2.7          5.1         1.9
## 144          6.8         3.2          5.9         2.3
## 145          6.7         3.3          5.7         2.5
## 146          6.7         3.0          5.2         2.3
## 147          6.3         2.5          5.0         1.9
## 148          6.5         3.0          5.2         2.0
## 149          6.2         3.4          5.4         2.3
## 150          5.9         3.0          5.1         1.8
```

where、contains是dplyr里的函数,其作用是用于选择列，对列做判断,这些函数只能在select起作用。
下文中提到的across是一种特殊的select，所以也可以在里面用,这里只简单介绍where。


```r
data %>% 
  select(where(is.numeric))
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

R中!表示非门

```r
!c(T, T, F)
```

```
## [1] FALSE FALSE  TRUE
```

同时在select中可以用-来删除列,以下方法可以用于删除列。

```r
data %>% 
  select(-Species)
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

```r
data %>% 
  select(!Species)
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

```r
data %>% 
  select(-where(is.numeric))
```

```
## # A tibble: 150 × 1
##    Species
##    <fct>  
##  1 setosa 
##  2 setosa 
##  3 setosa 
##  4 setosa 
##  5 setosa 
##  6 setosa 
##  7 setosa 
##  8 setosa 
##  9 setosa 
## 10 setosa 
## # ℹ 140 more rows
```

```r
data %>% 
  select(!where(is.numeric))
```

```
## # A tibble: 150 × 1
##    Species
##    <fct>  
##  1 setosa 
##  2 setosa 
##  3 setosa 
##  4 setosa 
##  5 setosa 
##  6 setosa 
##  7 setosa 
##  8 setosa 
##  9 setosa 
## 10 setosa 
## # ℹ 140 more rows
```

select还支持一些其它的索引方法。

数字索引


```r
data %>% 
  select(1:4)
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

行名顺序索引


```r
data %>% 
  select(Sepal.Length:Petal.Width)
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

有的时候我们想什么都不做,everything可以用来调换列的位置，书中有详解。


```r
data %>% 
  select(everything())
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # ℹ 140 more rows
```

## mutate的使用

mutate是对列进行增改的函数


```r
# 增添
data %>% 
  mutate(new = 1)
```

```
## # A tibble: 150 × 6
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   new
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl>
##  1          5.1         3.5          1.4         0.2 setosa      1
##  2          4.9         3            1.4         0.2 setosa      1
##  3          4.7         3.2          1.3         0.2 setosa      1
##  4          4.6         3.1          1.5         0.2 setosa      1
##  5          5           3.6          1.4         0.2 setosa      1
##  6          5.4         3.9          1.7         0.4 setosa      1
##  7          4.6         3.4          1.4         0.3 setosa      1
##  8          5           3.4          1.5         0.2 setosa      1
##  9          4.4         2.9          1.4         0.2 setosa      1
## 10          4.9         3.1          1.5         0.1 setosa      1
## # ℹ 140 more rows
```

```r
# 修改
data %>% 
  mutate(Species = 1)
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl>   <dbl>
##  1          5.1         3.5          1.4         0.2       1
##  2          4.9         3            1.4         0.2       1
##  3          4.7         3.2          1.3         0.2       1
##  4          4.6         3.1          1.5         0.2       1
##  5          5           3.6          1.4         0.2       1
##  6          5.4         3.9          1.7         0.4       1
##  7          4.6         3.4          1.4         0.3       1
##  8          5           3.4          1.5         0.2       1
##  9          4.4         2.9          1.4         0.2       1
## 10          4.9         3.1          1.5         0.1       1
## # ℹ 140 more rows
```

```r
# 变换
data %>% 
  mutate(sum = Sepal.Length + Sepal.Width)
```

```
## # A tibble: 150 × 6
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   sum
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <dbl>
##  1          5.1         3.5          1.4         0.2 setosa    8.6
##  2          4.9         3            1.4         0.2 setosa    7.9
##  3          4.7         3.2          1.3         0.2 setosa    7.9
##  4          4.6         3.1          1.5         0.2 setosa    7.7
##  5          5           3.6          1.4         0.2 setosa    8.6
##  6          5.4         3.9          1.7         0.4 setosa    9.3
##  7          4.6         3.4          1.4         0.3 setosa    8  
##  8          5           3.4          1.5         0.2 setosa    8.4
##  9          4.4         2.9          1.4         0.2 setosa    7.3
## 10          4.9         3.1          1.5         0.1 setosa    8  
## # ℹ 140 more rows
```

有的时候我们想只修改特定条件下的列,这时候需要借助ifelse进行判断。
ifelse咋用请搜索，?ifelse可以在右下角弹出窗口查阅文档。


```r
data %>% 
  mutate(Sepal.Length_new = ifelse(Species == "setosa", Sepal.Length + 10, Sepal.Length))
```

```
## # A tibble: 150 × 6
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Length_new
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>              <dbl>
##  1          5.1         3.5          1.4         0.2 setosa              15.1
##  2          4.9         3            1.4         0.2 setosa              14.9
##  3          4.7         3.2          1.3         0.2 setosa              14.7
##  4          4.6         3.1          1.5         0.2 setosa              14.6
##  5          5           3.6          1.4         0.2 setosa              15  
##  6          5.4         3.9          1.7         0.4 setosa              15.4
##  7          4.6         3.4          1.4         0.3 setosa              14.6
##  8          5           3.4          1.5         0.2 setosa              15  
##  9          4.4         2.9          1.4         0.2 setosa              14.4
## 10          4.9         3.1          1.5         0.1 setosa              14.9
## # ℹ 140 more rows
```

有的时候我们相对多列进行相同的操作,难道我们要一个一个写出来吗？


```r
data %>% 
  mutate(Sepal.Length = Sepal.Length ** 2, 
         Sepal.Width = Sepal.Width ** 2, 
         Petal.Length = Petal.Length ** 2, 
         Petal.Width = Petal.Width ** 2)
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

答案是no,我们应该用across，across相当于在mutate内应用select。

千万注意是where(is.numeric)不是where(is.numeric())，至于为什么就不能加那个括号在example2中有所涉及。

之所以这个函数写法那么怪，在example2中有所涉及。

```r
square = function(vec) vec ** 2

data %>% 
  mutate(across(where(is.numeric), square))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

更常见的是匿名函数写法,匿名函数就是没有名字的临时函数,括号里面的是临时变量名，随便起。


```r
data %>% 
  mutate(across(where(is.numeric), function(vec) vec ** 2))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

```r
# \()是匿名函数中function()的简写
data %>% 
  mutate(across(where(is.numeric), \(vec) vec ** 2))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

~和.x是tidyverse中的新型匿名函数形式,它省略了为变量命名的步骤，认为变量就应该叫.x。

```r
# 等同于\(.x)，写起来简约一些
data %>% 
  mutate(across(where(is.numeric), ~ .x ** 2))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

回到上面那个问题，如果我们非想在where里的函数加上括号，也应该用匿名函数。


```r
data %>% 
  mutate(across(where(~ is.numeric(.x)), ~ .x ** 2))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

```r
data %>% 
  mutate(across(where(\(.x) is.numeric(.x)), ~ .x ** 2))
```

```
## # A tibble: 150 × 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1         26.0       12.2          1.96        0.04 setosa 
##  2         24.0        9            1.96        0.04 setosa 
##  3         22.1       10.2          1.69        0.04 setosa 
##  4         21.2        9.61         2.25        0.04 setosa 
##  5         25         13.0          1.96        0.04 setosa 
##  6         29.2       15.2          2.89        0.16 setosa 
##  7         21.2       11.6          1.96        0.09 setosa 
##  8         25         11.6          2.25        0.04 setosa 
##  9         19.4        8.41         1.96        0.04 setosa 
## 10         24.0        9.61         2.25        0.01 setosa 
## # ℹ 140 more rows
```

我们可以这么理解，一旦一个函数加了括号，意思就是我们打算立即执行这个函数。


```r
function_test = function() features
function_test()
```

```
## [1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"
```

```r
data %>% 
  select(all_of(function_test()))
```

```
## # A tibble: 150 × 4
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
##           <dbl>       <dbl>        <dbl>       <dbl>
##  1          5.1         3.5          1.4         0.2
##  2          4.9         3            1.4         0.2
##  3          4.7         3.2          1.3         0.2
##  4          4.6         3.1          1.5         0.2
##  5          5           3.6          1.4         0.2
##  6          5.4         3.9          1.7         0.4
##  7          4.6         3.4          1.4         0.3
##  8          5           3.4          1.5         0.2
##  9          4.4         2.9          1.4         0.2
## 10          4.9         3.1          1.5         0.1
## # ℹ 140 more rows
```

## group_by + summarise

group_by和summarise是对分组数据进行描述的方法,就是先分组，再汇总。


```r
data %>% 
  group_by(Species) %>% 
  summarise(Sepal.Length_mean = mean(Sepal.Length))
```

```
## # A tibble: 3 × 2
##   Species    Sepal.Length_mean
##   <fct>                  <dbl>
## 1 setosa                  5.01
## 2 versicolor              5.94
## 3 virginica               6.59
```

同理，summarise里也可以用across。


```r
data %>% 
  group_by(Species) %>% 
  summarise(across(everything(), mean))
```

```
## # A tibble: 3 × 5
##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
## 1 setosa             5.01        3.43         1.46       0.246
## 2 versicolor         5.94        2.77         4.26       1.33 
## 3 virginica          6.59        2.97         5.55       2.03
```

同理，summarise里也可以用where匿名函数。


```r
data %>% 
  group_by(Species) %>% 
  summarise(across(where(is.numeric), ~ mean(.x)))
```

```
## # A tibble: 3 × 5
##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
## 1 setosa             5.01        3.43         1.46       0.246
## 2 versicolor         5.94        2.77         4.26       1.33 
## 3 virginica          6.59        2.97         5.55       2.03
```

简单做个正态性检验。


```r
data %>% 
  group_by(Species) %>% 
  summarise(across(where(is.numeric), ~ shapiro.test(.x)$p.value))
```

```
## # A tibble: 3 × 5
##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
## 1 setosa            0.460       0.272       0.0548 0.000000866
## 2 versicolor        0.465       0.338       0.158  0.0273     
## 3 virginica         0.258       0.181       0.110  0.0870
```

group_nest是group_by的一种变体，但是用法和group_by完全不一样,group_nest利用了tibble的神奇特性，dataframe里可以嵌套列表或另一个dataframe，但是这种操作过于复杂了，并且不够通用。书中有详解，这里不过多介绍。

lm是R中用于建模的函数，下面第一个~是匿名函数，第二个函数是R的公式写法


```r
data %>% 
  group_nest(Species) %>% 
  mutate(models = map(data, ~ lm(Sepal.Length ~ ., data = .x)))
```

```
## # A tibble: 3 × 3
##   Species                  data models
##   <fct>      <list<tibble[,4]>> <list>
## 1 setosa               [50 × 4] <lm>  
## 2 versicolor           [50 × 4] <lm>  
## 3 virginica            [50 × 4] <lm>
```

## 检验环节


```r
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
```

汇总数据，包括所有浮点数的均值，每种cut的个数。注意为什么一个用了匿名函数，一个没有用匿名函数。


```r
data %>% 
  select(cut, where(is.double)) %>% 
  group_by(cut) %>% 
  summarise(n = n(), across(everything(), ~ mean(.x, na.rm = T)))
```

```
## # A tibble: 6 × 5
##     cut     n carat depth table
##   <int> <dbl> <dbl> <dbl> <dbl>
## 1     1  1326 1.03   64.0  59.1
## 2     2  3996 0.847  62.3  58.7
## 3     3  9834 0.810  61.8  58.0
## 4     4 11184 0.898  61.3  58.8
## 5     5 17522 0.703  61.7  56.0
## 6    NA 10078 0.792  61.8  57.4
```

```r
data_interpolated %>% 
  select(cut, where(is.double)) %>% 
  group_by(cut) %>% 
  summarise(num = n(), across(everything(), mean))
```

```
## # A tibble: 5 × 5
##     cut   num carat depth table
##   <int> <dbl> <dbl> <dbl> <dbl>
## 1     1  1326 0.999  63.7  58.7
## 2     2  3996 0.840  62.3  58.4
## 3     3  9834 0.808  61.8  57.9
## 4     4 11184 0.884  61.3  58.5
## 5     5 27600 0.745  61.7  56.7
```
