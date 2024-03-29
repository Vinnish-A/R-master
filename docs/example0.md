---
title: "R语言高手计划"
author: "Vinnish   普尔弥什"
site: bookdown::bookdown_site
output: bookdown::git_book
documentclass: book
bibliography: "first try.bib"
csl: "ncb.csl"
link-citations: true
description: "Med-X社员手册"
github-repo: Vinnish-A/R-master
---



# 预备

## 工作环境 

1. 卸载掉不需要的软件后，确认工作环境清洁（如果C盘够大，软件可以装C盘，如果C盘不大，最好把软件迁移到别的盘，C盘满了电脑无法启动；把数据、软件、游戏分开储存；最好将电脑的用户路径改为英文，否则无法编译部分程序和latex），安装编程语言：R软件、R的集成开发环境：Rstudio
2. 学习如何使用R安装R的软件包。首先是学会配置Cran和Bioconductor的镜像。然后是尝试从cran、github、bioconductor三种途径，安装上tidyverse、mlr3verse、mlr3proba、annoprobe等包。

参考书目：

- [R语言教程——基于tidyverse]()
- [R语言教程——北大数院]()
- [mlr3教学ppt]()

## 使用project管理项目

`Rproject`是用于管理代码和数据的方法。当你点开Rproj文件后，会打开Rstudio，并自动设置路径在Rproj文件所在的目录，一个健康的、便于管理的项目的项目目录应该是这样的：代码和代码放一块，数据和数据放一块。


```r
knitr::include_graphics('F:/0Local/project/R-master/pic/filetree.bmp')
```

<img src="pic/filetree.bmp" style="display: block; margin: auto;" />

在左上角的File里创建New Project，学习怎么使用Rproject[链接](https://zhuanlan.zhihu.com/p/630825871)。

## 使用git进行团队协作和文件管理

git教程见[廖雪峰的git教程](https://www.liaoxuefeng.com/wiki/896043488029600)。重点学习使用`git remote`、`git push`、`git colne`、`git branch`这几个功能。

## 安装R包的终极解决方案

包有三个来源：cran、bioconductor、github，每个都有对应的途径安装，见[网络教程](https://zhuanlan.zhihu.com/p/129069910)。

cran和bioconductor上的R包都经过了严格的审查，因此质量较高，安装也十分简便。其中bioconductor寄存了一系列生物数据的接口和处理流程，十分重要，但是win10和win11安装bioconductor可能遇到难以解决的网络代理问题。

这个时候，手动安装也是个办法，手动安装的方法见[网络教程](https://zhuanlan.zhihu.com/p/343305532)，这里也可以使用`devtools::install_local()`。

但是手动装包一次只能装一个，适用于不太复杂的小包。如果这个包存在许多依赖，可以使用`pak::pak("packge")`作为R包安装的终极解决方案。

## 第一周

### 目标

第一周是学习常见文件拓展名比如txt、csv、tsv的意义。使用tidyverse的read_csv或原生的read.csv等函数读入文件为数据框，然后跟着参考书籍学习使用tidyverse的select、filter、mutate、across、group_by、summarise等函数，并且用r原生的方法实现以上这些函数的功能，主要是数据选择、筛选、修改、汇总四个部分。

### 示例及任务

示例见example1.R

在内置数据集airquality中，进行

1. 查看每列的缺失值个数
2. 使用每列的平均值对缺失值进行填补（注意mean函数和na）
3. 汇总显示Ozone到Temp列每月的平均值

tidyverse是相对独立于base的R的一种方言，是一门专门操作文件（在R中表现为数据框）的语言，本章的目的在于希望来者能认识数据，认知掌握如何操作数据框，培养数据意识。

## 第二周

### 目标

第二周是对R的基础与特征的学习：

1. r中的数值运算符号，如 + - * ** / //等
2. r中的逻辑运算符号，如 ! & |等
3. r的控制结构，如if for循环（在数据科学中数量掌握这两个可以应对90%的情况）
4. r的索引方法，如 $ [] [[]]等
5. r的特点，向量化（需要一定的线性代数知识，对矩阵乘法有个印象就够了），重点学习apply函数簇中的apply和lapply函数

内容较杂，希望一定要借助chatgpt来学习。

### 示例及任务

示例见example2.R

我设计了一个函数，目的是将每个位次上字符的频率视作概率，重新生成一定数量的序列，求问为什么函数一可以运行而函数二会报错？


```r
data_task = readRDS("./data/示例数据.Rds")
head(data_task)
```

```
## # A tibble: 6 × 14
##   A6    A5    A4    A3    A2    A1    G6    G5    G4    G3    G2    G1   
##   <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct>
## 1 R     A     Q     L     S     Q     X     A     X     L     S     X    
## 2 A     A     Q     L     S     Q     A     A     X     L     S     X    
## 3 C     A     Q     L     S     Q     S     A     X     L     S     X    
## 4 D     A     Q     L     S     Q     N     A     X     L     S     X    
## 5 E     A     Q     L     S     Q     X     A     X     L     S     X    
## 6 F     A     Q     L     S     Q     F     A     X     L     S     X    
## # ℹ 2 more variables: Activity <dbl>, Selectivity <dbl>
```

```r
generator_1 = function(sample_space, num) {
  
  # 计算类别A中每个种类的构成
  sample_list_1 = sample_space %>% 
    select(matches("A"), -Activity) %>% 
    lapply(\(vec) table(vec)/length(vec))
  
  # 计算类别G中每个种类的构成
  sample_list_2 = sample_space %>% 
    select(matches("G")) %>% 
    lapply(\(vec) table(vec)/length(vec)) 
  
  # 采用递归方法连接字符串
  seq1 = Reduce(paste0, lapply(sample_list_1, \(.x) sample(names(.x), num, T, .x)))
  seq2 = Reduce(paste0, lapply(sample_list_2, \(.x) sample(names(.x), num, T, .x)))
  
  list(Sequence1 = seq1, Sequnce2 = seq2)
  
}

# 为什么1能运行2运行不了呢？
generator_2 = function(sample_space, num) {
  
  # 计算类别A中每个种类的构成
  sample_list_1 = sample_space %>% 
    select(matches("A"), -Activity) %>% 
    apply(2, \(vec) table(vec)/length(vec))
  
  # 计算类别G中每个种类的构成
  sample_list_2 = sample_space %>% 
    select(matches("G")) %>% 
    apply(2, \(vec) table(vec)/length(vec)) 
  
  # 采用递归方法连接字符串
  seq1 = Reduce(paste0, lapply(sample_list_1, \(.x) sample(names(.x), num, T, .x)))
  seq2 = Reduce(paste0, lapply(sample_list_2, \(.x) sample(names(.x), num, T, .x)))
  
  list(Sequence1 = seq1, Sequnce2 = seq2)
  
}
```

本章的目的是令来者学习R的基本数据结构和控制结构，属于Rbase的部分，非常基础。

## 第三周

### 目标

第三周主要是浅尝R中的各类函数与实战

R中的字符串操作。包括：

1. base中的paste, paste0, grep与grepl函数、stringr中的str_c, str_dectet, str_sub, str_extract等函数。
2. 熟悉正则表达式（不需要了解，只需要对相关概念有印象）。（3）熟悉with函数的变量掩蔽概念（不需要了解，只需要知道为什么有的地方可以不用字符串）。

R中的建模函数。包括：

1. 学习base中的公式语法
2. 学习lm与glm函数，尝试使用lm进行简单线性回归，使用glm进行逻辑回归。

另外，这周还需要学习部分理论知识，包括：

回归与分类的概念。熟悉简单线性回归，多元线性回归，逻辑回归和k近邻分类（不需要了解和推导，只需要建立起概念）。参考书目为[台大生物统计课程](https://youtube.com/playlist?list=PLTp0eSi9MdkNZB4kyLSzIXIUy9JQOJ5AM&si=6jb8kKh_LoXWflrh)和课本[回归分析]()（当然也可以自己搜集资料）。

另外，线性代数的学习也需要加紧。

### 示例及任务

示例见example3.R

有数据形如下


```{=html}
<div class="datatables html-widget html-fill-item" id="htmlwidget-8535dedcfb4d7ab6a986" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-8535dedcfb4d7ab6a986">{"x":{"filter":"none","vertical":false,"data":[["1","2","3"],["chrM","chrM","chrM"],["ncbiRefSeq.2021-04-23","ncbiRefSeq.2021-04-23","ncbiRefSeq.2021-04-23"],["transcript","exon","transcript"],[15356,15356,15289],[15422,15422,15355],[".",".","."],["-","-","+"],[".",".","."],["gene_id \"TrnP\"; transcript_id \"rna-TrnP\";  gene_name \"TrnP\";","gene_id \"TrnP\"; transcript_id \"rna-TrnP\"; exon_number \"1\"; exon_id \"rna-TrnP.1\"; gene_name \"TrnP\";","gene_id \"TrnT\"; transcript_id \"rna-TrnT\";  gene_name \"TrnT\";"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>X1<\/th>\n      <th>X2<\/th>\n      <th>X3<\/th>\n      <th>X4<\/th>\n      <th>X5<\/th>\n      <th>X6<\/th>\n      <th>X7<\/th>\n      <th>X8<\/th>\n      <th>X9<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"columnDefs":[{"className":"dt-right","targets":[4,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

按要求要求整理成如下形式：

1. 只保留编码区域（CDS）内的基因，或者一段基因的转录本（== "transcript"或== "CDS"）
2. 提取基因id、基因name、转录本id
3. 只保留每个基因中长度最长的片段，无论是CDS还是transcript


```{=html}
<div class="datatables html-widget html-fill-item" id="htmlwidget-9db3f3398242505031ef" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-9db3f3398242505031ef">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["chrM","chrM","chrM","chrM","chrM","chrM"],["transcript","transcript","transcript","transcript","transcript","transcript"],[7927,7766,5328,7013,8607,14145],[8607,7969,6872,7696,9390,15288],["+","+","+","+","+","+"],["ATP6","ATP8","COX1","COX2","COX3","CYTB"],["NP_904333.1","NP_904332.1","NP_904330.1","NP_904331.1","NP_904334.1","NP_904340.1"],[680,203,1544,683,783,1143]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>chr<\/th>\n      <th>type<\/th>\n      <th>start<\/th>\n      <th>end<\/th>\n      <th>strand<\/th>\n      <th>gene_id<\/th>\n      <th>transcript_id<\/th>\n      <th>length<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"scrollX":true,"columnDefs":[{"className":"dt-right","targets":[3,4,8]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```

本人给出的任务和示例是R语言基础的部分提纲。之后对于R语言除巩固基础外，更多的是在实战中熟悉R语言生态（评价一个人代码能力的不是一个人基础多好，而是这个人对这门语言的生态有多了解、会用多少的包、脑中有多少编程范式，从而高效的解决自己遇到的问题。但是对于基础的掌握会让你更快熟悉另一门语言，因为基础总是相通的。

## 第四周

### 目标

第四周的学习任务主要是：

1. 熟悉决策树这类树模型，熟悉基于树的统计学习方法，包括随机森林和GBDT模型。
2. 熟悉主要的预测结果的评价指标，包括回归的指标mse、rmse，分类的指标信息熵、交叉熵等。着重学习二分类的分类指标ROC曲线。
3. 熟悉mlr3机器学习框架。学会创建task、学习器，简单的训练学习器并预测。

### 示例及任务

示例见example4.R，example5.R

example4.R是我总结的学习mlr3基础期间的常见误区，值得学习！

限时挑战（本周）：设计r程序，计算roc曲线的auc（参考r语言教程基于tidyverse中序章部分和task3）。

如果学会了简单（多元）线性回归和逻辑回归（最简单的回归和分类任务），知道从表格型数据得到回归或分类预测结果的数据形式，那么就使用更复杂的模型而言，就不存在问题了。












