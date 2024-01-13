


# 初探mlr3

机器学习/深度学习的边际效益极低，一个人只需要两个星期就可以写出能实现我能写出的模型百分之九十甚至以上效果的模型。


```r
lrns() # 查看学习器
```

```
## <DictionaryLearner> with 141 stored values
## Keys: classif.abess, classif.AdaBoostM1, classif.bart, classif.C50,
##   classif.catboost, classif.cforest, classif.ctree, classif.cv_glmnet,
##   classif.debug, classif.earth, classif.featureless, classif.fnn,
##   classif.gam, classif.gamboost, classif.gausspr, classif.gbm,
##   classif.glmboost, classif.glmer, classif.glmnet, classif.IBk,
##   classif.imbalanced_rfsrc, classif.J48, classif.JRip, classif.kknn,
##   classif.ksvm, classif.lda, classif.liblinear, classif.lightgbm,
##   classif.LMT, classif.log_reg, classif.lssvm, classif.mob,
##   classif.multinom, classif.naive_bayes, classif.nnet, classif.OneR,
##   classif.PART, classif.priority_lasso, classif.qda,
##   classif.randomForest, classif.ranger, classif.rfsrc, classif.rpart,
##   classif.svm, classif.xgboost, clust.agnes, clust.ap, clust.cmeans,
##   clust.cobweb, clust.dbscan, clust.diana, clust.em, clust.fanny,
##   clust.featureless, clust.ff, clust.hclust, clust.kkmeans,
##   clust.kmeans, clust.MBatchKMeans, clust.mclust, clust.meanshift,
##   clust.pam, clust.SimpleKMeans, clust.xmeans, dens.kde_ks,
##   dens.locfit, dens.logspline, dens.mixed, dens.nonpar, dens.pen,
##   dens.plug, dens.spline, regr.abess, regr.bart, regr.catboost,
##   regr.catboost_modified, regr.cforest, regr.ctree, regr.cubist,
##   regr.cv_glmnet, regr.debug, regr.earth, regr.featureless, regr.fnn,
##   regr.gam, regr.gamboost, regr.gausspr, regr.gbm, regr.glm,
##   regr.glmboost, regr.glmnet, regr.IBk, regr.kknn, regr.km, regr.ksvm,
##   regr.liblinear, regr.lightgbm, regr.lm, regr.lmer, regr.M5Rules,
##   regr.mars, regr.mob, regr.nnet, regr.priority_lasso,
##   regr.randomForest, regr.ranger, regr.rfsrc, regr.rpart, regr.rsm,
##   regr.rvm, regr.svm, regr.xgboost, surv.akritas, surv.aorsf,
##   surv.blackboost, surv.cforest, surv.coxboost, surv.coxtime,
##   surv.ctree, surv.cv_coxboost, surv.cv_glmnet, surv.deephit,
##   surv.deepsurv, surv.dnnsurv, surv.flexible, surv.gamboost, surv.gbm,
##   surv.glmboost, surv.glmnet, surv.loghaz, surv.mboost, surv.nelson,
##   surv.obliqueRSF, surv.parametric, surv.pchazard, surv.penalized,
##   surv.priority_lasso, surv.ranger, surv.rfsrc, surv.svm, surv.xgboost
```

```r
lrn_c_ranger = lrn("classif.ranger") # 随机森林 分类学习器
lrn_r_ranger = lrn("regr.ranger") # 随机森林 回归学习器

tsks() # 查看自带任务
```

```
## <DictionaryTask> with 21 stored values
## Keys: ames_housing, bike_sharing, boston_housing, breast_cancer,
##   german_credit, ilpd, iris, kc_housing, moneyball, mtcars, optdigits,
##   penguins, penguins_simple, pima, ruspini, sonar, spam, titanic,
##   usarrests, wine, zoo
```

```r
tsk_c = tsk("titanic") # 二分类任务
tsk_r = tsk("boston_housing") # 回归任务

tsk_c$missings()
```

```
## survived      age    cabin embarked     fare     name    parch   pclass 
##      418      263     1014        2        1        0        0        0 
##      sex   sib_sp   ticket 
##        0        0        0
```

```r
tsk_r$missings()
```

```
##   cmedv     age       b    chas    crim     dis   indus     lat     lon   lstat 
##       0       0       0       0       0       0       0       0       0       0 
##     nox ptratio     rad      rm     tax    town   tract      zn 
##       0       0       0       0       0       0       0       0
```

```r
tsk_c$data() |> View()
```

mlr3是基于R6对象开发的，R6对象和其它语言的面向对象形式十分相似，面向对象中一个显著的特点是把数据和操纵数据的方法结合到一起。


```r
#比如说以下我们用tsk_c$filter(useful_sample)就已经筛选了满足条件的行，而不需要tsk_c = tsk_c$filter(useful_sample)的形式用赋值符号链接，可以简单的把面向对象理解成“自成体系”，就是用对象内部的函数处理对象内部的数据。

useful_sample = which(!is.na(tsk_c$data()$survived)) 
# 这段函数是不是看起来十分抽象？
```


```r
tsk_c$filter(useful_sample)

tsk_c$missings()
```

```
## survived      age    cabin embarked     fare     name    parch   pclass 
##        0      177      687        2        0        0        0        0 
##      sex   sib_sp   ticket 
##        0        0        0
```

```r
tsk_c$feature_types # 查看每列特征的类型
```

```
##           id      type
##  1:      age   numeric
##  2:    cabin character
##  3: embarked    factor
##  4:     fare   numeric
##  5:     name character
##  6:    parch   integer
##  7:   pclass   ordered
##  8:      sex    factor
##  9:   sib_sp   integer
## 10:   ticket character
```

```r
col_not_cha = tsk_c$feature_types$id[tsk_c$feature_types$type != "character"] # 为字符类型的列，去掉
tsk_c$select(col_not_cha)

tsk_c$col_info # 查看每列特征的类型
```

```
##           id      type      levels label fix_factor_levels
##  1: ..row_id   integer              <NA>             FALSE
##  2:      age   numeric              <NA>             FALSE
##  3:    cabin character              <NA>             FALSE
##  4: embarked    factor       C,Q,S  <NA>             FALSE
##  5:     fare   numeric              <NA>             FALSE
##  6:     name character              <NA>             FALSE
##  7:    parch   integer              <NA>             FALSE
##  8:   pclass   ordered       1,2,3  <NA>             FALSE
##  9:      sex    factor female,male  <NA>             FALSE
## 10:   sib_sp   integer              <NA>             FALSE
## 11: survived    factor      yes,no  <NA>              TRUE
## 12:   ticket character              <NA>             FALSE
```

```r
tsk_c$missings()
```

```
## survived      age embarked     fare    parch   pclass      sex   sib_sp 
##        0      177        2        0        0        0        0        0
```

```r
# 注意到embarked是多分类因子，需要编码，且数据中含有缺失值，进行特征工程
```

## mlr3中使用po()进行特征工程


```r
preprocess_pipe1 = po("imputemode") # 使用众数插补
preprocess_pipe1$train(list(tsk_c))
```

```
## $output
## <TaskClassif:titanic> (891 x 8): Titanic
## * Target: survived
## * Properties: twoclass
## * Features (7):
##   - dbl (2): age, fare
##   - fct (2): embarked, sex
##   - int (2): parch, sib_sp
##   - ord (1): pclass
```

```r
tsk_c_imputed = preprocess_pipe1$predict(list(tsk_c))[[1]]
tsk_c_imputed$missings() # 插补好了
```

```
## survived     fare    parch   pclass      sex   sib_sp      age embarked 
##        0        0        0        0        0        0        0        0
```

但是实际过程中一般不采用众数或者常数插补，一般将利用其它特征训练一个学习器用于插补缺失值，参考mlr3的ppt。

多个po可以用 %>>% 连接起来


```r
preprocess_pipe2 = 
  po("imputemode") %>>%
  po("encode", method = "one-hot") 
preprocess_pipe2$train(tsk_c)
```

```
## $encode.output
## <TaskClassif:titanic> (891 x 13): Titanic
## * Target: survived
## * Properties: twoclass
## * Features (12):
##   - dbl (10): age, embarked.C, embarked.Q, embarked.S, fare, pclass.1,
##     pclass.2, pclass.3, sex.female, sex.male
##   - int (2): parch, sib_sp
```

onehot编码即独热编码，是将分类变量化作数值变量的一种方法,看到这里你可能很迷惑，为什么上面要括号底下不要？

这里是mlr3作者偷了懒，大家只要记得一个po要list括起来，多个po不要,以及一定要记得，最后返回的是一个列表，所以结尾要加个[[1]]提取结果。


```r
tsk_c_imputed_expanded = preprocess_pipe2$predict(tsk_c)[[1]]
```

以下简单演示一下学习器插补，这里是有坑的，后面可以参考避坑。

都用决策树用来插补，回归学习器用来插补数值变量，分类学习器插补因子，这里的两个坑，一是不同学习器必须有不同的id，二是必须严格指明影响的范围。


```r
preprocess_pipe0 = 
  po("imputelearner", id = "num", lrn("regr.rpart"), affect_columns = selector_type("numeric")) %>>%
  po("imputelearner", id = "fct", lrn("classif.rpart"), affect_columns = selector_type("factor"))
```

现在我们有了良好的数据，但是我们还需要将数据划分为训练集和测试集，前者用于训练模型，后者用于评估模型效果。


```r
split_c = partition(tsk_c_imputed_expanded, ratio = 0.7)
split_r = partition(tsk_r, ratio = 0.7) # 三七划分
split_c$train # 其实就是个列表
```

```
##   [1]   1   5   6   7   8  13  15  17  25  28  30  31  34  35  36  38  39  43
##  [19]  46  47  49  50  51  52  55  58  60  61  63  64  65  68  70  71  72  73
##  [37]  74  76  77  78  84  87  88  91  93  94  97 100 101 103 104 105 106 109
##  [55] 111 113 114 117 118 119 120 122 130 131 133 135 138 139 140 141 145 146
##  [73] 148 150 151 155 158 159 160 161 165 168 169 172 174 175 176 177 178 179
##  [91] 180 181 182 183 186 190 192 197 198 200 201 202 204 206 207 211 213 214
## [109] 215 218 220 222 223 226 228 229 230 232 233 235 236 237 240 243 244 245
## [127] 246 251 253 263 264 267 271 274 277 278 283 285 288 293 294 297 298 303
## [145] 305 314 315 333 334 337 340 343 345 350 351 352 356 358 361 362 363 364
## [163] 366 372 373 374 379 380 385 386 387 389 393 397 398 402 403 404 405 406
## [181] 407 409 411 412 414 416 420 421 423 425 426 429 434 435 437 440 442 443
## [199] 452 453 455 457 460 464 465 466 467 475 476 477 478 479 481 482 483 486
## [217] 491 492 493 494 498 500 503 512 515 516 518 520 525 526 529 533 535 537
## [235] 539 543 545 546 558 564 565 566 568 569 576 579 584 589 590 591 594 595
## [253] 596 598 599 602 604 606 607 612 614 617 618 620 621 624 625 627 630 632
## [271] 639 643 647 649 651 653 656 657 660 662 663 666 667 668 672 673 675 679
## [289] 681 683 684 686 687 688 695 696 697 699 705 706 712 714 715 716 722 723
## [307] 724 726 729 732 734 735 736 739 740 742 744 747 750 753 754 757 758 759
## [325] 761 762 767 769 770 773 777 779 783 784 785 790 791 792 794 795 799 800
## [343] 801 806 807 809 811 813 814 815 816 818 819 820 823 833 834 835 837 841
## [361] 842 844 846 847 848 849 851 852 853 860 861 862 864 868 869 871 873 878
## [379] 879 882 883 885 887 889   2   3   4  10  11  16  18  22  23  24  26  29
## [397]  32  33  37  40  44  45  48  53  62  66  67  75  79  80  85  86  89  98
## [415]  99 108 126 128 129 134 137 142 143 147 152 167 173 184 185 187 188 191
## [433] 194 195 196 199 205 209 210 216 217 221 225 231 234 242 248 249 256 257
## [451] 258 259 260 269 270 272 275 284 287 289 290 291 292 299 300 301 306 307
## [469] 308 311 312 316 317 319 323 326 329 330 331 335 338 342 347 348 359 360
## [487] 368 376 381 382 392 408 413 417 418 427 428 430 431 432 433 438 446 447
## [505] 448 449 454 456 459 473 474 487 497 505 507 508 510 511 513 517 521 524
## [523] 527 531 534 536 538 540 541 544 547 548 550 551 554 559 560 570 571 572
## [541] 573 574 577 588 592 600 605 608 609 610 613 616 619 622 623 628 633 636
## [559] 642 644 645 646 652 654 665 670 671 674 678 680 690 693 701 707 710 713
## [577] 717 721 725 727 728 731 738 741 743 745 748 755 756 760 763 764 766 775
## [595] 778 780 782 787 789 797 798 802 804 810 821 822 824 828 829 831 832 836
## [613] 843 854 857 859 863 867 870 876 880 881 890
```

然后给列标注上训练和测试的信息，有两种方式。我们上面提到面向对象具有不需要赋值的特点，但是有的时候我们不得不赋值，可以采用新建一个对象，即内部的clone方法。


```r
tsk_c_imputed_expanded$set_row_roles(split_c$test, roles = "test") 
# 这个是旧方法，新版本用不到了，但是有特定的用途，后面介绍早停的时候会用到
tsk_r_train = tsk_r$clone(deep = T)$filter(split_r$train)
tsk_r_test = tsk_r$clone(deep = T)$filter(split_r$test)
```

同理，训练和预测也是两种方法


```r
lrn_c_ranger$train(tsk_c_imputed_expanded, row_ids = split_c$train)
lrn_c_ranger$predict(tsk_c_imputed_expanded, row_ids = split_c$test)
```

```
## <PredictionClassif> for 268 observations:
##     row_ids truth response
##          14    no       no
##          19    no      yes
##          21    no       no
## ---                       
##         872   yes      yes
##         875   yes      yes
##         888   yes      yes
```

```r
lrn_r_ranger$train(tsk_r_train)
lrn_r_ranger$predict(tsk_r_test)
```

```
## <PredictionRegr> for 152 observations:
##     row_ids truth response
##           3  34.7 32.71191
##           4  33.4 34.05191
##          10  18.9 19.00793
## ---                       
##         491   8.1 14.68894
##         498  18.3 20.81181
##         501  16.8 20.21392
```

任务、学习器都有各自的对象，预测结果也有，就是prediction对象，实际上mlr3里任何东西都有个对象。


```r
predicition_c = lrn_c_ranger$predict(tsk_c_imputed_expanded, row_ids = split_c$test)
predicition_r = lrn_r_ranger$predict(tsk_r_test)
```

可以用score方法查看默认的指标，也可以在score内指明其它指标，使用msrs()查看所有指标。


```r
predicition_c$score()
```

```
## classif.ce 
##  0.2164179
```

```r
predicition_c$score(msr("classif.acc"))
```

```
## classif.acc 
##   0.7835821
```
