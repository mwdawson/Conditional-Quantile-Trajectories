################################################################################
### Auxiliary functions ########################################################
################################################################################

# Gaussian kernel function
# x0: the value at which to estimate the function
# x: a neighboring data point or vector of points
# b: the bandwidth
K <- function(x0, x, b) {
  exp(-.5 * ((x - x0)/b)^2)
}

# Estimation of a smooth conditional cdf F(z|x) at (z0, x0) using a Gaussian 
# kernel
# z0: the value at which to estimate the conditional cdf
# x0: the conditioning value at which to estimate the conditonal cdf
# z: a vector of points neighboring z0
# x: a vector of points neighboring x0
# b.z: the bandwidth in the z direction
# b.x: the bandwidth in the x direction
SmoothCondCdf <- function(z0, x0, z, x, b.z, b.x) {
  sum(pnorm((z0 - z)/b.z) * K(x0=x0, x=x, b=b.x)) /
    sum(K(x0=x0, x=x, b=b.x))
}

# Estimation of a conditional quantile of Z|X = x0 using a Gaussian kernel
# alpha: a vector of probabilities
# x0: the conditioning value at which to estimate the quantile
# zGrid: the grid to be used for estimating the quantile
# z: a vector of points neighboring z0
# x: a vector of points neighboring x0
# b.z: the bandwidth in the z direction
# b.x: the bandwidth in the x direction
CondQuant <- function(alpha, x0, zGrid, z, x, b.z, b.x) {
  
  # estimate the conditional cdf
  cdf <- sapply(zGrid, function(y) {
    SmoothCondCdf(z0=y, x0=x0, z=z, x=x, b.z=b.z, b.x=b.x)
  })
  
  # extract the quantile
  quant <- sapply(alpha, function(a) zGrid[which.min(abs(cdf - a))])
  
  return(quant)
}