


# 字符串操作和R进阶

## 提纲

### 变量掩蔽

正常情况下，我们需要使用索引来调用某一列。


```r
iris$Species
```

```
##   [1] setosa     setosa     setosa     setosa     setosa     setosa    
##   [7] setosa     setosa     setosa     setosa     setosa     setosa    
##  [13] setosa     setosa     setosa     setosa     setosa     setosa    
##  [19] setosa     setosa     setosa     setosa     setosa     setosa    
##  [25] setosa     setosa     setosa     setosa     setosa     setosa    
##  [31] setosa     setosa     setosa     setosa     setosa     setosa    
##  [37] setosa     setosa     setosa     setosa     setosa     setosa    
##  [43] setosa     setosa     setosa     setosa     setosa     setosa    
##  [49] setosa     setosa     versicolor versicolor versicolor versicolor
##  [55] versicolor versicolor versicolor versicolor versicolor versicolor
##  [61] versicolor versicolor versicolor versicolor versicolor versicolor
##  [67] versicolor versicolor versicolor versicolor versicolor versicolor
##  [73] versicolor versicolor versicolor versicolor versicolor versicolor
##  [79] versicolor versicolor versicolor versicolor versicolor versicolor
##  [85] versicolor versicolor versicolor versicolor versicolor versicolor
##  [91] versicolor versicolor versicolor versicolor versicolor versicolor
##  [97] versicolor versicolor versicolor versicolor virginica  virginica 
## [103] virginica  virginica  virginica  virginica  virginica  virginica 
## [109] virginica  virginica  virginica  virginica  virginica  virginica 
## [115] virginica  virginica  virginica  virginica  virginica  virginica 
## [121] virginica  virginica  virginica  virginica  virginica  virginica 
## [127] virginica  virginica  virginica  virginica  virginica  virginica 
## [133] virginica  virginica  virginica  virginica  virginica  virginica 
## [139] virginica  virginica  virginica  virginica  virginica  virginica 
## [145] virginica  virginica  virginica  virginica  virginica  virginica 
## Levels: setosa versicolor virginica
```

```r
iris[["Species"]]
```

```
##   [1] setosa     setosa     setosa     setosa     setosa     setosa    
##   [7] setosa     setosa     setosa     setosa     setosa     setosa    
##  [13] setosa     setosa     setosa     setosa     setosa     setosa    
##  [19] setosa     setosa     setosa     setosa     setosa     setosa    
##  [25] setosa     setosa     setosa     setosa     setosa     setosa    
##  [31] setosa     setosa     setosa     setosa     setosa     setosa    
##  [37] setosa     setosa     setosa     setosa     setosa     setosa    
##  [43] setosa     setosa     setosa     setosa     setosa     setosa    
##  [49] setosa     setosa     versicolor versicolor versicolor versicolor
##  [55] versicolor versicolor versicolor versicolor versicolor versicolor
##  [61] versicolor versicolor versicolor versicolor versicolor versicolor
##  [67] versicolor versicolor versicolor versicolor versicolor versicolor
##  [73] versicolor versicolor versicolor versicolor versicolor versicolor
##  [79] versicolor versicolor versicolor versicolor versicolor versicolor
##  [85] versicolor versicolor versicolor versicolor versicolor versicolor
##  [91] versicolor versicolor versicolor versicolor versicolor versicolor
##  [97] versicolor versicolor versicolor versicolor virginica  virginica 
## [103] virginica  virginica  virginica  virginica  virginica  virginica 
## [109] virginica  virginica  virginica  virginica  virginica  virginica 
## [115] virginica  virginica  virginica  virginica  virginica  virginica 
## [121] virginica  virginica  virginica  virginica  virginica  virginica 
## [127] virginica  virginica  virginica  virginica  virginica  virginica 
## [133] virginica  virginica  virginica  virginica  virginica  virginica 
## [139] virginica  virginica  virginica  virginica  virginica  virginica 
## [145] virginica  virginica  virginica  virginica  virginica  virginica 
## Levels: setosa versicolor virginica
```

如果需要索引的部分过多，我们可能会累死。


```r
iris$Sepal.Length + iris$Sepal.Width + iris$Petal.Length
```

```
##   [1] 10.0  9.3  9.2  9.2 10.0 11.0  9.4  9.9  8.7  9.5 10.6  9.8  9.2  8.4 11.0
##  [16] 11.6 10.6 10.0 11.2 10.4 10.5 10.3  9.2 10.1 10.1  9.6 10.0 10.2 10.0  9.5
##  [31]  9.5 10.3 10.8 11.1  9.5  9.4 10.3  9.9  8.7 10.0  9.8  8.1  8.9 10.1 10.8
##  [46]  9.2 10.5  9.2 10.5  9.7 14.9 14.1 14.9 11.8 13.9 13.0 14.3 10.6 14.1 11.8
##  [61] 10.5 13.1 12.2 13.7 12.1 14.2 13.1 12.6 12.9 12.0 13.9 12.9 13.7 13.6 13.6
##  [76] 14.0 14.4 14.7 13.4 11.8 11.7 11.6 12.4 13.8 12.9 13.9 14.5 13.0 12.7 12.0
##  [91] 12.5 13.7 12.4 10.6 12.5 12.9 12.8 13.4 10.6 12.6 15.6 13.6 16.0 14.8 15.3
## [106] 17.2 11.9 16.5 15.0 16.9 14.8 14.4 15.3 13.2 13.7 14.9 15.0 18.2 17.2 13.2
## [121] 15.8 13.3 17.2 13.9 15.7 16.4 13.8 14.0 14.8 16.0 16.3 18.1 14.8 14.2 14.3
## [136] 16.8 15.3 15.0 13.8 15.4 15.4 15.1 13.6 15.9 15.7 14.9 13.8 14.7 15.0 14.0
```

这时候我们可以用with进行变量掩蔽，就是一种省力的办法。


```r
with(data = iris, expr = Sepal.Length + Sepal.Width + Petal.Length)
```

```
##   [1] 10.0  9.3  9.2  9.2 10.0 11.0  9.4  9.9  8.7  9.5 10.6  9.8  9.2  8.4 11.0
##  [16] 11.6 10.6 10.0 11.2 10.4 10.5 10.3  9.2 10.1 10.1  9.6 10.0 10.2 10.0  9.5
##  [31]  9.5 10.3 10.8 11.1  9.5  9.4 10.3  9.9  8.7 10.0  9.8  8.1  8.9 10.1 10.8
##  [46]  9.2 10.5  9.2 10.5  9.7 14.9 14.1 14.9 11.8 13.9 13.0 14.3 10.6 14.1 11.8
##  [61] 10.5 13.1 12.2 13.7 12.1 14.2 13.1 12.6 12.9 12.0 13.9 12.9 13.7 13.6 13.6
##  [76] 14.0 14.4 14.7 13.4 11.8 11.7 11.6 12.4 13.8 12.9 13.9 14.5 13.0 12.7 12.0
##  [91] 12.5 13.7 12.4 10.6 12.5 12.9 12.8 13.4 10.6 12.6 15.6 13.6 16.0 14.8 15.3
## [106] 17.2 11.9 16.5 15.0 16.9 14.8 14.4 15.3 13.2 13.7 14.9 15.0 18.2 17.2 13.2
## [121] 15.8 13.3 17.2 13.9 15.7 16.4 13.8 14.0 14.8 16.0 16.3 18.1 14.8 14.2 14.3
## [136] 16.8 15.3 15.0 13.8 15.4 15.4 15.1 13.6 15.9 15.7 14.9 13.8 14.7 15.0 14.0
```

注意到tidyverse中也是基于这种原理。


```r
iris %>% 
  mutate(sum = Sepal.Length + Sepal.Width + Petal.Length)
```

```
##     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species  sum
## 1            5.1         3.5          1.4         0.2     setosa 10.0
## 2            4.9         3.0          1.4         0.2     setosa  9.3
## 3            4.7         3.2          1.3         0.2     setosa  9.2
## 4            4.6         3.1          1.5         0.2     setosa  9.2
## 5            5.0         3.6          1.4         0.2     setosa 10.0
## 6            5.4         3.9          1.7         0.4     setosa 11.0
## 7            4.6         3.4          1.4         0.3     setosa  9.4
## 8            5.0         3.4          1.5         0.2     setosa  9.9
## 9            4.4         2.9          1.4         0.2     setosa  8.7
## 10           4.9         3.1          1.5         0.1     setosa  9.5
## 11           5.4         3.7          1.5         0.2     setosa 10.6
## 12           4.8         3.4          1.6         0.2     setosa  9.8
## 13           4.8         3.0          1.4         0.1     setosa  9.2
## 14           4.3         3.0          1.1         0.1     setosa  8.4
## 15           5.8         4.0          1.2         0.2     setosa 11.0
## 16           5.7         4.4          1.5         0.4     setosa 11.6
## 17           5.4         3.9          1.3         0.4     setosa 10.6
## 18           5.1         3.5          1.4         0.3     setosa 10.0
## 19           5.7         3.8          1.7         0.3     setosa 11.2
## 20           5.1         3.8          1.5         0.3     setosa 10.4
## 21           5.4         3.4          1.7         0.2     setosa 10.5
## 22           5.1         3.7          1.5         0.4     setosa 10.3
## 23           4.6         3.6          1.0         0.2     setosa  9.2
## 24           5.1         3.3          1.7         0.5     setosa 10.1
## 25           4.8         3.4          1.9         0.2     setosa 10.1
## 26           5.0         3.0          1.6         0.2     setosa  9.6
## 27           5.0         3.4          1.6         0.4     setosa 10.0
## 28           5.2         3.5          1.5         0.2     setosa 10.2
## 29           5.2         3.4          1.4         0.2     setosa 10.0
## 30           4.7         3.2          1.6         0.2     setosa  9.5
## 31           4.8         3.1          1.6         0.2     setosa  9.5
## 32           5.4         3.4          1.5         0.4     setosa 10.3
## 33           5.2         4.1          1.5         0.1     setosa 10.8
## 34           5.5         4.2          1.4         0.2     setosa 11.1
## 35           4.9         3.1          1.5         0.2     setosa  9.5
## 36           5.0         3.2          1.2         0.2     setosa  9.4
## 37           5.5         3.5          1.3         0.2     setosa 10.3
## 38           4.9         3.6          1.4         0.1     setosa  9.9
## 39           4.4         3.0          1.3         0.2     setosa  8.7
## 40           5.1         3.4          1.5         0.2     setosa 10.0
## 41           5.0         3.5          1.3         0.3     setosa  9.8
## 42           4.5         2.3          1.3         0.3     setosa  8.1
## 43           4.4         3.2          1.3         0.2     setosa  8.9
## 44           5.0         3.5          1.6         0.6     setosa 10.1
## 45           5.1         3.8          1.9         0.4     setosa 10.8
## 46           4.8         3.0          1.4         0.3     setosa  9.2
## 47           5.1         3.8          1.6         0.2     setosa 10.5
## 48           4.6         3.2          1.4         0.2     setosa  9.2
## 49           5.3         3.7          1.5         0.2     setosa 10.5
## 50           5.0         3.3          1.4         0.2     setosa  9.7
## 51           7.0         3.2          4.7         1.4 versicolor 14.9
## 52           6.4         3.2          4.5         1.5 versicolor 14.1
## 53           6.9         3.1          4.9         1.5 versicolor 14.9
## 54           5.5         2.3          4.0         1.3 versicolor 11.8
## 55           6.5         2.8          4.6         1.5 versicolor 13.9
## 56           5.7         2.8          4.5         1.3 versicolor 13.0
## 57           6.3         3.3          4.7         1.6 versicolor 14.3
## 58           4.9         2.4          3.3         1.0 versicolor 10.6
## 59           6.6         2.9          4.6         1.3 versicolor 14.1
## 60           5.2         2.7          3.9         1.4 versicolor 11.8
## 61           5.0         2.0          3.5         1.0 versicolor 10.5
## 62           5.9         3.0          4.2         1.5 versicolor 13.1
## 63           6.0         2.2          4.0         1.0 versicolor 12.2
## 64           6.1         2.9          4.7         1.4 versicolor 13.7
## 65           5.6         2.9          3.6         1.3 versicolor 12.1
## 66           6.7         3.1          4.4         1.4 versicolor 14.2
## 67           5.6         3.0          4.5         1.5 versicolor 13.1
## 68           5.8         2.7          4.1         1.0 versicolor 12.6
## 69           6.2         2.2          4.5         1.5 versicolor 12.9
## 70           5.6         2.5          3.9         1.1 versicolor 12.0
## 71           5.9         3.2          4.8         1.8 versicolor 13.9
## 72           6.1         2.8          4.0         1.3 versicolor 12.9
## 73           6.3         2.5          4.9         1.5 versicolor 13.7
## 74           6.1         2.8          4.7         1.2 versicolor 13.6
## 75           6.4         2.9          4.3         1.3 versicolor 13.6
## 76           6.6         3.0          4.4         1.4 versicolor 14.0
## 77           6.8         2.8          4.8         1.4 versicolor 14.4
## 78           6.7         3.0          5.0         1.7 versicolor 14.7
## 79           6.0         2.9          4.5         1.5 versicolor 13.4
## 80           5.7         2.6          3.5         1.0 versicolor 11.8
## 81           5.5         2.4          3.8         1.1 versicolor 11.7
## 82           5.5         2.4          3.7         1.0 versicolor 11.6
## 83           5.8         2.7          3.9         1.2 versicolor 12.4
## 84           6.0         2.7          5.1         1.6 versicolor 13.8
## 85           5.4         3.0          4.5         1.5 versicolor 12.9
## 86           6.0         3.4          4.5         1.6 versicolor 13.9
## 87           6.7         3.1          4.7         1.5 versicolor 14.5
## 88           6.3         2.3          4.4         1.3 versicolor 13.0
## 89           5.6         3.0          4.1         1.3 versicolor 12.7
## 90           5.5         2.5          4.0         1.3 versicolor 12.0
## 91           5.5         2.6          4.4         1.2 versicolor 12.5
## 92           6.1         3.0          4.6         1.4 versicolor 13.7
## 93           5.8         2.6          4.0         1.2 versicolor 12.4
## 94           5.0         2.3          3.3         1.0 versicolor 10.6
## 95           5.6         2.7          4.2         1.3 versicolor 12.5
## 96           5.7         3.0          4.2         1.2 versicolor 12.9
## 97           5.7         2.9          4.2         1.3 versicolor 12.8
## 98           6.2         2.9          4.3         1.3 versicolor 13.4
## 99           5.1         2.5          3.0         1.1 versicolor 10.6
## 100          5.7         2.8          4.1         1.3 versicolor 12.6
## 101          6.3         3.3          6.0         2.5  virginica 15.6
## 102          5.8         2.7          5.1         1.9  virginica 13.6
## 103          7.1         3.0          5.9         2.1  virginica 16.0
## 104          6.3         2.9          5.6         1.8  virginica 14.8
## 105          6.5         3.0          5.8         2.2  virginica 15.3
## 106          7.6         3.0          6.6         2.1  virginica 17.2
## 107          4.9         2.5          4.5         1.7  virginica 11.9
## 108          7.3         2.9          6.3         1.8  virginica 16.5
## 109          6.7         2.5          5.8         1.8  virginica 15.0
## 110          7.2         3.6          6.1         2.5  virginica 16.9
## 111          6.5         3.2          5.1         2.0  virginica 14.8
## 112          6.4         2.7          5.3         1.9  virginica 14.4
## 113          6.8         3.0          5.5         2.1  virginica 15.3
## 114          5.7         2.5          5.0         2.0  virginica 13.2
## 115          5.8         2.8          5.1         2.4  virginica 13.7
## 116          6.4         3.2          5.3         2.3  virginica 14.9
## 117          6.5         3.0          5.5         1.8  virginica 15.0
## 118          7.7         3.8          6.7         2.2  virginica 18.2
## 119          7.7         2.6          6.9         2.3  virginica 17.2
## 120          6.0         2.2          5.0         1.5  virginica 13.2
## 121          6.9         3.2          5.7         2.3  virginica 15.8
## 122          5.6         2.8          4.9         2.0  virginica 13.3
## 123          7.7         2.8          6.7         2.0  virginica 17.2
## 124          6.3         2.7          4.9         1.8  virginica 13.9
## 125          6.7         3.3          5.7         2.1  virginica 15.7
## 126          7.2         3.2          6.0         1.8  virginica 16.4
## 127          6.2         2.8          4.8         1.8  virginica 13.8
## 128          6.1         3.0          4.9         1.8  virginica 14.0
## 129          6.4         2.8          5.6         2.1  virginica 14.8
## 130          7.2         3.0          5.8         1.6  virginica 16.0
## 131          7.4         2.8          6.1         1.9  virginica 16.3
## 132          7.9         3.8          6.4         2.0  virginica 18.1
## 133          6.4         2.8          5.6         2.2  virginica 14.8
## 134          6.3         2.8          5.1         1.5  virginica 14.2
## 135          6.1         2.6          5.6         1.4  virginica 14.3
## 136          7.7         3.0          6.1         2.3  virginica 16.8
## 137          6.3         3.4          5.6         2.4  virginica 15.3
## 138          6.4         3.1          5.5         1.8  virginica 15.0
## 139          6.0         3.0          4.8         1.8  virginica 13.8
## 140          6.9         3.1          5.4         2.1  virginica 15.4
## 141          6.7         3.1          5.6         2.4  virginica 15.4
## 142          6.9         3.1          5.1         2.3  virginica 15.1
## 143          5.8         2.7          5.1         1.9  virginica 13.6
## 144          6.8         3.2          5.9         2.3  virginica 15.9
## 145          6.7         3.3          5.7         2.5  virginica 15.7
## 146          6.7         3.0          5.2         2.3  virginica 14.9
## 147          6.3         2.5          5.0         1.9  virginica 13.8
## 148          6.5         3.0          5.2         2.0  virginica 14.7
## 149          6.2         3.4          5.4         2.3  virginica 15.0
## 150          5.9         3.0          5.1         1.8  virginica 14.0
```

### 字符串操作

这里只简单的演示操作。


```r
a = c("北京", "欢迎", "你")
b = c("为你", "开天", "辟地")

# paste与stringr中的str_c等价
paste(a, b)
```

```
## [1] "北京 为你" "欢迎 开天" "你 辟地"
```

下二者等价


```r
paste(a, b, sep = "")
```

```
## [1] "北京为你" "欢迎开天" "你辟地"
```

```r
paste0(a, b)
```

```
## [1] "北京为你" "欢迎开天" "你辟地"
```

下二者等价


```r
paste(a, collapse = "")
```

```
## [1] "北京欢迎你"
```

```r
paste0(a, collapse = "")
```

```
## [1] "北京欢迎你"
```

```r
paste(paste(a, collapse = ""), paste(b, collapse = ""), sep = ", ")
```

```
## [1] "北京欢迎你, 为你开天辟地"
```

```r
str_c(a, b)
```

```
## [1] "北京为你" "欢迎开天" "你辟地"
```

### grep

grep显示匹配的位次，grepl显示每个位次是否匹配。

```r
grep("北", a)
```

```
## [1] 1
```

```r
grep("你", a)
```

```
## [1] 3
```

```r
grepl("你", a)
```

```
## [1] FALSE FALSE  TRUE
```

下二者等价


```r
grep("你", a)
```

```
## [1] 3
```

```r
which(grepl("你", a))
```

```
## [1] 3
```

str_detect与grepl等价，但是顺序不同，更方便tidy写法。


```r
str_detect(a, "北")
```

```
## [1]  TRUE FALSE FALSE
```

### substr

str_sub支持负数索引，更有用。


```r
substr("北京欢迎你", start = 3, stop = 4)
```

```
## [1] "欢迎"
```

```r
str_sub("北京欢迎你", start = 3, end = -2)
```

```
## [1] "欢迎"
```

### 正则表达式与str_extract


```r
c = c("《北京欢迎你》是由林夕作词，小柯作曲，百位明星共同演唱的一首以奥运为主题的歌曲，发行于2008年4月30日。", 
      "2009年这首歌曲成为MusicRadio音乐之声点播冠军曲。")
# 下面这两个最上面只匹配一次，下面的匹配全部
str_extract(c, "\\d+")
```

```
## [1] "2008" "2009"
```

```r
str_extract_all(c, "\\d+")
```

```
## [[1]]
## [1] "2008" "4"    "30"  
## 
## [[2]]
## [1] "2009"
```

```r
# baseR的实现困难一些
regmatches(c, gregexpr("\\d+", c, perl = TRUE))
```

```
## [[1]]
## [1] "2008" "4"    "30"  
## 
## [[2]]
## [1] "2009"
```

### str_subset

可以用于匹配符号条件的字符。


```r
grep("欢", a, value = T)
```

```
## [1] "欢迎"
```

```r
str_subset(a, "欢")
```

```
## [1] "欢迎"
```

### str_split


```r
genes = c("LOC441259 /// POLR2J2", "KLHDC7B", "ATAD3A /// ATAD3B /// LOC732419") 
strsplit(genes, " /// ")
```

```
## [[1]]
## [1] "LOC441259" "POLR2J2"  
## 
## [[2]]
## [1] "KLHDC7B"
## 
## [[3]]
## [1] "ATAD3A"    "ATAD3B"    "LOC732419"
```

简而言之，stringr中的字符串操作命名统一一点，功能多一点，没比BaseR强在功能上。


```r
str_split(genes, " /// ")
```

```
## [[1]]
## [1] "LOC441259" "POLR2J2"  
## 
## [[2]]
## [1] "KLHDC7B"
## 
## [[3]]
## [1] "ATAD3A"    "ATAD3B"    "LOC732419"
```

```r
str_split(genes, " /// ", simplify = T)
```

```
##      [,1]        [,2]      [,3]       
## [1,] "LOC441259" "POLR2J2" ""         
## [2,] "KLHDC7B"   ""        ""         
## [3,] "ATAD3A"    "ATAD3B"  "LOC732419"
```

## 实战


```r
#有数据如下
#   type
# 1 a, b
# 2    -
# 3    a
#需统计其出现位置，如下
#      a b -
# [1,] 1 1 0
# [2,] 0 0 1
# [3,] 1 0 0

data = data.frame(type = c("a, b", "-", "a"))
```

可采用以下若干方法

### 1. 向量化


```r
type = data$type %>% 
  unique() %>% 
  str_split(", ") %>% 
  unlist() %>% 
  unique()
```

下面这种写法利用了R的参数传递机制。灵活、强大，表现为把传参过程写在函数的外面。但是有一些特定用途，比如说多个函数依赖于同一个参数，在后面的进阶章节学习到R的参数传递机制时会重点讲述。


```r
sapply(type, \(x, invec) as.numeric(grepl(x, invec)), invec = data$type)
```

```
##      a b -
## [1,] 1 1 0
## [2,] 0 0 1
## [3,] 1 0 0
```

在没有上述特定情况下，个人更喜欢以下写法


```r
sapply(type, \(x, invec = data$type) as.numeric(grepl(x, invec)))
```

```
##      a b -
## [1,] 1 1 0
## [2,] 0 0 1
## [3,] 1 0 0
```

像下面这样写也是可以的，但是我不喜欢，我觉得怪怪的,就是说内部的环境可以使用全局环境的变量，但是全局的不能使用内部的。就是说儿子能找爸借钱，爸不能找儿子借钱，后面的进阶章节学习到R的环境会重点讲述。


```r
sapply(type, \(x) as.numeric(grepl(x, data$type)))
```

```
##      a b -
## [1,] 1 1 0
## [2,] 0 0 1
## [3,] 1 0 0
```

map函数同样可以，不过需要提前命名map函数是purrr中的函数，相当于apply函数簇的拓展，用法相似.


```r
names(type) = type
map(type, \(x, invec = data$type) as.numeric(grepl(x, invec))) %>% 
  as_tibble()
```

```
## # A tibble: 3 × 3
##       a     b   `-`
##   <dbl> <dbl> <dbl>
## 1     1     1     0
## 2     0     0     1
## 3     1     0     0
```

map + 后缀意味着指定输出的格式。


```r
map_dfc(type, \(x, invec = data$type) as.numeric(grepl(x, invec)))
```

```
## # A tibble: 3 × 3
##       a     b   `-`
##   <dbl> <dbl> <dbl>
## 1     1     1     0
## 2     0     0     1
## 3     1     0     0
```

purrr的匿名函数设计中因为没有显式的传参，所以只能用于单个参数，剩下一个参数只能从全局调用，等同于上述的那种写法。


```r
map_dfc(type, ~ as.numeric(grepl(.x, data$type)))
```

```
## # A tibble: 3 × 3
##       a     b   `-`
##   <dbl> <dbl> <dbl>
## 1     1     1     0
## 2     0     0     1
## 3     1     0     0
```

### 2. tibble的nested tibble性质

tibble拓展了dataframe的范围，支持储存列表，甚至套娃另一个df。


```r
data %>%
  as_tibble() %>% 
  mutate(
    y = str_split(type, ", "), 
    y = map(y, ~ set_names(.x, .x))) %>% 
  unnest_wider(y) %>% 
  mutate(across(-type, ~ ifelse(is.na(.x), 0, 1)))
```

```
## # A tibble: 3 × 4
##   type      a     b   `-`
##   <chr> <dbl> <dbl> <dbl>
## 1 a, b      1     1     0
## 2 -         0     0     1
## 3 a         1     0     0
```

### 3. dataframe操作

利用tibble的性质确实有些超模了，只利用tidyr的数据框操作也可以。如果想单纯的使用mutate解决，无疑就陷入了误区，但是思路比较刁钻。


```r
data %>% 
  mutate(id = type, value = 1) %>% 
  separate_rows(type, sep = ", ") %>% 
  pivot_wider(names_from = type, values_from = value, values_fill = 0)
```

```
## # A tibble: 3 × 4
##   id        a     b   `-`
##   <chr> <dbl> <dbl> <dbl>
## 1 a, b      1     1     0
## 2 -         0     0     1
## 3 a         1     0     0
```

### 4. 循环


```r
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
```

```
##   a b X.
## 1 1 1  0
## 2 0 0  1
## 3 1 0  0
```







