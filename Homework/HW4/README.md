# Homework 4: Machine Learning

```{r, message=FALSE, warning=FALSE, echo=FALSE}
library(dplyr)
library(readr)
library(ggplot2)
library(caret)
library(stringr)
library(tree)
library(MASS)
library(e1071)
library(splitstackshape)
library(randomForest)
```

## Algorithmic Bias
In May 2016, Jeff Larson and others from ProPublica published a story about [algorithmic bias in criminal justice risk assessment scores](https://www.propublica.org/article/machine-bias-risk-assessments-in-criminal-sentencing). These scores are used to inform decisions about who can be set free at every stage of the criminal justice system, from assigning bond amounts to even more fundamental decisions about defendants’ freedom. In Arizona, Colorado, Delaware, Kentucky, Louisiana, Oklahoma, Virginia, Washington and Wisconsin, the results of such assessments are given to judges during criminal sentencing.

In 2014, then U.S. Attorney General Eric Holder warned that the risk scores might be injecting bias into the courts. He called for the U.S. Sentencing Commission to study their use. "Although these measures were crafted with the best of intentions, I am concerned that they inadvertently undermine our efforts to ensure individualized and equal justice," he said, adding, "they may exacerbate unwarranted and unjust disparities that are already far too common in our criminal justice system and in our society." The sentencing commission did not, however, launch a study of risk scores. So ProPublica did, as part of a larger examination of the powerful, largely hidden effect of algorithms in American life.

ProPublica obtained the risk scores assigned to more than 7,000 people arrested in Broward County, Florida, in 2013 and 2014 and checked to see how many were charged with new crimes over the next two years. The score proved remarkably unreliable in forecasting violent crime. In addition, ProPublica was able to show the algorithm was racially biased. 

ProPublica completed a thorough analysis involving logistic regression, survival analysis and other statistical methods ([check out more details here if interested](https://www.propublica.org/article/how-we-analyzed-the-compas-recidivism-algorithm/)), but for this assignment you will be exploring how the algorithm is biased and communicating this bias. 

The data for ProPublica's analysis is contained in the file `compas-scores-two-years.csv`. Below are the variables we will be using:

* `race`: Race of the individual
* `two_year_recid`: Did the individual reoffend (commit another crime) within 2 years?
* `decile_score`: Risk score, 1-10
* `score_text`: score group, "Low": `decile_score` = 1-3, "Medium": `decile_score` = 4-7, "High": `decile_score` = 8-10

### Question 1
While there are several race/ethnicity categories represented in this dataset, we will limit our analyses to those who self-identified as Caucasian or African-American. Read in the data and filter the data frame to only include Caucasian and African-American individuals. How many African-American individuals are represented in this dataset and how many Caucasian individuals are represented?

```{r, warning=FALSE, message=FALSE}
# Your code here
```

### Question 2
Make 2 bar charts of `decile_score`, one for each race group. What do you notice about the distributions of scores for the two groups?

```{r}
# Your code here
```


### Question 3
Is the risk score a good predictor of two-year recidivism (i.e., committing another crime within 2 years)? Create a new variable called `binary_score` that is equal to 0 if `score_text` is equal to "Low" (this will be the "low-risk" group) and 1 otherwise (this will be the "high-risk" group). Create a 2x2 table of `binary_score` and `two_year_recid` using the `table` function. Calculate accuracy, sensitivity, specificity, false positive rate and false negative rate by hand. (Note that you are not able to use the `confusionMatrix` function because you are not testing a model here.) What is the accuracy? Are the sensitivity and specificity balanced? Are the false positive rate and false negative rate balanced?  

* Here, false positive rate is the number of false positives over the total number of true negatives, and false negative rate is the number of false negatives over the total number of true positives.


```{r}
# Your code here
```

### Question 4
Now calculate the accuracy, sensitivity, specificity, false positive rate and false negative rate for each race group. Again, calculate these values without using `confusionMatrix`. Does the algorithm perform better for one group over the other? Describe how the model is biased. 

* Hint: think about what false positives, false negatives, false positive rate and false negative rate mean in this context. 

```{r}
# Your code here
```



## Fetal Health
Reduction of child mortality is reflected in several of the United Nations' Sustainable Development Goals and is a key indicator of human progress. The UN expects that countries aim to reduce under‑5 mortality to at least as low as 25 per 1,000 live births by 2030.

Parallel to the notion of child mortality is of course maternal mortality, which accounts for 295,000 deaths during and following pregnancy and childbirth (as of 2017). The vast majority of these deaths (94%) occurred in low-resource settings, and most could have been prevented.

Cardiotocograms (CTGs) are a simple and cost accessible option to assess fetal health, allowing health care professionals to take action in order to prevent child and maternal mortality. The equipment itself works by sending ultrasound pulses and reading its response, thus shedding light on fetal heart rate (FHR), fetal movements, uterine contractions and more.

We'll be using a dataset that contains 2,126 records of features extracted from Cardiotocogram exams including the baseline fetal heart rate, uterine contractions, and fetal movement. For more details about the dataset, visit this [Kaggle page](https://www.kaggle.com/andrewmvd/fetal-health-classification). The outcome of interest is fetal health classification:

* 1: Normal
* 2: Suspect
* 3: Pathological

We will be using the features available in this dataset to classify fetal health.

Use the following code to read in the data and split it into training and test sets with 60% of the data in the training set and 40% in the test set. Here we use a new function, `stratified`, from the `splitstackshape` package to split the data because we have 3 classes that are not balanced, meaning the number of observations in each class is not equivalent. The `stratified` function samples the same percent of samples from each class - in this case, fetal class. Note: keep `set.seed(1)` so you get the same train/test split and model predictions we do. 

```{r, warning=FALSE, message=FALSE}
fetal <- read_csv("fetal_health.csv")
set.seed(1)
x <- stratified(fetal, "fetal_health", 0.6, keep.rownames = TRUE)
train_set <- x %>% dplyr::select(-rn)
train_index <- as.numeric(x$rn)
test_set <- fetal[-train_index,]
```

### Question 5
Fit a decision tree (classification tree) that predicts `fetal_health` using all other variables in the dataset. What is the overall accuracy of the model, and accuracy for each class? Is the accuracy balanced across classes? Hint: You may need to calculate the accuracy for each class by hand using the confusion matrix.

```{r}
# Your code here
```

### Question 6
Fit a random forest that predicts `fetal_health` using all other variables in the dataset. What is the overall accuracy of the model, and accuracy for each class? Is the accuracy balanced across classes? Hint: You may need to calculate the accuracy for each class by hand using the confusion matrix.

```{r}
# Your code here
```

### Question 7
Fit a kNN model with k = 4 that predicts `fetal_health` using all other variables in the dataset. What is the overall accuracy of the model, and accuracy for each class? Is the accuracy balanced across classes? Hint: You may need to calculate the accuracy for each class by hand using the confusion matrix.

```{r}
# Your code here
```

### Question 8
Of the models you fit in questions 5-7, which model would you choose as the best model for predicting fetal health category? Justify your answer. Be sure to include diagnostic metrics (for example, accuracy, sensitivity, specificity, AUROC, etc.) as part of your justification. You do not need to use all of these metrics - just be sure to mention at least 1 of them. Note there is no one right answer for this question. The point is to make you critically evaluate different models and make an informed choice in model.
