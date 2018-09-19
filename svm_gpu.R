library(tm)

text <- read.csv('data_final.csv')

docs <- Corpus(VectorSource(text$text))

docs <- tm_map(docs, removeWords, stopwords("english")) # remove stop words (the most common word in a language that can be find in any document)
docs <- tm_map(docs, removePunctuation) # remove pnctuation
docs <- tm_map(docs, stemDocument) # perform stemming (reducing inflected and derived words to their root form)
docs <- tm_map(docs, removeNumbers) # remove all numbers
docs <- tm_map(docs, stripWhitespace) # remove redundant spaces 
docs <- tm_map(docs,content_transformer(tolower))

dtm <- DocumentTermMatrix(docs, control = list(weighting = weightTfIdf))
dtm <- removeSparseTerms(dtm,0.95)

m <- as.matrix(dtm)
train <- data.frame(m)
train$y <- text$class

library(Rgtsvm)
svm_model <- svm(y ~ . , data=train)

save(svm_model, file = "svm_model_gpu.rda")

