#' Compute Quantities of Interest for the Zelig Model poisson.mixed
#' @usage \method{qi}{poisson.mixed}(obj, x, x1=NULL, y=NULL, num=1000, param=NULL)
#' @S3method qi poisson.mixed
#' @param obj a zelig object
#' @param x a setx object
#' @param x1 an optional setx object
#' @param y ...
#' @param num an integer specifying the number of simulations to compute
#' @param param a parameters object
#' @return a list of key-value pairs specifying pairing titles of quantities of interest
#'         with their simulations
#' @author Matt Owen and Gregor Gorjanc and Ferdinand Alimadhi and Delia
qi.poisson.mixed <- function(obj, x=NULL, x1=NULL, y=NULL, num=1000, param=NULL) {

  # extract parameters from `zelig' object
  data <- obj$data
  form <- get("formula", attr(obj, "state"))

  # extract simulated parameters from `param' object
  betas <- coef(param)
  gammas <- alpha(param)$gamma
  alpha <- alpha(param)$scale

  x1.matrix <- setup.x.matrix(form, x)
  x2.matrix <- setup.x.matrix(form, x1)

  # compute terms
  mixed.terms1 <- compute.mixed.terms(form, x1.matrix, data)
  mixed.terms2 <- compute.mixed.terms(form, x2.matrix, data)

  # extract relevant terms
  # this is purely for code clarity
  fixed1 <- mixed.terms1$f.terms
  random1 <- mixed.terms1$r.terms

  fixed2 <- mixed.terms2$f.terms
  random2 <- mixed.terms2$r.terms

  #
  qi1 <- .compute.poisson.ev.and.pv(fixed1, random1, param=param, data)
  qi2 <- .compute.poisson.ev.and.pv(fixed2, random2, param=param, data)

  list(
       "Expected Values: E(Y|X)" = qi1$ev,
       "Predicted Valus: Y|X" = qi1$pv,
       "Expected Values: E(Y|X1)" = qi2$ev,
       "Predicted Values: Y|X1" = qi2$pv,
       "Risk Ratios: E(Y|X1) / E(Y|X)" = qi2$ev / qi1$ev,
       "First DIfferences: E(Y|X1) - E(Y|X)" = qi2$ev - qi1$ev
       )
}


#' Compute Mixed Gamma Expected Values
#' It seems this function is in need of heavy repair.
#' In particular, the exclusive presence of Inf and
#' numerically zero results 
#' @param fixed fixed values
#' @param random random values
#' @param param the `parameters' object
#' @return a list containing simulated expected values (ev),
#'         predicted values (pv) and warnings accrued from
#'         simulating the predicted values
#' @author Matt Owen \email{mowen@@iq.harvard.edu}
.compute.poisson.ev.and.pv <- function(fixed, random, ..., param, data) {
  if (is.null(fixed) || is.null(random))
    return(list(ev=NA, pv=NA))

  # 
  betas <- param$coef
  gammas <- alpha(param)$gamma
  alpha <- alpha(param)$scale

  # number of simulations
  num <- nrow(betas)

  #f.cols <- colnames(model.matrix(fixed, data=data))

  fixed.matrix <- as.matrix(as.numeric(fixed))
  fixed.matrix <- (fixed.matrix)
  
  mu <- eta <- betas %*% fixed.matrix

  # Something is wrong here...
  #for (k in 1:length(random)) {
  #  print(random[[k]])
  #  left <- gammas[[names(random[[k]])]]
  #  right <- t(as.matrix(random[[k]]))
  #  mu <- mu + left %*% right
  #}

  inv <- linkinv(param)
  alpha <- alpha(param)$scale

  theta <- matrix(inv(eta), nrow = num)
  mut <- matrix(inv(mu), nrow = num)

  ev <- theta
  pr <- matrix(NA, num)
  pv.warnings <- c()

  for (k in 1:ncol(mut)) {
    pr[, k] <- rpois(num, lambda = mut[, k])
  }

  # return qi's and predicted value warnings
  list(ev = ev, pv = pr, pv.warnings = pv.warnings)
}

#' 
#'

