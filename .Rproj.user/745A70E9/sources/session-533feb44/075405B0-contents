library(tidyverse)

data = as_tibble(iris)
data_no_setosa = filter(data, Species != "setosa")
data_no_versicolor = filter(data, Species != "versicolor")
data_no_virginica = filter(data, Species != "virginica")

two_class = function(data) {
  model = glm(Species ~ ., data = data, family = binomial())
  predict(model, newdata = data[, -5], type = "response")
}

# 注意到，二分类输出的是一个个0到1之间的概率值
# 数据均衡的话取阈值0.5，将概率化为二分类结果
# 数据不均衡的话采用其它阈值
two_class(data_no_setosa)

# 二分类预测结果的评价指标是交叉熵损失函数
# 越低越好了
cross_entropy = function (truth, response) {
  # 注意到，当truth为0或1时，其中一项就被消掉了
  - mean(truth * log(response) + (1-truth) * log(1-response)) 
}

cross_entropy(as.numeric(data_no_setosa$Species)-2, two_class(data_no_setosa))

# 简而言之，n分类就是把二分类重复n次 
data_is_setosa = mutate(data, Species = ifelse(Species == "setosa", 0, 1))
data_is_versicolor = mutate(data, Species = ifelse(Species == "versicolor", 0, 1))
data_is_virginica = mutate(data, Species = ifelse(Species == "virginica", 0, 1))

two_class(data_is_setosa)
two_class(data_is_versicolor)
two_class(data_is_virginica)

# 此时的概率就可以作为分类的依据
# 这种找最大值或者最小值的方法被称为hardmax
# 同理有softmax
# softmax的形式是将概率指数化，是一种将概率归一化的方法
# 求导时softmax的梯度就是对应的softmax值
# 所以深度学习分类任务中常用softmax而非hardmax
# 无他，反向传播算的快

# hardmax
result_hardmax = tibble(
  is_setosa = two_class(data_is_setosa), 
  is_versicolor = two_class(data_is_versicolor), 
  is_virginica = two_class(data_is_virginica)
) %>% mutate( # pmap是一种按行操作的方法
  which = pmap_dbl(., ~ which.min(c(...))), 
  prob = pmap_dbl(., ~ c(...)[which.min(c(...))])
)

# softmax
softmax = function(value, values) {
  exp(value) / sum(exp(values))
}

result_softmax = tibble(
  is_setosa = two_class(data_is_setosa), 
  is_versicolor = two_class(data_is_versicolor), 
  is_virginica = two_class(data_is_virginica)
  ) %>% mutate(
    is_setosa_so =  pmap_dbl(., ~ softmax(..1, c(..1, ..2, ..3))), 
    is_versicolor_so = pmap_dbl(., ~ softmax(..2, c(..1, ..2, ..3))), 
    is_virginica_so = pmap_dbl(., ~ softmax(..3, c(..1, ..2, ..3)))
  ) %>% select(contains("so")) %>% mutate(
    which = pmap_dbl(., ~ which.min(c(...))), 
    prob = pmap_dbl(., ~ c(...)[which.min(c(...))])
  )

# 多分类的评价指标是对数似然损失
# 交叉熵是对数似然损失的特殊形式

log_likelihood = function (truth, response) {
  -log(sum(truth * response))
}

# 交叉熵的完整写法
truth = list(c(1, 0), c(0, 1))
response = list(c(0.9, 0.1), c(0.2, 0.8))
mean(map2_dbl(truth, response, log_likelihood))

# 二者等价
truth = c(1, 0)
response = c(0.9, 0.2)
cross_entropy(truth, response)

# 多分类的损失函数
truth = list(c(1, 0, 0), c(0, 1, 0))
response = list(c(0.85, 0.1, 0.05), c(0.15, 0.8, 0.05))
mean(map2_dbl(truth, response, log_likelihood))


