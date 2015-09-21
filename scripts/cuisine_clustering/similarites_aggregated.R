# Computes similarities between cuisine categories using concatenated positive useful restaurant reviews. It tries three approaches:
# 1. cosine similarity of raw Term Frequencies.
# 2. BM25+
# 3. Cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA.

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


source('scripts/BM25.R')

# Load the dtm aggregated of positive useful reviews for a subset of restaurant categories.

load('results/language_models/restaurant.cuisines.subsample.aggregated.RData')

# Load the list of review ids grouped by cuisine.

load('data/R/restaurant_reviews_ids_by_cuisine.RData')


###############################################
# Compute cosine similarity of raw Term Frequencies.

cos.sim.freq.aggregated <- tcrossapply_simple_triplet_matrix(dtm.aggregated,FUN=cosine)

save(cos.sim.freq.aggregated,file="results/cuisine_maps/cuisines_aggregated_cosine_term_frequency.RData")

###############################################
# Compute similarity using BM25+

# These are typical parameters for BM25+

k <- 2

b <- 0.5

gamma <- 1


# Compute IDF weights according to $\\log(frac{M+1}{df_i})$ where df_i is the document frequency of word i

M <-nrow(dtm.aggregated)

includes.word <- dtm.aggregated !=0

n.docs.includes.word <- matrix(rollup(includes.word,1,FUN=sum))

IDF.aggregated <- log((M+1)/n.docs.includes.word)

# Apply BM25 transformation

bm25.aggregated <- BM25(dtm.aggregated,b=b,k=k)

# Compute similarity using BM25+ modification. I have tried using the unmodified version,
# but some categories have only a few reviews (<10) compared to other categories that have >10000 reviews.
# As a result the categories with more reviews are penalized and the categories with small get much higher similarities between them.
sim.bm25.aggregated <- tcrossapply_simple_triplet_matrix(bm25.aggregated,FUN=BM25plus.sim,IDF=IDF.aggregated,gamma=gamma)


# Save the result

save(sim.bm25.aggregated,file="results/cuisine_maps/cuisines_agregated_bm25.RData")




###############################################
# Compute cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA.

# Load the result of running LDA with k=20 and Gibbs sampling

load('results/topic_models/aggregated_by_cuisine.RData')

# Extract the probabilities of each document belonging to each topic. I remove topic 6
# because it represents the common positive customer experence and all the categories score high on this topic. Therefore the topic is not discriminative among categories.

gamma.aggregated <- as.simple_triplet_matrix(dtm.aggregated.LDA@gamma[,-6])
rownames(gamma.aggregated) <- rownames(dtm.aggregated)

# Compute similarity using cosine similarity.

sim.gamma.aggregated <- tcrossapply_simple_triplet_matrix(gamma.aggregated,FUN=cosine)


# Save results
save(sim.gamma.aggregated,file='results/cuisine_maps/cuisines_agregated_topic_similarity.RData')






