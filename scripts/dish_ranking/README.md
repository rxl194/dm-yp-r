This folder contains scripts used to rank the dishes discovered according to their popularity.

- **dishes_count.R** Computes the document frequency of each dish in the restaurant reviews corpus.
- **topicmodel.R** Computes a topic model for the corpus of restaurant reviews. 3 topics
- **dish_rankings.R** Computes dish rankings for 6 cuisines using 4 scores: document frequency, average review stars, and versions of the two scores weighted by the probability that the reviews belong to a food topic.