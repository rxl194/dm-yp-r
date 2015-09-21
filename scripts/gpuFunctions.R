# Helper functions to compute cosine similarities on large matrices using the computer GPU

require(gputools)
require(tidyr)
require(dplyr)

gpuCosine <- function(x,y=NULL){
  
  
  
  if(is.null(y)){
    cp <- gpuTcrossprod(x)
    normx <- sqrt(diag(cp))
    
    
    norm.prod <- gpuMatMult(normx,t(normx))
    
  }else{
    
    cp <- gpuTcrossprod(x,y)
    normx <- sqrt(diag(gpuTcrossprod(x)))
    normy <- sqrt(diag(gpuTcrossprod(y)))
    
    norm.prod <- gpuMatMult(normx,t(normy))
    
    
    
    
  }
  
  cos.sim <- cp/norm.prod
  
  cos.sim
}

compute.cos.sim.blocks <- function(m,N,reviews.by.cuisine,documents){
  
  
  
  blocks <- data.frame(t(combn(1:ceiling(nrow(m)/N),2)))
  names(blocks) <- c("block1","block2")
  
  blocks <- rbind(blocks,data.frame(block1=1:max(blocks$block1),block2=1:max(blocks$block1)))
  
  blocks$block1.ini <- (blocks$block1-1)*N+1
  blocks$block1.end <- blocks$block1.ini+N-1
  blocks$block1.end[blocks$block1.end >nrow(m)] <- nrow(m)
  
  blocks$block2.ini <- (blocks$block2-1)*N+1
  blocks$block2.end <- blocks$block2.ini+N-1
  blocks$block2.end[blocks$block2.end >nrow(m)] <- nrow(m)
  
  cuisine.comb <- rbind(t(combn(names(reviews.by.cuisine),2)),cbind(names(reviews.by.cuisine),names(reviews.by.cuisine)))
  
  cuisine.comb.ids <- apply(cuisine.comb,1,function(comb){
    
    cuisine.a.review <- reviews.by.cuisine[[comb[1]]]$review_id
    cuisine.b.review <- reviews.by.cuisine[[comb[2]]]$review_id
    
    list(cuisine.a.review=cuisine.a.review,cuisine.b.review=cuisine.b.review)
    
  })
  
  cosine.sim.blocks <- apply(blocks,1,function(block){
    
    print(paste0(Sys.time(),"Starting Block a:",block["block1"],"Block b:",block["block2"]))
    
    block.a <- m[block["block1.ini"]:block["block1.end"],]
    block.b <- m[block["block2.ini"]:block["block2.end"],]  
    
    cosine.sim <- gpuCosine(block.a,block.b)
    rownames(cosine.sim) <- documents[block["block1.ini"]:block["block1.end"]]
    colnames(cosine.sim) <- documents[block["block2.ini"]:block["block2.end"]]
    
    
    
    found <- unlist(lapply(cuisine.comb.ids,function(comb){
      
      (any(comb[["cuisine.a.review"]] %in% rownames(cosine.sim)) & any(comb[["cuisine.b.review"]] %in% colnames(cosine.sim))) | (any(comb[["cuisine.a.review"]] %in% colnames(cosine.sim)) & any(comb[["cuisine.b.review"]] %in% rownames(cosine.sim)))
      
    }))
    
    
    apply(cuisine.comb[found,],1,function(comb){
      
      cuisine.a.review <- reviews.by.cuisine[[comb[1]]]$review_id
      cuisine.b.review <- reviews.by.cuisine[[comb[2]]]$review_id
      
      c.sim.1 <- cosine.sim[rownames(cosine.sim) %in% cuisine.a.review, colnames(cosine.sim) %in% cuisine.b.review]
      c.sim.2 <- cosine.sim[rownames(cosine.sim) %in% cuisine.b.review, colnames(cosine.sim) %in% cuisine.a.review]
      
      list(cuisine.a=comb[1],cuisine.b=comb[2],sum=sum(c.sim.1,c.sim.2),n=prod(dim(c.sim.1))+prod(dim(c.sim.2)))
      
      
    }
    )
    
    
    
    
    
  })
  
  
  
  cosine.sims <- rbind_all(lapply(cosine.sim.blocks,function(block){
    
    rbind_all(lapply(block,function(x){
      data.frame(x,stringsAsFactors = FALSE)
    }))
    
  }))
  
  
  cosine.sims.matrix <- cosine.sims %>% group_by(cuisine.a,cuisine.b) %>% summarise(sum=sum(sum),n=sum(n)) %>% mutate(sim=sum/n) %>% select(-sum,-n) %>% spread(cuisine.b,sim)
  
  rownames(cosine.sims.matrix) <- cosine.sims.matrix$cuisine.a
  
  cosine.sims.matrix <- cosine.sims.matrix %>% select(-cuisine.a)
  
  cosine.sims.matrix <- as.matrix(cosine.sims.matrix)
  
  
  
  for(i in 1:nrow(cosine.sims.matrix)){
    for(j in 1:ncol(cosine.sims.matrix)){
      if(is.na(cosine.sims.matrix[i,j])){
        cosine.sims.matrix[i,j] <- cosine.sims.matrix[j,i]
      }
    }
  }
  
  cosine.sims.matrix
}
