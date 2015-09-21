# Computes similarities between cuisine categories using positive useful restaurant reviews. It tries three approaches:
# 1. Cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA.
# 2. cosine similarity of raw Term Frequencies.
# 3. BM25+
# This script is computationally intensive and requires to be run on a computer with GPU computing capabilities.

if(!require(topicmodels)){
  install.packages("topicmodels",dependencies=TRUE)
}
require(topicmodels)

if(!require(slam)){
  install.packages("slam",dependencies=TRUE)
}

require(slam)

if(!require(lsa)){
  install.packages("lsa",dependencies=TRUE)
}

require(lsa)

if(!require(corrplot)){
  install.packages("corrplot",dependencies=TRUE)
}

require(corrplot)

if(!require(dplyr)){
  install.packages("dplyr",dependencies=TRUE)
}

require(dplyr)

if(!require(tidyr)){
  install.packages("tidyr",dependencies=TRUE)
}

require(tidyr)



source('scripts/cuisine_clustering/BM25.R')
source('scripts/gpuFunctions.R')

###############################################
# Compute cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA.

# Load the result of running LDA with k=100 and Gibbs sampling


load('results/topic_models/cuisines/review_topics_LDA_all_cuisines.RData')

# Load the list of review ids grouped by cuisine.

load('data/R/restaurant_reviews_ids_by_cuisine.RData')


# Reorder the rows of the probabilities matrix by cuisine for better performance. 

rev.ids <- unlist(lapply(reviews.by.cuisine,function(x) x$review_id))

rev.ids <- rev.ids[!duplicated(rev.ids)]

reorder <- Filter(function(x) !is.na(x),match(rev.ids,topic.model.cuisine.subsample@documents))


documents <- topic.model.cuisine.subsample@documents[reorder]


m <- topic.model.cuisine.subsample@gamma[reorder,]

# Compute the similarities in chunks of 10000 rows

N <- 10000


cosine.sims.matrix.topic.not.agg <- compute.cos.sim.blocks(m,N,reviews.by.cuisine,documents)


# Save the result

save(cosine.sims.matrix.topic.not.agg,file="results/cuisine_maps/cuisines_not_aggregated_topic_similarity.RData")



###############################################
# Compute cosine similarity of raw Term Frequencies.

# Load the dtm of positive useful reviews for a subset of restaurant categories.

load('results/language_models/restaurant.cuisines.subsample.RData')

# Reorder the rows of the dtm matrix by cuisine for better performance.

reorder <- Filter(function(x) !is.na(x),match(rev.ids,rownames(dtm.cuisine.subsample.review.unigram)))


documents <- rownames(dtm.cuisine.subsample.review.unigram)[reorder]


m <- as.matrix(dtm.cuisine.subsample.review.unigram)[reorder,]

# Compute the similarities in chunks of 10000 rows

N <- 10000


cosine.sims.matrix.topic.not.agg <- compute.cos.sim.blocks(m,N,reviews.by.cuisine,documents)

# Save the results

save(cosine.sims.matrix.topic.not.agg,file="results/cuisine_maps/cuisines_not_aggregated_topic_similarity.RData")


###############################################
# Compute similarity using BM25+

# These are typical parameters for BM25+

k <- 2

b <- 0.5

gamma <- 1


# Compute IDF weights according to $\\log(frac{M+1}{df_i})$ where df_i is the document frequency of word i

M <-nrow(dtm.cuisine.subsample.review.unigram)

includes.word <- dtm.cuisine.subsample.review.unigram !=0

n.docs.includes.word <- matrix(rollup(includes.word,1,FUN=sum))

IDF.not.agg <- log((M+1)/n.docs.includes.word)

# Apply BM25 transformation

bm25.not.agg <- BM25(dtm.cuisine.subsample.review.unigram,b=b,k=k)

# Compute similarity using BM25+ modification. 

sim.bm25.not.agg <- tcrossapply_simple_triplet_matrix(bm25.not.agg,FUN=BM25plus.sim,IDF=IDF.not.agg,gamma=gamma)


# Save the result

save(sim.bm25.not.agg,file="results/cuisine_maps/cuisines_not_agregated_bm25.RData")





