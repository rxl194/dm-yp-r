require(recommenderlab)

require(Matrix)
require(slam)

load('results/restaurant_recommendation/dish_rating_matrices.RData')
load("data/R/business.RData")

ratings <- t(italian.business.ratings$dish.business.stars)

ratings <- ratings[which(row_sums(ratings >0)>5),]

sparse <- sparseMatrix(i=ratings$i, j=ratings$j, x=ratings$v,
                       dims=c(ratings$nrow, ratings$ncol))

r <- new("realRatingMatrix",data=sparse)



rownames(r) <- rownames(ratings)
colnames(r) <- colnames(ratings)
rec <- Recommender(r,method="POPULAR")

dish <- "peperonata"
n <- 20
p <- predict(rec,match(dish,rownames(r)),n=n,data=r)

real.ratings <-r[match(dish,rownames(r)),]



real.ratings.business <- colnames(real.ratings[,which(as.vector(real.ratings@data) >0)])
real.ratings.business <- business$name[match(real.ratings.business,business$business_id)]

data.frame(name=business$name[match(p@itemLabels[p@items[[1]]],business$business_id)],order=1:n,stringsAsFactors = FALSE) %>% mutate(dish.confirmed=name %in% real.ratings.business)



eval <- evaluationScheme(r,"cross-validation",k=10,given=5,goodRating=0.1)

rec <- Recommender(getData(eval, "train"),method="UBCF")

p <- predict(rec,getData(eval, "known"),n=n)

calcPredictionAccuracy(p, getData(eval, "unknown"),given=5,goodRating=0.1)
