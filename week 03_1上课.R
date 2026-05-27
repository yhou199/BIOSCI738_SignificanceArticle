first_leg_outfits <- c("Pink", "Green", "Pink", "Green", "Green", "Pink", "Yellow", 
                       "Pink", "Green", "Yellow", "Pink", "Green", "Green", "Pink", 
                       "Yellow", "Pink", "Green", "Yellow", "Pink", "Yellow", "Green", 
                       "Yellow", "Green", "Pink", "Pink", "Green", "Yellow", "Pink", 
                       "Green", "Yellow", "Pink", "Yellow", "Yellow", "Pink", "Green", 
                       "Pink", "Pink", "Yellow", "Yellow", "Pink", "Green", "Pink", 
                       "Pink", "Yellow", "Pink", "Pink", "Pink", "Pink", "Yellow", "Green", 
                       "Blue", "Blue", "Pink", "Green", "Yellow", "Blue", "Pink", "Yellow", 
                       "Yellow", "Blue", "Green", "Blue", "Yellow", "Green", "Blue", 
                       "Yellow", "Pink", "Green", "Yellow", "Pink", "Blue", "Pink", 
                       "Blue", "Yellow", "Green", "Yellow", "Green", "Pink", "Pink", 
                       "Yellow", "Blue")
europe_leg_outfits <- c("Flamingo pink", "Ocean blue", "Sunset orange", "Ocean blue", 
                        "Flamingo pink", "Sunset orange", "Ocean blue", "Sunset orange", 
                        "Flamingo pink", "Sunset orange", "Ocean blue", "Flamingo pink", 
                        "Sunset orange", "Ocean blue", "Sunset orange", "Flamingo pink", 
                        "Flamingo pink", "Ocean blue", "Sunset orange", "Sunset orange", 
                        "Sunset orange", "Ocean blue", "Flamingo pink", "Ocean blue", 
                        "Flamingo pink", "Sunset orange", "Sunset orange", "Ocean blue", 
                        "Flamingo pink", "Sunset orange", "Flamingo pink", "Sunset orange", 
                        "Ocean blue", "Sunset orange", "Ocean blue", "Flamingo pink", 
                        "Sunset orange", "Ocean blue", "Flamingo pink", "Sunset orange", 
                        "Ocean blue", "Sunset orange", "Flamingo pink", "Ocean blue", 
                        "Flamingo pink", "Sunset orange", "Flamingo pink", "Sunset orange")
final_leg_outfits <- c("Cotton candy", "Blurple", "Grapefruit", "Popsicle", "Sunset orange", 
                       "Blurple", "Cotton candy", "Popsicle", "Grapefruit", "Popsicle", 
                       "Blurple", "Grapefruit", "Cotton candy", "Popsicle", "Blurple", 
                       "Blurple", "Blurple", "Blurple")
## helper function to make a transition matrix
transitions <- function(x) {
  n <- length(x)
  table(x[-n], x[-1])
}
first_leg_outfits |> transitions()
europe_leg_outfits |> transitions()
final_leg_outfits |> transitions()

## helper function
randomisation <- function(data, nreps = 1000, seed = 1984){
  sampling_dist <- numeric(nreps)
  set.seed(seed) 
  for (i in 1:nreps) {
    sampling_dist[i] <- suppressWarnings(sample(data) |> 
                                           transitions() |> 
                                           chisq.test())$statistic
  }
  return(sampling_dist)
}
## first leg
null_first <- randomisation(first_leg_outfits)
mean(null_first >= (first_leg_outfits |> transitions() |> chisq.test())$statistic)
## now try the other legs!
## compare to a traditional Chi-square test
## does your inference make sense?
## create a plot comparing your sampling distribution
## of the test statistic under the NULL and the
## observed value

## helper function
randomisation <- function(data, from, to, 
                          nreps = 1000, seed = 1984){
  sampling_dist <- numeric(nreps)
  set.seed(seed) 
  for (i in 1:nreps) {
    sampling_dist[i] <- (sample(data) |> transitions())[from, to]
  }
  return(sampling_dist)
}
## European leg, Ocean blue --> Ocean blue
null_mid <- randomisation(europe_leg_outfits, from = "Ocean blue", to = "Ocean blue")
obs_mid <- (europe_leg_outfits |> transitions())["Ocean blue", "Ocean blue"]
mean(abs(null_mid - mean(null_mid)) >= abs(obs_mid - mean(null_mid)))
## now try the other legs and/or other transitions!
## does your inference make sense?
## create a plot comparing your sampling distribution
## of the test statistic under the NULL and the
## observed value
## Devise your own metric to represent what is of interest to you