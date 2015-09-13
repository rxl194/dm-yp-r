graph.circular <- function(fit,k,n,topic.names=c()){

topic.terms <- data.frame(terms(fit,n),stringsAsFactors = FALSE)



p <-lapply(seq(1,k),function(i) fit@beta[i,match(topic.terms[,i],fit@terms)])
alpha<- lapply(p,function(x) exp(x)/max(exp(x)))

alpha <- unlist(alpha)

alpha <- insert(alpha,seq(1,n*k,n),rep(1,k))

g <- as.vector(unlist(lapply(seq(1,ncol(topic.terms)),function(i) {
  x <- names(topic.terms)[i]
  as.vector(unlist(lapply(unlist(topic.terms[x]),function (y) c(x,paste0(y,"_",i)))))}
)))
#g <- c(unlist(lapply(names(topic.terms),function(x) c("Reviews",x))),g)


g <- graph(g,directed=FALSE)

V(g)$name <- unlist(lapply(str_split(V(g)$name,"_"),function(x) x[[1]]))

for(i in 1:length(topic.names)){
  
  V(g)$name[V(g)$name==names(topic.names)[i]] <- topic.names[i]
}



pal <- function(x,a){
  rainbow(k,alpha = a)[x]
  
}

V(g)$color <-mapply(pal,rep(1:k,each=n+1),alpha)



lab.locs <- seq(-pi,pi,length.out = n*k)

lab.locs <- insert(lab.locs,seq(1,n*k,n),seq(-pi,pi,length.out = k))

vertex.label.dist <- rep(-0.7,n*k)

vertex.label.dist <- insert(vertex.label.dist,seq(1,n*k,n),rep(0.7,k))
set.seed(100)



label.angle <- c(-seq(0,90,length.out = n*k/4),seq(-90,-180,length.out = n*k/4)+180,180-seq(180,270,length.out = n*k/4),-seq(270,360,length.out = n*k/4))

center.angles <- 180-seq(0,360,length.out = k)

center.angles[c(1:round(k/4),(3*round(k/4)):k)] <- center.angles[c(1:round(k/4),(3*round(k/4)):k)]-180

label.angle <- insert(label.angle,seq(1,n*k,n),center.angles)

label.family <- rep("",(n+1)*k)



plot.igraph(g,layout=layout_as_tree(g,circular=TRUE),vertex.size=4,margin=0,vertex.label.degree=lab.locs,vertex.label.dist=vertex.label.dist,srt=label.angle,vertex.label.family=label.family,edge.width=rep(rep(c(1,4),each=n),k)[1:(n*k)])

}