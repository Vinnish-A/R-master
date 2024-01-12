


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
##   [1]   5   6   8  14  17  19  21  25  27  28  30  34  35  36  38  39  41  42
##  [19]  43  46  47  49  52  55  58  60  63  64  65  70  71  74  77  81  84  87
##  [37]  88  90  92  93  94  95  96 101 103 105 109 111 113 115 116 117 118 121
##  [55] 125 127 132 136 138 139 140 145 146 148 149 151 153 154 156 158 159 161
##  [73] 163 164 176 177 178 181 182 183 186 192 198 201 202 203 204 206 211 213
##  [91] 215 218 222 224 226 229 232 233 235 237 239 240 241 244 250 252 253 254
## [109] 261 263 264 266 267 274 277 278 279 282 283 285 286 293 294 295 297 298
## [127] 303 305 309 313 315 318 321 322 325 327 333 334 336 337 340 344 350 353
## [145] 354 355 356 358 362 366 373 374 375 378 380 383 386 387 389 393 396 397
## [163] 398 399 402 403 404 406 407 410 411 412 414 416 419 422 423 424 426 429
## [181] 434 435 437 439 442 443 451 452 453 455 457 460 462 463 464 465 466 467
## [199] 469 472 477 479 486 488 489 491 492 493 494 495 498 500 502 503 504 506
## [217] 509 512 515 516 518 520 522 523 525 528 529 530 532 533 535 537 539 542
## [235] 545 546 549 552 553 556 558 561 562 565 566 567 568 575 576 579 587 590
## [253] 591 593 594 596 599 602 603 604 606 607 612 614 617 624 626 627 630 634
## [271] 635 639 640 643 647 649 655 656 657 658 659 660 662 663 664 667 668 669
## [289] 673 675 676 677 679 684 685 686 687 688 689 695 696 697 699 700 703 704
## [307] 706 712 715 716 719 722 723 724 726 732 734 735 737 739 742 744 746 749
## [325] 754 758 759 761 765 767 768 769 770 772 776 783 784 785 786 788 790 792
## [343] 793 794 796 799 800 801 806 807 808 809 811 812 818 819 820 823 825 827
## [361] 834 835 838 842 844 845 846 848 851 853 855 860 862 864 868 869 871 873
## [379] 882 883 885 887 889 891   3   4  10  12  16  18  22  23  24  26  29  33
## [397]  37  40  44  45  48  53  54  56  57  59  75  79  80  82  83  85  86  89
## [415]  98 107 108 110 124 126 129 137 142 143 147 157 162 167 184 185 187 188
## [433] 191 193 196 199 205 210 212 216 217 219 227 231 234 248 249 256 257 260
## [451] 262 268 269 270 272 273 275 276 280 284 289 290 291 292 304 306 311 316
## [469] 319 324 328 329 330 331 335 338 341 346 347 348 357 359 360 367 369 370
## [487] 376 377 381 384 390 391 392 395 400 413 415 418 427 428 431 432 433 438
## [505] 441 444 445 448 450 454 458 459 461 474 490 497 505 507 508 510 513 514
## [523] 519 521 524 538 540 541 544 547 548 550 551 555 559 560 570 571 572 573
## [541] 574 578 581 582 586 588 601 605 608 610 616 619 623 628 631 633 636 642
## [559] 645 646 648 650 652 654 661 670 671 674 678 680 682 691 692 698 701 702
## [577] 709 710 713 718 725 727 728 741 748 751 756 760 763 766 775 778 780 781
## [595] 789 797 798 802 803 804 810 822 824 828 830 831 832 836 839 840 843 850
## [613] 854 856 857 858 866 867 870 872 875 888 890
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
##           1    no       no
##           7    no       no
##          13    no       no
## ---                       
##         876   yes      yes
##         880   yes      yes
##         881   yes      yes
```

```r
lrn_r_ranger$train(tsk_r_train)
lrn_r_ranger$predict(tsk_r_test)
```

```
## <PredictionRegr> for 152 observations:
##     row_ids truth response
##           4  33.4 35.23649
##           9  16.5 16.96422
##          15  18.2 19.69856
## ---                       
##         495  24.5 20.34244
##         496  23.1 19.02360
##         504  23.9 28.54684
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
##  0.1865672
```

```r
predicition_c$score(msr("classif.acc"))
```

```
## classif.acc 
##   0.8134328
```
