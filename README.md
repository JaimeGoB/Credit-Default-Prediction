# Credit-Default-Prediction

## Exploratory Data Analysis

### Frequency Plot of Default Creditors for Response Variable

In this plot we are able to the see the amount of people that defaulted and did not default.

<img src="https://github.com/JaimeGoB/Credit-Default-Prediction/blob/main/plots/frequency.png" width="400" height="400" />

### Frequency Plots for Categorial Variables in Dataset

<img src="https://github.com/JaimeGoB/Credit-Default-Prediction/blob/main/plots/categorial_frequency.png" />

### Correlation Plots for Numerical Variables in Dataset


<img src="https://github.com/JaimeGoB/Credit-Default-Prediction/blob/main/plots/correlation.png" />
          

## Comparing Models of Different Sizes

Full Model: 19 predictor variables
Reduced Model: 10 predictor variables
Mini Model: 8 predictor variables

Using AIC and BIC we will make the choice to chose one of three models as the final model. The model I will choose will be the mini-model, it has lower BIC, slighlty-almost insignificant higher AIC. However, it has the lower amount of predictors, thus making it more easy to interpret and less complex.

<img src="https://github.com/JaimeGoB/Credit-Default-Prediction/blob/main/plots/ic.png" width="250" height="150" />


## Results

Mini Model Equation:

Default = 0.57 + -0.44 * (Intercept) + -1.03 * (Intercept) + -1.77 * (Intercept) + -0.18 * (Intercept) + -0.87 * (Intercept) + -1 * (Intercept) + -1.64 * (Intercept) + -1.57 * (Intercept) + -1.46 * (Intercept) + -0.56 * (Intercept) + -0.84 * (Intercept) + -0.35 * (Intercept) + -0.18 * (Intercept) + 0.26 * (Intercept) + -2.04 * (Intercept) + -0.63 * (Intercept) + 0 * (Intercept) + -0.16 * (Intercept) + -0.4 * (Intercept) + -1.2 * (Intercept) + -0.92 * (Intercept) + 0.32 * (Intercept) + -0.07 * (Intercept) + -0.54 * (Intercept) + -1.52 * (Intercept) +error


<img src="https://github.com/JaimeGoB/Credit-Default-Prediction/blob/main/plots/roc.png" width="400" height="400" />
