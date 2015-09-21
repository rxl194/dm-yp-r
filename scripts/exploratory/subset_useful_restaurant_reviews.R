# Selects restaurant reviews that are useful. One review is useful if has been upvoted as usefull at least once.

if(!require(dplyr)){
  install.packages("dplyr")
}
require(dplyr)


load('data/R/review.RData')

load('data/R/restaurant_ids.RData')

review <- review[review$review_id %in% review_restaurant_id,]

review$useful <- review$votes$useful



percentages <- review %>% group_by(useful) %>% count(useful) %>% mutate(percentage=n/sum(n)*100,useful=factor(useful))



ggplot(percentages,aes(x="",y=percentage,fill=useful))+
  geom_bar(width = 1,stat="identity")+
  coord_polar(theta="y")+
  geom_text(aes(y = percentage/2 + c(0, cumsum(percentage)[-length(percentage)]), label = paste0(round(percentage),"%")), size=4)+
  theme(axis.text = element_blank(),axis.ticks = element_blank(), panel.grid  = element_blank(), panel.background = element_blank())+
  ylab(NULL)+
  xlab(NULL)+
  scale_fill_discrete(name="Useful")

useful_restaurant_review_id <- (review  %>% select(-votes) %>% filter(useful >0))$review_id


save(useful_restaurant_review_id,file="data/R/useful_restaurant_review_id.RData")
