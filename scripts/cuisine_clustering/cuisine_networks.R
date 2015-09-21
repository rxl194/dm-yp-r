# Extracts backbone graphs from similarity matrices and applies community detection algorithms to cluster the data.

if(!require(disparityfilter)){
  install.packages("disparityfilter")
}

require(disparityfilter)

if(!require(igraph)){
  install.packages("igraph")
}

require(igraph)

#########################
# Similarity matrix from a topic model

# Load the similarity matrix computing from a topic model

load('results/cuisine_maps/cuisines_agregated_topic_similarity.RData')

# Create an igraph object using the matrix. The matrix is not sparse, so the resulting graph is fully connected.
# The weights of the edges are equal to the similarities.

edges <- t(combn(rownames(sim.gamma.aggregated),2))

names(edges) <- c("from","to")

weights <- sim.gamma.aggregated[t(combn(rownames(sim.gamma.aggregated),2))]


simil <- data.frame(edges,weight=weights,stringsAsFactors = FALSE)

names(simil) <- c("from","to","weight")

g <- graph.data.frame(simil,directed=FALSE)


# Extract a backbone graph from the fully connected network. Start with alpha =0.001 and increase
# in 0.001 steps until we have a connected network that includes all the cuisines or until we reach alpha=0.05.

N <- vcount(g)

alpha <- 0.001
g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))

if(class(g_backbone)=="try-error"){
  N_backbone <- 0
  g_connected <- FALSE
}else{
  N_backbone <- vcount(g_backbone)
  g_connected <- is.connected(g_backbone)
}



while((class(g_backbone)=="try-error" | !g_connected | N_backbone < N) & alpha <0.05){
alpha <- alpha+0.001
  g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))
  
  if(class(g_backbone)=="try-error"){
    N_backbone <- 0
    g_connected <- FALSE
  }else{
    N_backbone <- vcount(g_backbone)
    g_connected <- is.connected(g_backbone)
  }
  
}



# Compute total weight of edges for different alphas
# Total weight increases more or less linearly with alpha (the same for the number of edges.)



# alphas <- seq(0.001,0.01,0.001)
# edge.w <- lapply(alphas, function(alpha)  {
#   
#   x <- try(E(get.backbone(g,alpha=alpha,directed=FALSE))$weight)
#   
#   if(!class(x)=="try-error"){
#     sum(as.numeric(x))
#   }else{
#     0
#   }
#   })
#   
# 
# 
# to.plot <- data.frame(alpha=alphas,edge.w=unlist(edge.w))  
# 
# 
# ggplot(to.plot,aes(x=alpha,y=edge.w))+geom_line()
# 

# Test different communite detection algorithms.

# # Results in poor communities.
# 
# community <- fastgreedy.community(g_backbone)
# k <- 20
# 
# colors <- rainbow(k)
# V(g_backbone)$color <- colors[cut_at(community,k)]
# 
# V(g_backbone)$color <- cut_at(community,k)
# 
# #dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")
# 
# 
# seed <- 200
# 
# set.seed(seed)
# plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
# 
# 
# 
# #####
# 
# 
# community <- cluster_louvain(g_backbone)
# 
# 
# 
# 
# colors <- rainbow(max(membership(community)))
# V(g_backbone)$color <- colors[membership(community)]
# 
# 
# #dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")
# 
# 
# seed <- 200
# 
# set.seed(seed)
# plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
# 
# ########
# 
# community <- cluster_optimal(g_backbone)
# 
# colors <- rainbow(max(membership(community)))
# V(g_backbone)$color <- colors[membership(community)]
# 
# 
# #dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")
# 
# 
# seed <- 200
# 
# set.seed(seed)
# plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
# 
# 
# 
# ########
# 
# community <- cluster_edge_betweenness(g_backbone)
# 
# colors <- rainbow(max(membership(community)))
# V(g_backbone)$color <- colors[membership(community)]
# 
# 
# #dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")
# 
# seed <- 200
# 
# set.seed(seed)
# plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
# 
# ########
# 
# community <- cluster_leading_eigen(g_backbone)
# 
# colors <- rainbow(max(membership(community)))
# V(g_backbone)$color <- colors[membership(community)]
# 
# 
# #dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")
# 
# seed <- 200
# 
# set.seed(seed)
# plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
# 
# 

########

community <- cluster_label_prop(g_backbone)
colors <- rainbow(max(membership(community)))
V(g_backbone)$color <- colors[membership(community)]

save(community,g_backbone,file="results/cuisine_maps/aggregated_cuisine_topic_network.RData")
#dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")

seed <- 300

set.seed(seed)
plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")


##################
# Similarity matrix from raw term counts

# Load the similarity matrix computed using cosine similarity over raw word counts.

var <- load('results/cuisine_maps/cuisines_aggregated_cosine_term_frequency.RData')

# Create igraph graph as above

edges <- t(combn(rownames(cos.sim.freq.aggregated),2))

names(edges) <- c("from","to")

weights <- cos.sim.freq.aggregated[t(combn(rownames(cos.sim.freq.aggregated),2))]


simil <- data.frame(edges,weight=weights,stringsAsFactors = FALSE)

names(simil) <- c("from","to","weight")
g <- graph.data.frame(simil,directed=FALSE)

# Extract a backbone graph as above. This will fails because there is no significative graph bellow alpha 0.05

N <- vcount(g)

alpha <- 0.001
g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))

if(class(g_backbone)=="try-error"){
  N_backbone <- 0
  g_connected <- FALSE
}else{
  N_backbone <- vcount(g_backbone)
  g_connected <- is.connected(g_backbone)
}



while((class(g_backbone)=="try-error" | !g_connected | N_backbone < N) & alpha <0.05){
  alpha <- alpha+0.001
  g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))
  
  if(class(g_backbone)=="try-error"){
    N_backbone <- 0
    g_connected <- FALSE
  }else{
    N_backbone <- vcount(g_backbone)
    g_connected <- is.connected(g_backbone)
  }
  
}


#######################
# Community detection

community <- cluster_label_prop(g_backbone)
colors <- rainbow(max(membership(community)))
V(g_backbone)$color <- colors[membership(community)]

save(community,g_backbone,file="results/cuisine_maps/aggregated_cuisine_tf_network.RData")
#dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")

seed <- 300

set.seed(seed)
plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")


##################
# Similarity matrix using BM25


# Load the similarity matrix computed using BM25

var <- load('results/cuisine_maps/cuisines_agregated_bm25.RData')

# Create igraph graph
edges <- t(combn(rownames(sim.bm25.aggregated),2))

names(edges) <- c("from","to")

weights <- sim.bm25.aggregated[t(combn(rownames(sim.bm25.aggregated),2))]


simil <- data.frame(edges,weight=weights,stringsAsFactors = FALSE)

names(simil) <- c("from","to","weight")
g <- graph.data.frame(simil,directed=FALSE)

N <- vcount(g)

# Extract backbone graph

alpha <- 0.01
g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))

if(class(g_backbone)=="try-error"){
  N_backbone <- 0
  g_connected <- FALSE
}else{
  N_backbone <- vcount(g_backbone)
  g_connected <- is.connected(g_backbone)
}



while((class(g_backbone)=="try-error" | !g_connected | N_backbone < N) & alpha <0.05){
  alpha <- alpha+0.01
  g_backbone <- try(get.backbone(g,alpha=alpha,directed=FALSE))
  
  if(class(g_backbone)=="try-error"){
    N_backbone <- 0
    g_connected <- FALSE
  }else{
    N_backbone <- vcount(g_backbone)
    g_connected <- is.connected(g_backbone)
  }
  
}


########
# Comunity detection

community <- cluster_label_prop(g_backbone)
colors <- rainbow(max(membership(community)))
V(g_backbone)$color <- colors[membership(community)]

save(community,g_backbone,file="results/cuisine_maps/aggregated_cuisine_bm25_network.RData")
#dendPlot(community,mode="hclust",rect=4,use.modularity=TRUE, ylab="Modularity",xlab="Cuisines")

seed <- 300

set.seed(seed)
plot(g_backbone,layout=layout_with_lgl(g_backbone),vertex.size=3,vertex.label.cex=0.7,vertex.label.dist=0.2,edge.color="lightgrey")
