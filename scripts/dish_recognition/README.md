This folder includes scripts for dish discovery in task 3. There is a folder per cuisine. Inside each of them you can find the following scripts:

- **cuisine_subset.R** Extracts all the useful positive reviews for [cuisine] restaurants.
- **cuisine_word2vect.R** Runs the word2vect algorithm on the [cuisine] corpus, computes similarities among the vectors and extracts relevant dishes using the training labels as seed. See italian_word2vect.R for a version with comments.

In addition, the next scripts are common to all cuisines.

- **word2vect.R** Contains functions used to compute the similarity betwen word2vect vector and extract related items.
- **cross_cuisines.R** Loads the results from word2vect, TopMine and SegPhrase and combines them for each cuisine. Then removes common items to all cuisines.