# mixed.zelig unit test

library(ZeligMixed)

data(voteincome)

z.out <- zelig(
               vote ~ education + age + female + tag(1 | state),
               data = voteincome,
               model="logit.mixed"
               )

##  Setting the explanatory variables at their default values
##  (mode for factor variables and mean for non-factor variables),
##  with education set to 80th and 20th percentiles.

x.low <- setx(z.out, education=quantile(voteincome$education, 0.8))
x.high <- setx(z.out, education=quantile(voteincome$education, 0.2))

##  Simulating draws using the default bootstrap method.

s.out <- sim(z.out, x = x.low, x1 = x.high)


#
summary(z.out)
vcov(z.out)
coef(z.out)
x.low
x.high
