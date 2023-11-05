library(mlr3verse)
library(tidyverse)

data_pg_train_raw = read_csv("../Boston-Housing/data/train.csv")
data_pg_train_test = read_csv("../Boston-Housing/data/test.csv")






preprocess = function (pars, data_raw) {
  judge = "Survived" %in% colnames(data_raw)
  
  if (judge) {
    data_raw %>% 
      mutate(Name = str_replace(Name, "\"", "")) %>% 
      mutate(Name = str_replace(Name, "\\\"", "")) %>% 
      mutate(Family = str_extract(Name, "^[^,]+"), 
             Appellation = str_sub(str_extract(Name, ",\\s(\\w+)(?=\\.)"), start = 3), 
             Seat = str_sub(Cabin, end = 1)) %>% 
      select(-Name, -Cabin, -PassengerId, -Ticket) %>% 
      mutate(Seat = ifelse(Seat %in% lst_par[[3]], Seat, "Unknown"), 
             # Family = ifelse(Family %in% lst_par[[1]], "pairs", "Single"), 
             Appellation = lst_par[[2]][Appellation], 
             across(where(is.character), factor), 
             Sex = as.integer(Sex) - 1) %>% 
      select(-Family, -Embarked)
  } else {
    data_raw %>% 
      mutate(Name = str_replace(Name, "\"", "")) %>% 
      mutate(Name = str_replace(Name, "\\\"", "")) %>% 
      mutate(Family = str_extract(Name, "^[^,]+"), 
             Appellation = str_sub(str_extract(Name, ",\\s(\\w+)(?=\\.)"), start = 3), 
             Seat = str_sub(Cabin, end = 1)) %>% 
      select(-Name, -Cabin, -PassengerId, -Ticket) %>% 
      mutate(Seat = ifelse(Seat %in% lst_par[[3]], Seat, "Unknown"), 
             # Family = ifelse(Family %in% lst_par[[1]], "pairs", "Single"), 
             Appellation = lst_par[[2]][Appellation], 
             across(where(is.character), factor), 
             Sex = as.integer(Sex) - 1) %>% 
      select(-Family, -Embarked) %>% 
      mutate(Survived = c(rep(0, nrow(.)-1), 1))
  }
}


















