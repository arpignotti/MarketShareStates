MA Market Share State Map Application
========================================================
author: Arthur Pignotti
date: 12/21/2015

What is Medicare Advantage
========================================================

- Also known is Medicare Part C or MA, it is an alternative to Original Medicare where the goverment pays plans a monthly capitated rate for beneficiaries that have chosen a particular plan.
- This is in comparison to Original Medicare or Fee-For-Service (FFS) where the the government pays healthcare providers directly for a particular service any time an eligible beneficiary receives a service.
- Since MA more closely resembles private health insurance models the percent of beneficiaries in MA in comparison to FFS is growing and while there are hundreds of parent organizations in MA, the top ten largest organization like UnitedHealth and Aetna managed about 80% of the beneficiaries

The Application
========================================================

- The purpose of the application is to allow the user the ability to examine the state market share of nine of the largest health insurance parent organizations.
- The user can select a parent organizations and then use the slider to view historical, current, and future (estimated) enrollment years from 2010-2020.
- For historical and current years, the application simply maps a section of the processed dataset.
- For future years, the application calculates a linear model for each state to predict the market share of a parent organization in a state.


Prediction Example
========================================================




```r
models <- dlply(united,"State.Name", function(df) lm(percent ~ year, data = df))
model <- ldply(models,coef)
colnames(model) <- c('state','int','year')
model$new <- as.integer((model$int + (model$year * 2017))*100)
model[model$state == 'maryland',]
```

```
      state       int       year new
19 maryland -93.56914 0.04656152  34
```

Application Importance and Limitations
========================================================

- As MA and the health insurance industry as a whole becomes increasingly consolidated, it will be important to understand how parent organizations will dominate and affect regions.
- With up-coming, high-profile mergers between CIGNA and Anthem, and Aetna and Humana, this trend will possibly accelerate, decreasing innovation and choice in the market.
- As for the application, since the application only uses linear models it may overrepresent continued growth or decline particularly when you get closer to 2020.
- Also, the model does not take competing organizations into consideration so some states in this application may show greater than 100% market share when combining parent organizations.
