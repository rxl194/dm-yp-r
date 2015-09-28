related.words <- function(cosine.similarity,word,n=Inf,threshold=0){
  
  v <- cosine.similarity[word,!colnames(cosine.similarity) %in% c(word)]
  v <- v[order(v,decreasing = TRUE)]
  v <- v[v >=threshold]
  if(length(v) >0){
    v <- v[1:min(n,length(v))]  
  }
  
  word <- names(v)
  
  word  
  
}

crawl.sims <- function(cosine.similarity,start.word,n=Inf,related=c(),max.depth=Inf,threshold=0,depth=1){
  
  
  related <- c(start.word,related)
  if(depth < max.depth){
    words <- related.words(cosine.similarity,start.word,n=n,threshold = threshold)
    
    words <- setdiff(words,related)
    
    for(word in words){
      
      related <- crawl.sims(cosine.similarity,word,n,related,max.depth=max.depth,threshold = threshold,depth=depth+1)
    }
  }
  unique(related)
  
}


extract.related.words <- function(cosine.similarity,labels,n=Inf,max.depth=Inf,threshold=0){
  
  related <- sort(unique(unlist(lapply(labels,function(label){
    
    crawl.sims(cosine.similarity,label,n=n,threshold = threshold,max.depth = max.depth)
    
  }))))
  
  related
}
