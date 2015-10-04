if(!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE)
}

require(dplyr)

if(!require(tm)){
  install.packages("tm",dependencies = TRUE)
}

require(tm)




f <- file('results/dish_discovery/italian/italian_dishes.txt')

italian <- readLines(f)

close(f)

italian_topmine <- read.table("results/dish_discovery/italian/italian_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1)))  %>% arrange(desc(V2)) %>% filter(V2 >=18)

italian_segphrase <- read.table("results/dish_discovery/italian/italian_segphrase.csv",sep=",",stringsAsFactors = FALSE) %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.98)
italian <- unique(c(italian,italian_topmine$dishes))




f <- file('results/dish_discovery/mediterranean/mediterranean_dishes.txt')

mediterranean <- readLines(f)

close(f)

mediterranean_topmine <- read.table("results/dish_discovery/mediterranean/mediterranean_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=28)

mediterranean_segphrase <- read.table("results/dish_discovery/mediterranean/mediterranean_segphrase.csv",sep=",",stringsAsFactors = FALSE) %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.8)

mediterranean <- unique(c(mediterranean,mediterranean_topmine$dishes))



f <- file('results/dish_discovery/chinese/chinese_dishes.txt')

chinese <- readLines(f)

close(f)

chinese_topmine <- read.table("results/dish_discovery/chinese/chinese_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=32)

chinese_segphrase <- read.table("results/dish_discovery/chinese/chinese_segphrase.csv",sep=",",stringsAsFactors = FALSE,quote = "\"") %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.95)

chinese <- unique(c(chinese,chinese_topmine$dishes))



f <- file('results/dish_discovery/mexican/mexican_dishes.txt')

mexican <- readLines(f)

close(f)

mexican_topmine <- read.table("results/dish_discovery/mexican/mexican_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=50)

mexican_segphrase <- read.table("results/dish_discovery/mexican/mexican_segphrase.csv",sep=",",stringsAsFactors = FALSE,quote = "\"") %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.82)

mexican <- unique(c(mexican,mexican_topmine$dishes))



f <- file('results/dish_discovery/american/american_dishes.txt')

american <- readLines(f)

close(f)


american_topmine <- read.table("results/dish_discovery/american/american_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=38)
american_segphrase <- read.table("results/dish_discovery/american/american_segphrase.csv",sep=",",stringsAsFactors = FALSE,quote = "\"") %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.9)

american <- unique(c(american,american_topmine$dishes))




f <- file('results/dish_discovery/indian/indian_dishes.txt')

indian <- readLines(f)

close(f)

indian_topmine <- read.table("results/dish_discovery/indian/indian_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=3)

indian <- unique(c(indian,indian_topmine$dishes))


common <- data.frame(dishes=c(chinese,italian,mediterranean,mexican,american,indian),stringsAsFactors = FALSE) %>% count(dishes) %>% filter(n>=3)


chinese_clean <- chinese %>% setdiff(common$dishes)

chinese_clean <- chinese_clean[unlist(lapply(chinese_clean,function(dish){
  sum(grepl(dish,chinese_clean))==1
}))] 


italian_clean <- italian %>% setdiff(common$dishes)

italian_clean <- italian_clean[unlist(lapply(italian_clean,function(dish){
  sum(grepl(dish,italian_clean))==1
}))] 


indian_clean <- indian %>% setdiff(common$dishes)

indian_clean <- indian_clean[unlist(lapply(indian_clean,function(dish){
  sum(grepl(dish,indian_clean))==1
}))] 


mediterranean_clean <- mediterranean %>% setdiff(common$dishes) 

mediterranean_clean <- mediterranean_clean[unlist(lapply(mediterranean_clean,function(dish){
  sum(grepl(dish,mediterranean_clean))==1
}))] 


mexican_clean <- mexican %>%  setdiff(common$dishes)

mexican_clean <- mexican_clean[unlist(lapply(mexican_clean,function(dish){
  sum(grepl(dish,mexican_clean))==1
}))] 


american_clean <- american %>%  setdiff(common$dishes)

american_clean <- american_clean[unlist(lapply(american_clean,function(dish){
  sum(grepl(dish,american_clean))==1
}))] 

  
save(italian_clean,file='results/dish_discovery/italian/italian_dishes_clean.txt')

save(chinese_clean,file='results/dish_discovery/chinese/chinese_dishes_clean.txt')

save(indian_clean,file='results/dish_discovery/indian/indian_dishes_clean.txt')

save(mexican_clean,file='results/dish_discovery/mexican/mexican_dishes_clean.txt')

save(american_clean,file='results/dish_discovery/american/american_dishes_clean.txt')

save(mediterranean_clean,file='results/dish_discovery/mediterranean/mediterranean_dishes_clean.txt')
