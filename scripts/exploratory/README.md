This folder holds the scripts relevant during the exploratory phase.

- **read.data.R** Reads Yelp data in JSON format and saves the resulting data.frames in RData files.
- **review.model.language.R** Computes a unigram language model for a corpus of Yelp reviews. 
- **restaurant_id.R** Filters business by category to keep only those labeled as Restaurants and then filters the reviews to keep reviews for restaurants. Stored the ids of the filtered businesses and reviews.
- **restaurants_model_language.R** Subsets the unigram model language to keep only a model language for a corpus of restaurant reviews. The vocabulary is also reduced to the most frequent words that account for 99% of the corpus.
- **topicmodel.R** Computes a topic model for the corpus of restaurant reviews.
- **data_by_rating.R** Splits the corpus of restaurant reviews into two corpora. One for positive reviews (stars >3) and another for negative reviews (stars < 3).
- **topicmodel_positive_negative.R** Computes a topic model for the positive and for the negative restaurant reviews corpora.
- **subset_useful_restaurant_reviews.R** Selects restaurant reviews that are useful. One review is useful if has been upvoted as usefull at least once.