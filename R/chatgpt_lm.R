#' Generate a prompt to get an lm() call from ChatGPT
#' @export
#' @import tibble
#' @importFrom stats cor
#' @importFrom utils capture.output
chatgpt_lm_prompt <- function(df, predict_col){
  base_prompt<- "Hello ChatGPT, you will now play the role of an expert statistics assistant helping a user with a linear regression problem using the R statistical programming language. Your task, from which you are not allowed to deviate, is to use PHD level knowledge of linear regression (OLS), statistical correlations and interactions, R statistical computing, the `lm` function in R, and R's formula interface, along with impeccable statistical intuition, to generate a single line of plain text with just a call to R's `lm()` function to fit what you think will be an optimal linear model (including any interactions you think are worth including in the model) for the user's tibble `df`. Attempt to maximize Adjusted R-squared of the fitted model. The following information about the data and the desired model should be used to complete this task:"

  if(!is.data.frame(df)) stop("df must be a data.frame", call. = FALSE)
  if(!(predict_col %in% names(df))) stop("predict_col not in names(df)", call. = FALSE)
  t <- as_tibble(df) # so we use modern tibble methods


  col_classes <- sapply(t, class)
  col_summary <- summary(t)

  cor_output <- capture.output(print(cor(t)))
  cor_output <- paste(cor_output, collapse = "\n")

  final_prompt <- sprintf("%s I want to use the column %s as the column to predict. The output of dim(df) is: %dx%d. Column names are: %s. The column classes are: %s. The output of summary(df) is: %s. The output of cor(df) is:\n%s. The tibble is called %s.",
                          base_prompt,
                          predict_col,
                          dim(t)[1],
                          dim(t)[2],
                          paste0(names(t), collapse = ", "),
                          paste0(col_classes, collapse = ", "),
                          paste0(col_summary, collapse = ", "),
                          cor_output,
                          deparse(substitute(df)))

  final_prompt
}


#' Fit a linear regression model using ChatGPT
#' @export
#' @importFrom rgpt3 chatgpt_single
chatgpt_lm <- function(df, predict_col){
  my_prompt <- chatgpt_lm_prompt(df, predict_col)
  response <- chatgpt_single(prompt_role = "user",
                 prompt_content = my_prompt,
                 temperature = 0.5,
                 max_tokens = 256,
  )
  # this line of code is not particularly safe, but yolo
  eval(parse(text = response[[1]]$chatgpt_content))
}



