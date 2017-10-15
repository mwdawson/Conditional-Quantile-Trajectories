# Require KernSmooth for local polynomial smoothing
require(KernSmooth)

# Convert longitudinal snippet data to bivariate data
# t: a list whose elements are vectors of observed time points
# y: a list whose elements are vectors of observed values
# method: how to extract the level and slope
#         - simple: sample mean and least squares fit
#         - localpoly: local polynomial fits for dense snippets
Snippet2XZ <- function(t, y, method='simple', b=NA) {
  
  if(method == 'simple') {
    
    # simple method for level and slope
    X <- sapply(y, mean)
    
    Z <- sapply(1:length(t), function(i) {
      unname(lm(values[[i]] ~ times[[i]])$coef[2])
    })
    
  } else if(method == 'localpoly') {
    
    # local polynomial smoothing for level and slope
    midpts <- sapply(t, function(x) {
      mean(range(x))
    })
    
    X <- sapply(1:length(t), function(i) {
      fit <- locpoly(t[[i]],
                     y[[i]],
                     bandwidth=b)
      return(fit$y[which.min(abs(fit$x - midpts[i]))])
    })
    
    Z <- sapply(1:length(t), function(i) {
      fit <- locpoly(t[[i]],
                     y[[i]],
                     bandwidth=b,
                     drv=1)
      return(fit$y[which.min(abs(fit$x - midpts[i]))])
    })
  }
  
  data.frame(X = X,
             Z = Z)
}