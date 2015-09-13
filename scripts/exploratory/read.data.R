if(!require(jsonlite)){
  install.packages("jsonlite")
}

require(jsonlite)

business.file <- './data/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_business.json'

business <- stream_in(file(business.file))

save(business,file='data/R/business.RData')


rm(business)

checkin.file <- './data/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_checkin.json'

checkin <- stream_in(file(checkin.file))

save(checkin,file='data/R/checkin.RData')

rm(checkin)



review.file <- './data/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_review.json'

review <- stream_in(file(review.file))

save(review,file='data/R/review.RData')

rm(review)



tip.file <- './data/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_tip.json'

tip <- stream_in(file(tip.file))

save(tip,file='data/R/tip.RData')

rm(tip)



user.file <- './data/yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_user.json'

user <- stream_in(file(user.file))

save(user,file='data/R/user.RData')

rm(user)
