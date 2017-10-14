# Conditional Quantile Trajectories

## The Statistical Problem

Often times in longitudinal studies, it is difficult to get observations for each subject which span a very long length of time. For example, when the cost of observations is high or obtaining observations is invasive, it may not be feasible to observe each subject over the entire domain of interest. In these cases, resulting observed data may be characterized as **snippets**, which are very short longitudinal segments. Snippet data can be further complicated when time references are not meaningful. A classic example of this situation is in Alzheimer's disease, where time since onset is the meaningful time scale, but age is the only time measurement available.

In these cases, the goal is to understand long-term behavior by utlizing short-term data. By behavior, we mean outcome distributions (quantiles) over time.

## The Conditional Quantile Trajectory Solution

Our approach to solve this is simple and flexible. The first key is that very short longitudinal data give us information about 1) a subject's current status, and 2) their current rate of change. Another way to say this is that we have bivariate information for each subject, representing **level** and **slope**. We can then model outcomes dynamically through differential equation models.

## Code

## References

For more information, see the corresponding paper: 

Matthew Dawson and Hans-Georg M&uuml;ller, [Dynamic Modeling of Conditional Quantile Trajectories, with Application to Longitudinal Snippet Data](http://www.tandfonline.com/doi/abs/10.1080/01621459.2017.1356321) (2017), *to appear in Journal of the American Statistical Association, Theory and Methods*
