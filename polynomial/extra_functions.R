
size_checked<- function(num,d){
  checked_sizes<- vector("numeric")
  for(m in 1:num){
    N<- floor(tot_size[m]/(d+2+d*(d-1)/2))
    if(N>=2) checked_sizes<- c(checked_sizes,N*(d+2+d*(d-1)/2))
  }
  return(checked_sizes)
}

closest_greater <- function(x, c) {
  idx <- which.min(abs(x - c))

  if (x[idx] >= c) {
    return(idx)
  } else {
    return(idx+1)
  }
}


get_pred_inds<- function(size,nwant){
  sample_every<- round(size/nwant)
  steps_select<- seq(1,size,by=sample_every)
  return(steps_select)
}