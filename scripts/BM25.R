# BM25 for simple_triplet_matrix representing a DTM

if(!require(slam)){
  install.packages("slam",dependencies=TRUE)
}

require(slam)

#' BM25 transformation to a document-term matrix.
#'
#' Applies the BM25 transformation to a document-term matrix. 
#'
#' For the ith document and jth term computes 
#' $\\frac{k*c(i,j)}{c(i,j)+k*(1-b+b*|D|/avgdl)}
#' where c(i,j) is each of the cells in the document-term matrix, k and b are BM25 paramters, |D| is the length of the
#' document computed here as sum(c(i,.)) and avgdl is the average document length.
#' After that it normalizes each row dividing by sum(c(i,.))
#'
#' @param dtm simple-triplet-matrix object representing a document-term matrix of raw counts. Usually the results of the DocumentTermMatrix function in the tm package.
#' @param k  parameter in the BM25 formula. By default k=2
#' @param b parameter in the BM25 formula. By default b=0.5
#' @return simple-triplet-matrix of transformed counts.
#' 
#' @references 
#' Robertson, S.E., Walker, S., Hancock-Beaulieu, M., Gatford, M., Payne, A., 1995. Okapi at TREC-4., in:. Presented at the TREC.
BM25 <- function(dtm,k=2,b=0.5){
  
  # Compute mean document length
  mean.doc.length <- mean(rowapply_simple_triplet_matrix(dtm,sum))
  
  # Compute each document length
  d.length <- row_sums(dtm)
  
  # Compute the numerator and doniminator of the BM25 formula.
  numer <- dtm*(k+1)
  denom <- dtm+as.simple_triplet_matrix(matrix(rep(k*(1-b+b*d.length/mean.doc.length),ncol(dtm)),ncol=ncol(dtm)))
  
  # Divide
  
  x <- numer/denom
  
  # Normalize
  
  sum.x <- row_sums(x)
  
  result <- x/sum.x
  
  result
}

#' Similarity between two BM25 vectors.
#' 
#' Computes the similarity of two BM25 vectors.
#' 
#' It computes the crossproduct of the two vectors weighted using IDF values.
#' 
#' @param x, y numeric vectors of BM25 weights
#' @param IDF numeric vector of IDF weights of the same length than x and y 
#' @return numeric value of BM25 similarity.
#' 
#' @references 
#' Robertson, S.E., Walker, S., Hancock-Beaulieu, M., Gatford, M., Payne, A., 1995. Okapi at TREC-4., in:. Presented at the TREC.
BM25.sim  <-function(x,y,IDF){
  
  sum(x*y*IDF)
  
}


#' Similarity between two BM25 vectors using the BM25+ modification.
#' 
#' Computes the similarity of two BM25 vectors using the BM25+ modification
#' 
#' It computes the crossproduct of the two vectors weighted using IDF values. It applies the BM25+ modification and sums $\\gamma$ to each pair of terms matched.
#' The BM25+ compensates for the difference of document lenghts.
#' 
#' @param x, y numeric vectors of BM25 weights
#' @param IDF numeric vector of IDF weights of the same length than x and y 
#' @return numeric value of BM25 similarity.
#' 
#' @references 
#' Lv, Y., Zhai, C., 2011. Lower-bounding term frequency normalization, in:. Presented at the Proceedings of the 20th ACM international conference on Information and knowledge management, ACM, pp. 7–16.
BM25plus.sim  <-function(x,y,IDF,gamma=1){
  
  p <- x*y
  p[p>0] <- p[p>0]+gamma
  
  sum(p*IDF)
  
}