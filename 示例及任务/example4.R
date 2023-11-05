# 机器学习/深度学习的边际效益极低
# 一个人只需要两个星期就可以写出能实现我能写出的模型百分之九十甚至以上效果的模型

library(mlr3verse)

lrns() # 查看学习器
lrn_c_ranger = lrn("classif.ranger") # 随机森林 分类学习器
lrn_r_ranger = lrn("regr.ranger") # 随机森林 回归学习器

tsks() # 查看自带任务
tsk_c = tsk("titanic") # 二分类任务
tsk_r = tsk("boston_housing") # 回归任务

tsk_c$missings()
tsk_r$missings()

tsk_c$data() |> View()

# mlr3是基于R6对象开发的，R6对象和其它语言的面向对象形式十分相似
# 面向对象中一个显著的特点是把数据和操纵数据的方法结合到一起
# 比如说以下我们用tsk_c$filter(useful_sample)就已经筛选了满足条件的行
# 而不需要tsk_c = tsk_c$filter(useful_sample)的形式用赋值符号链接
# 可以简单的把面向对象理解成“自成体系”，就是用对象内部的函数处理对象内部的数据
useful_sample = which(!is.na(tsk_c$data()$survived)) # 这段函数是不是看起来十分抽象？
tsk_c$filter(useful_sample)

tsk_c$missings()

tsk_c$feature_types # 查看每列特征的类型
col_not_cha = tsk_c$feature_types$id[tsk_c$feature_types$type != "character"] # 为字符类型的列，去掉
tsk_c$select(col_not_cha)

tsk_c$col_info # 查看每列特征的类型
tsk_c$missings()

# 注意到embarked是多分类因子，需要编码，且数据中含有缺失值，进行特征工程
# mlr3中使用po()进行特征工程

preprocess_pipe1 = po("imputemode") # 使用众数插补
preprocess_pipe1$train(list(tsk_c))
tsk_c_imputed = preprocess_pipe1$predict(list(tsk_c))[[1]]
tsk_c_imputed$missings() # 插补好了

# 但是实际过程中一般不采用众数或者常数插补
# 一般将利用其它特征训练一个学习器用于插补缺失值
# 参考mlr3的ppt

# 多个po可以用 %>>% 连接起来

preprocess_pipe2 = 
  po("imputemode") %>>%
  po("encode", method = "one-hot") 
preprocess_pipe2$train(tsk_c)
# onehot编码即独热编码，是将分类变量化作数值变量的一种方法
# 看到这里你可能很迷惑，为什么上面要括号底下不要？
# 这里是mlr3作者偷了懒，大家只要记得一个po要list括起来，多个po不要
# 以及一定要记得，最后返回的是一个列表，所以结尾要加个[[1]]提取结果
tsk_c_imputed_expanded = preprocess_pipe2$predict(tsk_c)[[1]]

# 以下简单演示一下学习器插补，这里是有坑的，后面可以参考避坑
# 都用决策树用来插补，回归学习器用来插补数值变量，分类学习器插补因子
# 这里的两个坑，一是不同学习器必须有不同的id，二是必须严格指明影响的范围
preprocess_pipe0 = 
  po("imputelearner", id = "num", lrn("regr.rpart"), affect_columns = selector_type("numeric")) %>>%
  po("imputelearner", id = "fct", lrn("classif.rpart"), affect_columns = selector_type("factor"))

# 现在我们有了良好的数据
# 但是我们还需要将数据划分为训练集和测试集
# 前者用于训练模型，后者用于评估模型效果

split_c = partition(tsk_c_imputed_expanded, ratio = 0.7)
split_r = partition(tsk_r, ratio = 0.7) # 三七划分
split_c$train # 其实就是个列表

# 然后给列标注上训练和测试的信息，有两种方式
# 我们上面提到面向对象具有不需要赋值的特点
# 但是有的时候我们不得不赋值，可以采用新建一个对象
# 即内部的clone方法
tsk_c_imputed_expanded$set_row_roles(split_c$test, roles = "test") # 这个是旧方法，新版本用不到了，但是有特定的用途，后面介绍早停的时候会用到
tsk_r_train = tsk_r$clone(deep = T)$filter(split_r$train)
tsk_r_test = tsk_r$clone(deep = T)$filter(split_r$test)

# 同理，训练和预测也是两种方法
lrn_c_ranger$train(tsk_c_imputed_expanded, row_ids = split_c$train)
lrn_c_ranger$predict(tsk_c_imputed_expanded, row_ids = split_c$test)

lrn_r_ranger$train(tsk_r_train)
lrn_r_ranger$predict(tsk_r_test)

# 任务、学习器都有各自的对象，预测结果也有，就是prediction对象
# 实际上mlr3里任何东西都有个对象

predicition_c = lrn_c_ranger$predict(tsk_c_imputed_expanded, row_ids = split_c$test)
predicition_r = lrn_r_ranger$predict(tsk_r_test)

# 可以用score方法查看默认的指标
# 也可以在score内指明其它指标，使用msrs()查看所有指标
predicition_c$score()
predicition_c$score(msr("classif.acc"))

