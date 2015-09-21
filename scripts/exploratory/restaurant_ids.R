# Filters business by category to keep only those labeled as Restaurants and then filters the reviews to keep reviews for restaurants. Stored the ids of the filtered businesses and reviews.

load('data/R/business.RData')
load('data/R/review.RData')

# Select business and review ids for restaurants

business_restaurant_index <- which(grepl("Restaurants",business$categories))

business_restaurant_id <- business$business_id[business_restaurant_index]

review_restaurant_index <- which(review$business_id %in% business_restaurant_id)

review_restaurant_id <- review[review_restaurant_index,"review_id"]



save(business_restaurant_index,business_restaurant_id,review_restaurant_index,review_restaurant_id,file="data/R/restaurant_ids.RData")
