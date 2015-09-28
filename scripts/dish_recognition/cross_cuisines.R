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
italian <- unique(c(italian,italian_topmine$dishes,italian_segphrase$dishes))




f <- file('results/dish_discovery/mediterranean/mediterranean_dishes.txt')

mediterranean <- readLines(f)

close(f)

mediterranean_topmine <- read.table("results/dish_discovery/mediterranean/mediterranean_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=28)

mediterranean_segphrase <- read.table("results/dish_discovery/mediterranean/mediterranean_segphrase.csv",sep=",",stringsAsFactors = FALSE) %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.8)

mediterranean <- unique(c(mediterranean,mediterranean_topmine$dishes,mediterranean_segphrase$V2))



f <- file('results/dish_discovery/chinese/chinese_dishes.txt')

chinese <- readLines(f)

close(f)

chinese_topmine <- read.table("results/dish_discovery/chinese/chinese_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=32)

chinese_segphrase <- read.table("results/dish_discovery/chinese/chinese_segphrase.csv",sep=",",stringsAsFactors = FALSE,quote = "\"") %>% mutate(dishes=gsub("_"," ",V1)) %>% filter(V2 >=0.95)

chinese <- unique(c(chinese,chinese_topmine$dishes,chinese_segphrase$dishes))



f <- file('results/dish_discovery/mexican/mexican_dishes.txt')

mexican <- readLines(f)

close(f)

mexican_topmine <- read.table("results/dish_discovery/mexican/mexican_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=50)

mexican <- unique(c(mexican,mexican_topmine$dishes))



f <- file('results/dish_discovery/american/american_dishes.txt')

american <- readLines(f)

close(f)


american_topmine <- read.table("results/dish_discovery/american/american_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=38)

american <- unique(c(american,american_topmine$dishes))




f <- file('results/dish_discovery/indian/indian_dishes.txt')

indian <- readLines(f)

close(f)

indian_topmine <- read.table("results/dish_discovery/indian/indian_topmine.txt",stringsAsFactors = FALSE,sep="\t") %>% mutate(dishes=tolower(stripWhitespace(V1))) %>% arrange(desc(V2)) %>% filter(V2 >=3)

indian <- unique(c(indian,indian_topmine$dishes))


common <- data.frame(dishes=c(chinese,italian,mediterranean,mexican,american,indian),stringsAsFactors = FALSE) %>% count(dishes) %>% filter(n>=3)


chinese_clean <- chinese %>% setdiff(common$dishes)

italian_clean <- italian %>% setdiff(common$dishes)

indian_clean <- indian %>% setdiff(common$dishes)

mediterranean_clean <- mediterranean %>% setdiff(common$dishes) 

mexican_clean <- mexican %>%  setdiff(common$dishes)

american_clean <- american %>%  setdiff(common$dishes)
  

