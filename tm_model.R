library(tm)

setwd("~/Documents/Sem 3 Assignments/ADA")

text <- read.csv('data_final.csv')
class(text)

text1 <- text[sample(nrow(text), 10000),]

docs <- Corpus(VectorSource(text$text))

docs <- tm_map(docs, removeWords, stopwords("english")) # remove stop words (the most common word in a language that can be find in any document)
docs <- tm_map(docs, removePunctuation) # remove pnctuation
docs <- tm_map(docs, stemDocument) # perform stemming (reducing inflected and derived words to their root form)
docs <- tm_map(docs, removeNumbers) # remove all numbers
docs <- tm_map(docs, stripWhitespace) # remove redundant spaces 
docs <- tm_map(docs,content_transformer(tolower))

dtm <- DocumentTermMatrix(docs, control = list(weighting = weightTfIdf))
dtm <- removeSparseTerms(dtm,0.95)
#dtm <- DocumentTermMatrix(docs)

## calculate the tfidf weights
#dtm_tfxidf <- weightTfIdf(dtm)

m <- as.matrix(dtm)
train <- data.frame(m)
train$y <- text$class

library(Rgtsvm)
library(e1071)
model <- svm(y ~ . , data=train)

unique(train$y)

library(xgboost)

dtrain <- xgb.DMatrix(data = data.matrix(train[,-362]), label= train$y)

model_xgb <- xgboost(data=dtrain,
                      nround=25, 
                     objective = "multi:softmax",
                      num_class = 23
                          )

y_pred <- predict(model_xgb,data.matrix(train[,-362]))
y_new <- levels(train$y)[y_pred]
y_new[100]
train$y[100]



save(model, file = "my_model1.rda")
