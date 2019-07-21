# Text-Classifier
Classifying News Articles with SVM.
Using SVD for feature reduction.

## wrangling.ipynb
Python program to read the 2 datasets and combine them. Output would be a csv file "data_final.csv"

## tm_model.R
Text Mining on the data_final.csv file using the tm package. And later trying out different classifiers

## svm_gpu.R
Same as tm_model but having the svm classifier to run on a GPU

## data_final.csv
Combined output csv file from wrangling.ipynb
