f <- file('data/Hygiene/hygiene.dat','r')
text <- readLines(f)
close(f)

f <- file('data/Hygiene/hygiene.dat.labels','r')
labels <- readLines(f)
close(f)

additional <- read.table('data/Hygiene/hygiene.dat.additional',stringsAsFactors = FALSE,sep = ",",header = FALSE)
names(additional) <- c("restaurant_cuisines","restaurant_zip","n_reviews","avg_rating")

additional$restaurant_zip <- factor(additional$restaurant_zip)

additional$id <- as.character(1:nrow(additional))

training <- cbind(data.frame(reviews_text=text[1:546],hygiene_label=as.numeric(labels[1:546]),stringsAsFactors = FALSE),additional[1:546,])

test <- cbind(data.frame(reviews_text=text[547:length(text)],stringsAsFactors = FALSE),additional[547:nrow(additional),])


save(training,test,file="results/hygiene_prediction/data.RData")
