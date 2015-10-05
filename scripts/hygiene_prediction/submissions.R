n <- 12753

# Random guessing
# Accuracy	      Precision 0	    Precision 1	    Recall 0	      Recall 1	      Precision	      Recall	        F1
# 0.497922057555	0.991505427088	0.0073483427142	0.498182105596	0.465346534653	0.499426884901	0.481764320125	0.490436629322

set.seed(200)
random <- sample(0:1,n,replace=TRUE)

f <- file('results/hygiene_prediction/submissions/01-random.txt')
writeLines(c("Belethia",random),f)
close(f)

# All 1s
# Accuracy	        Precision 0	    Precision 1	      Recall 0	        Recall 1	      Precision	      Recall	        F1
# 0.00799811808986	1.0	            0.00792032622334	7.90388871325e-05	1.0	            0.503960163112	0.500039519444	0.501992186172
f <- file('results/hygiene_prediction/submissions/02-all_1s.txt')
writeLines(c("Belethia",0,rep(1,n-1)),f)
close(f)


# All 0s
# Accuracy	        Precision 0	    Precision 1	      Recall 0	        Recall 1	      Precision	      Recall	        F1
# 0.00799811808986	1.0	            0.00792032622334	7.90388871325e-05	1.0	            0.503960163112	0.500039519444	0.501992186172
f <- file('results/hygiene_prediction/submissions/03-all_0s.txt')
writeLines(c("Belethia",1,rep(0,n-1)),f)
close(f)


# Random Forest
# Accuracy	        Precision 0	    Precision 1	      Recall 0	        Recall 1	      Precision	      Recall	        F1
# 0.613189053556	  0.994871137325	0.0123132821962	  0.613262725261	  0.60396039604	  0.503592209761	0.60861156065	  0.551143682242
load('results/hygiene_prediction/random_forest.RData')
f <- file('results/hygiene_prediction/submissions/04-random_forest.txt')
writeLines(c("Belethia",submission.prediction),f)
close(f)

# SVM
# Accuracy	        Precision 0	    Precision 1	      Recall 0	        Recall 1	      Precision	      Recall	        F1
# 
load('results/hygiene_prediction/svm.RData')
f <- file('results/hygiene_prediction/submissions/05-svm.txt')
writeLines(c("Belethia",submission.prediction),f)
close(f)

# Logistic
# Accuracy	        Precision 0	    Precision 1	      Recall 0	        Recall 1	      Precision	      Recall	        F1
# 
load('results/hygiene_prediction/logistic.RData')
f <- file('results/hygiene_prediction/submissions/06-logistic.txt')
writeLines(c("Belethia",submission.prediction),f)
close(f)

