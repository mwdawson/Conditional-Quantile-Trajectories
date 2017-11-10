source('CondQuant.R')
# Estimation of a conditional quantile trajectory using Euler's method for
# numerical integration. This uses CondQuant() as the gradient function. This
# function returns a data.frame containing conditional quantile trajectories.
# alpha: a vector of probabilities
# startingX: the conditioning value at which to estimate the quantile
# zGrid: the grid to be used for estimating the quantile
# xGrid: the grid to be used for the conditioning value
# z: a vector of points neighboring in the Z-direction (slopes)
# x: a vector of points neighboring in the X-direction (levels)
# b.z: the bandwidth in the Z-direction
# b.x: the bandwidth in the X-direction
# delta: the increment for use in Euler's method
# endTime: when to stop the Euler integration
# direction: 'increasing' or 'decreasing' underlying process
CondQuantTraj <- function(alpha,
                          startingX,
                          zGrid,
                          z,
                          x,
                          b.z,
                          b.x,
                          delta,
                          endTime,
                          direction) {
  
  # guess at direction if it is not specified
  if(is.null(direction)) {
    direction <- ifelse(mean(z) >= 0, 'increasing', 'decreasing')
  }
  
  # specify a stopping level to avoid estimation without data
  stoppingLevel <- ifelse(direction == 'increasing', max(x), min(x))
  
  # initialize output
  s <- seq(0, endTime, by=delta)
  alphaColNames <- paste0('alpha', alpha)
  out <- data.frame(s,
                    matrix(nrow=length(s),
                           ncol=length(alpha),
                           NA))
  names(out) <- c('s', alphaColNames)
  out[1, 2:ncol(out)] <- startingX
  
  # implement Euler's method on all quantiles
  i <- 2
  while(i <= nrow(out)) {
    for(j in 1:length(alpha)) {
      
      # current state
      current <- out[i-1, j+1]
      
      # update
      if(!is.na(current)) {
        tmp <- current + delta*CondQuant(alpha=alpha[j],
                                         x0=current,
                                         zGrid=zGrid,
                                         z=z,
                                         x=x,
                                         b.z=b.z,
                                         b.x=b.x)
        if(direction == 'increasing') {
          if(tmp > stoppingLevel) {
            out[i, j+1] <- NA
          } else if(tmp <= current) {
            out[i, j+1] <- current
          } else {
            out[i, j+1] <- tmp
          }
        } else if(direction == 'decreasing') {
          if(tmp < stoppingLevel) {
            out[i, j+1] <- NA
          } else if(tmp >= current) {
            out[i, j+1] <- current
          } else {
            out[i, j+1] <- tmp
          }
        }
      } else {
        out[i, j+1] <- NA
      }      
    }
  }
  
  return(out)
}
