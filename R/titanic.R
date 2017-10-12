install.packages("titanic")
library(titanic)
help(package = "titanic")
str(titanic_train)
str(titanic_test)
library(ggplot2)
ggplot(data = titanic_train, aes(x = Pclass, y = Fare)) +
geom_point()
ggplot(data = titanic_train, aes(x = factor(Pclass), y = Fare)) +
geom_boxplot()
ggplot(data = titanic_train, aes(x = Fare)) +
geom_histogram()
ggplot(data = titanic_train, aes(x = Fare)) +
geom_histogram(binwidth = 10)
ggplot(data = titanic_train, aes(x = "", y = Fare)) +
geom_boxplot()
  