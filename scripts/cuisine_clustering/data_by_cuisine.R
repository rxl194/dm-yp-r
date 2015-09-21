# Splits the reviews in restaurant by restaurant category. It removes those categories that are not clearly related to restaurants like Taxi and Automotive.

require(stringr)

require(dplyr)

load("data/R/review.RData")

load("data/R/business.RData")

load("data/R/restaurant_ids.RData")

# Select restaurants and split by cuisine

non_cuisine_categories <- c("Restaurants","Bars","Nightlife","Lounges","Party & Event Planning","Event Planning & Services","Venues & Event Spaces","Active Life","Bowling","Delis","Caterers","Beer, Wine & Spirits","Dive Bars","Grocery","Pubs","Buffets","Cafes","Sports Bars","Dance Clubs","Tea Rooms","Arts & Entertainment","Music Venues","Wine Bars","Karaoke","Shopping Centers","Shopping","Outlet Stores","Golf","Convenience Stores","Drugstores","Hotels & Travel","Hotels","Jazz & Blues","Breweries","Seafood Markets","Performing Arts","Fashion","Sporting Goods","Sports Wear","Cinema","Pool Halls","Arcades","Casinos","Health Markets","Social Clubs","Food Delivery Services","Gift Shops","Flowers & Gifts","Health & Medical","Hospitals","Food Stands","Amusement Parks","Island Pub","Gas & Service Stations","Automotive","Cocktail Bars","Personal Chefs","Cheese Shops","Gay Bars","Adult Entertainment","Herbs & Spices","Beauty & Spas","Gyms","Medical Spas","Fitness & Instruction","Day Spas","Taxis","Transportation","Auto Repair","Colleges & Universities","Education","Specialty Schools","Cooking Schools","RV Parks","Home Decor","Home & Garden","Kitchen & Bath","Appliances","Airports","Tours","Cafeteria","Food Court","Food Trucks","Champagne Bars","Wineries","Art Galleries","Bed & Breakfast","Arts & Crafts","Landmarks & Historical Buildings","Personal Shopping","Public Services & Government","Street Vendors","Dry Cleaning & Laundry","Local Services","Festivals","Farmers Market","Internet Cafes","Bubble Tea","Leisure Centers","Piano Bars","Kids Activities","Car Wash","Horseback Riding","Beer Bar","Butcher","Country Dance Halls","Cultural Center","Home Services","Real Estate","Apartments","Mass Media","Print Media","Distilleries","Food","Coffee & Tea")

cuisines <- setdiff(unique(unlist(business$categories[business_restaurant_index])),non_cuisine_categories)

cuisines <- gsub("\\(","\\\\\\(",cuisines)

cuisines <- gsub("\\)","\\\\\\)",cuisines)

cuisines <- gsub("\\&","\\\\\\&",cuisines)

business.by.cuisine <- lapply(cuisines,function(cuisine) business[grepl(cuisine,business$categories),"business_id"])

cuisines <- gsub("\\\\\\(","\\(",cuisines)

cuisines <- gsub("\\\\\\)","\\)",cuisines)

cuisines <- gsub("\\\\\\&","\\&",cuisines)

business.by.cuisine <- mapply(function(cuisine,business_list) list(cuisine=cuisine,business_id=business_list), cuisines,business.by.cuisine,SIMPLIFY = FALSE)

num.business.by.cuisine <- data.frame(cuisine=cuisines,n.business=unlist(lapply(business.by.cuisine,function(x) length(x$business_id))),stringsAsFactors = FALSE) %>% arrange(desc(n.business))

# Split reviews by cuisine

reviews.by.cuisine <- lapply(business.by.cuisine,function(cuisine) list(cuisine=cuisine$cuisine,review_id=review[review$business_id %in% cuisine$business_id,"review_id"]))

num.reviews.by.cuisine <- data.frame(cuisine=cuisines,n.reviews=unlist(lapply(reviews.by.cuisine,function(x) length(x$review_id))),stringsAsFactors = FALSE) %>% arrange(desc(n.reviews))



save(cuisines,business.by.cuisine,num.business.by.cuisine,reviews.by.cuisine,num.reviews.by.cuisine,file="data/R/restaurant_reviews_ids_by_cuisine.RData")
