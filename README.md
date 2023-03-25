
# chatgptAutostats

<!-- badges: start -->
<!-- badges: end -->

The goal of chatgptAutostats is to fit models in R (and potentially query databases later) with ChatGPT!

## Installation

You can install the development version of chatgptAutostats like so:

``` r
devtools::install_github("arkraieski/chatgptAutostats")
```

It's not fully documented yet, this is a work in progress that may change rapidly and/or totally break. 


Please use this package responsibly. Ideally, I think this package should help with model explainable, LLM-fit domain-expert models(linear and logistic regressions,  will be a major focus for this package). Please do not use this package as a "weapon of math destruction"

here's an example with built-in data

``` r
rgpt3::gpt3_authenticate("PATHTO/access_key.txt")
library(chatgptAutostats)
my_model <- chatgpt_lm(df = swiss, predict_col = "Examination")
summary(my_model) # my_model is just a normal R "lm" class object so the normal S3 methods are available
```
