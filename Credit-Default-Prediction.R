library(PerformanceAnalytics)
library(ggplot2)
library(miscset)
library(ROCR)

############################################################
# 1. Consider the German credit dataset from Mini Project 2. 
############################################################
german_credit <- read.csv("germancredit.csv")

#checking for missing data
sum(is.na(german_credit))
sum(is.null(german_credit))

#Changing ShellType from chr to factor
german_credit$Default <- factor(german_credit$Default)
german_credit$checkingstatus1 = as.factor(german_credit$checkingstatus1)
german_credit$history = as.factor(german_credit$history)
german_credit$purpose = as.factor(german_credit$purpose)
german_credit$savings = as.factor(german_credit$savings)
german_credit$employ = as.factor(german_credit$employ)
german_credit$status = as.factor(german_credit$status)
german_credit$others = as.factor(german_credit$others)
german_credit$property = as.factor(german_credit$property)
german_credit$otherplans = as.factor(german_credit$otherplans)
german_credit$housing = as.factor(german_credit$housing)
german_credit$job = as.factor(german_credit$job)
german_credit$tele = as.factor(german_credit$tele)
german_credit$foreign = as.factor(german_credit$foreign)
str(german_credit)
#We will take Default as the response and would like to understand how it is related with other variables in the data.
train_Y<- german_credit[['Default']]
train_X <- german_credit[,-1]

# (a) Perform an exploratory analysis of data.
german_credit_quantative_predictors = german_credit[,c(3, 6, 9, 12, 14, 17, 19)]
chart.Correlation(german_credit_quantative_predictors)

#Frequency plot to see distribution of Defaulted Borrowers
barplot(table(german_credit$Default),
        main="Default Frequency Plot",
        xlab="Defaulted",
        ylab="Number of People",
        border=c("red","blue"),
        col=c("red","blue"),
        density=20
)
legend("topright",
       c("Not-Defaulted","Defaulted"),
       fill = c("red","blue"),
       density = 20
)
#Frequency plot to see distribution of categorical values
ggplotGrid(ncol = 2,
           lapply(c("checkingstatus1", "history",
                    "purpose","savings",
                    "employ","status",
                    "others", "property",
                    "otherplans", "housing",
                    "job", "foreign"
                    ),
                  function(col) {
                    ggplot(german_credit, aes_string(col, fill= col)) + geom_bar() + coord_flip()
                  }))

#(b) Build a “reasonably good” logistic regression model for these data. 
#There is no need to explore interactions. Carefully justify all the choices 
#you make in building the model.

#Fit a full model and check the summary to see important predictors
full_model_credit = glm(Default ~ ., 
                 family = binomial, data = german_credit)
summary(full_model_credit)

#From a full model, now I will fit a reduced model that are important predictors
reduced_model_credit = glm(Default ~
                    checkingstatus1 + 
                    history + 
                    purpose + 
                    amount +
                    savings +
                    installment +
                    status + 
                    others + 
                    otherplans +
                    foreign,
                    family = binomial, data = german_credit)
summary(reduced_model_credit)

#Comparing the full and reduced model using Chisquare
#the resulsts show that the reduced_model fits the dataset better.
anova(full_model_credit, reduced_model_credit, test = "Chisq")

mini_model_credit = glm(Default ~ 
                 checkingstatus1 + 
                 history + 
                 purpose + 
                 amount + 
                 savings + 
                 installment + 
                 otherplans + 
                 foreign, 
                 family = binomial, data = german_credit)
#we can see that all of the predictors are important in this model
#thus we will not add or reduce to this model
summary(mini_model_credit)

#Comparing the reduced and mini model using Chisquare
#the resulsts show that the mini_model fits the dataset better.
anova(reduced_model_credit, mini_model_credit, test = "Chisq")

#Creating a list of all models to apply r2, mse, aic and bic
all_models <- list(full_model_credit, reduced_model_credit, mini_model_credit)
all_aic <- sapply(all_models, AIC) #AIC
all_bic <- sapply(all_models, BIC) #BIC

#combing all values into a df
all_criterions <- cbind(all_aic, all_bic)
colnames(all_criterions) <- c("AIC", "BIC")
rownames(all_criterions) <- c("full","reduced", "mini")
#Round to three decimals places
#We can see the best model is the mini_model
#It has lowest BIC, deviance and very close AIC to other
round(all_criterions, 3)


# (c) Write the final model in equation form. 
final_model <- mini_model_credit
coef_final_model <- coef(final_model)
(eqn <- paste("Default =", paste(round(coef_final_model[1],2), paste(round(coef_final_model[-1],2), names(coef_final_model[1]), sep=" * ", collapse=" + "), sep=" + "), "+error"))
#Provide a summary of estimates of the regression coefficients, 
#the standard errors of the estimates, 
summary(final_model)

#and 95% confidence intervals of the coefficients. 
confint(final_model)

# Interpret the estimated coefficients of at least two predictors. Provide training error rate for the model.
prediction_german_credit <- predict(final_model, german_credit[,-1], type = "response")
prediction <- ifelse(prediction_german_credit >= 0.5, "1", "0")
confusion_matrix <- table(prediction, german_credit[, 1])
training_error <- mean(prediction!=german_credit$Default)
training_error

# Plot Logistic Regression Model for German Credit
#getting prediciton and performance
german_pred <- prediction(prediction_german_credit, german_credit$Default)
german_perf <- performance(german_pred,"tpr","fpr")
german_auc <- performance(german_pred, measure = "auc")

#getting auc value
auc<- german_auc@y.values[[1]]
auc = round(auc, 3)
title <- paste("ROC Curv For Default Classification using Logistic Regression\n AUC = ", auc )   

#plotting roc curve
plot(german_perf,col="red")
title(main = title)
abline(a = 0, b = 1)
legend("bottomright",
       legend=c("Logistic Regression"),
       col=c("red"),
       lty=c(1))


