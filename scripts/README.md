This folder contains R scripts used to analyze the data.

## Folders

- **exploratory**. This folder holds the scripts relevant during the exploratory phase.

- **cuisine_clustering**. This folder contains scripts used to compute the results used in the Cuisine Clustering and Map Construction step.
- **dish_recognition**. This folder contains scripts for dish discovery using Yelp reviews and the algorithms: word2vect, TopMine, SegPhrase.
- **dish_ranking**. This folder contains scripts used to rank the dishes discovered according to their popularity.
- **restaurant_recommendation**. Contains scripts used to recommend restaurants for a given dish.

## Helper scripts

- **graph.circular.R** This script contains the graph.circular function used to plot a topic model as a circular graph.

- **igraph.plot2.R** Custom version of the function `plot.igraph` from the `igraph` package. The function was modified to allow to pass a vector of angles to the text function that plots the graph labels in order to rotate the labels.

- **BM25.R** Functions to compute BM25 and BM25+ similarities.

- **gpuFunctions.R** Helper functions to compute cosine similarities on large matrices using the computer GPU.