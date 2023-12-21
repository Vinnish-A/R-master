


# puzzle1：展开折叠数据

## 数据展开


```r
Cattle = fread(
  "
id    group dfactor cattle infect
1      1       1     11      8
2      1       2     10      7
3      1       3     12      5
4      1       4     11      3
5      1       5     12      2
6      2       1     10     10
7      2       2     10      9
8      2       3     12      8
9      2       4     11      6
10     2       5     10      4
  "
)

infect_ = Cattle$infect
cattle_ = Cattle$cattle

Cattle_expanded = copy(Cattle)[rep(id, cattle), ]
Cattle_expanded[, infect := unlist(map2(infect_, cattle_ - infect_, ~ rep(c(1, 0), c(.x, .y))))]
Cattle_expanded
```

```
##      id group dfactor cattle infect
##   1:  1     1       1     11      1
##   2:  1     1       1     11      1
##   3:  1     1       1     11      1
##   4:  1     1       1     11      1
##   5:  1     1       1     11      1
##  ---                               
## 105: 10     2       5     10      0
## 106: 10     2       5     10      0
## 107: 10     2       5     10      0
## 108: 10     2       5     10      0
## 109: 10     2       5     10      0
```

```r
Cattle %>% 
  group_by(id) %>% 
  mutate(infected = list(c(rep(1, infect), rep(0, cattle-infect)))) %>% 
  unnest() %>% 
  View()
```

```
## Warning: `cols` is now required when using `unnest()`.
## ℹ Please use `cols = c(infected)`.
```

```r
Cattle %>% 
  group_nest(id) %>% 
  mutate(infected = map(data, ~ c(rep(1, .x$infect), rep(0, .x$cattle-.x$infect)))) %>% 
  unnest(data) %>% 
  unnest(infected) %>% 
  select(-infect)
```

```
## # A tibble: 109 × 5
##       id group dfactor cattle infected
##    <int> <int>   <int>  <int>    <dbl>
##  1     1     1       1     11        1
##  2     1     1       1     11        1
##  3     1     1       1     11        1
##  4     1     1       1     11        1
##  5     1     1       1     11        1
##  6     1     1       1     11        1
##  7     1     1       1     11        1
##  8     1     1       1     11        1
##  9     1     1       1     11        0
## 10     1     1       1     11        0
## # ℹ 99 more rows
```

## 模型建立


```r
Model1 = glm(cbind(infect, cattle - infect) ~ factor(group) + dfactor, family = binomial(link = logit), data = Cattle)
summary(Model1)
```

```
## 
## Call:
## glm(formula = cbind(infect, cattle - infect) ~ factor(group) + 
##     dfactor, family = binomial(link = logit), data = Cattle)
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      2.1310     0.6113   3.486  0.00049 ***
## factor(group)2   1.3059     0.4654   2.806  0.00502 ** 
## dfactor         -0.7874     0.1813  -4.342 1.41e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 33.5256  on 9  degrees of freedom
## Residual deviance:  2.4508  on 7  degrees of freedom
## AIC: 32.254
## 
## Number of Fisher Scoring iterations: 4
```

```r
Model2 = glm(infect ~ factor(group) + dfactor, family = binomial(link = logit), data = Cattle_expanded)
summary(Model2)
```

```
## 
## Call:
## glm(formula = infect ~ factor(group) + dfactor, family = binomial(link = logit), 
##     data = Cattle_expanded)
## 
## Coefficients:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      2.1310     0.6113   3.486  0.00049 ***
## factor(group)2   1.3059     0.4654   2.806  0.00502 ** 
## dfactor         -0.7874     0.1813  -4.342 1.41e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 149.04  on 108  degrees of freedom
## Residual deviance: 117.96  on 106  degrees of freedom
## AIC: 123.96
## 
## Number of Fisher Scoring iterations: 4
```





