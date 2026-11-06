# The basics of R programming

# Help
?mean
?Chickweights

# Object and functions
5 + 6

a <- 5
b <- 6

a + b

sum(a, b)

ages <- c(5,6)
ages
sum(ages)

?c()

names <- c("John", "James")

friends <- data.frame(names, ages)
View(friends)
str(friends)

# with "$" it is possible to inspect one particular variable
friends$ages
friends$names

sum(friends$ages)

# We can use square brackets to subset 
friends[1,1] # select the element in position [1,1]
friends[1, ] # select the first row and all of the columns
friends[ ,1] # select the first column and all of the rows

# Built in data sets to practice with
data() # Available Data sets in package ‘datasets’
View(Titanic)
View(longley)

# Time series and dates
ts1 <- ts(data = rnorm(n = 24), start = c(2015, 1), end = c(2016, 12), frequency = 12)

library(xts)

xts1 <- as.xts(ts1) # same time seires using xts library
class(xts1)  

xts2 <- xts(x = rnorm(n = 366), order.by = seq(as.Date("2000-01-01"), as.Date("2000-12-31"), by = "day"))
xts3 <- xts(x = rnorm(n = 24), order.by = as.yearmon(seq(as.Date("2000-01-31"), as.Date("2001-12-31"), by = "month")))

date1 <- as.Date("2000-01-01")
date2 <- as.Date("2000-12-31")
diff_date <- as.numeric(date2-date1) + 1
diff_date2 <- difftime(date2,date1, units = c("days")) # probably "+1" needed

xts_4 <- xts(x = rnorm(n = diff_date), order.by = seq(date1, date2, by = "day"))
xts_5 <- xts(x = rnorm(n = 12), order.by = seq(date1, date2, by = "month"))
plot(xts_5)

#Installing and using packages
install.packages("tidyverse")
library(tidyverse)

starwars %>% # example of extra data frame that comes with tidyverse
  filter(height > 150 & mass < 200) %>% #%>% is called 'pipe operator' --> shortcut: Ctrl + Shift + M
  mutate(height_in_meters = height/100) %>%
  select(height_in_meters, mass) %>%
  arrange(mass) %>%
  View()
  #plot()

# Explore
#########

# Data structure and types of variables
View(msleep)

glimpse(msleep)

head(msleep)

class(msleep$name)

length(msleep)

length(msleep$name)

names(msleep)

unique(msleep$vore)

missing <- !complete.cases(msleep)

msleep[missing, ]

# Clean
########

# Select variables
starwars %>% 
  select(name, height, mass) %>% 
  arrange(mass) %>% 
  View()

starwars %>% 
  select(1:3) %>% 
  View()

starwars %>% 
  select(contains("color"))  # 'starts_with' and 'contains' work the same way
  
starwars %>% 
  select(ends_with("color"))  # 'starts/ends_with' and 'contains' work the same way

# Changing variable order
starwars %>% 
  select(name, mass, height, everything()) %>% 
  View()

# Changing variable name
starwars %>% 
  rename("characters" = "name") %>% 
  head()

# Changing a variable type
class(starwars$hair_color)

starwars$hair_color <- as.factor(starwars$hair_color)

class(starwars$hair_color)  

starwars %>% 
  mutate(hair_color = as.character(hair_color)) %>% 
  glimpse()

# Changing factor levels
df <- starwars
df$sex <- as.factor(df$sex)

levels(df$sex)

df <- df %>% 
  mutate(sex = factor(sex, 
                     levels = c("male", "female", "hermaphroditic", "none")))

levels(df$sex)

# Filter rows 
starwars %>% 
  select(mass, sex) %>% 
  filter(mass < 55 &
           sex == "male")

# Recode data
starwars %>% 
  select(sex) %>% 
  mutate(sex = recode(sex,
                      "male" = "man",
                      "female" = "woman"))


# Dealing with missing data
mean(starwars$height, na.rm = TRUE) # na.rm removes not available values

starwars %>% 
  select(name, gender, hair_color, height)

starwars %>% 
  drop_na(hair_color) %>% 
  View()

# Dealing with duplicates
Names <- c("Antonio", "Vittoria", "Alessandro", "Giovanni", "Alessandro")
Age <- c(26, 28, 31, 28, 31)

friends <- data.frame(Names, Age)
friends

friends %>% 
  distinct()

distinct(friends)

# Manipulate
################
# Create or change a variable (mutate)
starwars %>% 
  mutate(height_m = height/100) %>% 
  select(name, height, height_m)

# Conditional change (if_else)
starwars %>% 
  mutate(height_m = height/100) %>% # We can use 'mutate' to add new columns
  select(name, height, height_m) %>% 
  mutate(tallness = if_else(height_m < 1,
                            "short",
                            "tall")) %>% 
  View()

# Reshape data with Pivot wider
library(gapminder)
View(gapminder)

data1 <- select(gapminder, country, year, lifeExp)
data2 <- gapminder[ ,c("country","year","lifeExp")]

data1 == data2 # 5112 osservations = TRUE
table(data1 == data2) # 1 single osservtion = TRUE

# Describe
##############

View(msleep)

# Range / spread
min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake) # Interquartile Range: Differenza interquartile (3o quartile - 1o quartile)

?IQR()
?quantile()

quantile(msleep$awake) # Retruns all quantiles
quantile(msleep$awake, c(0.25,0.75)) # Returns the 1st and 4th quantiles
diff(quantile(msleep$awake, c(0.25,0.75))) == IQR(msleep$awake)

quantile(msleep$awake, c(0.25,0.75))[1]

# Centrality
mean(msleep$awake)
median(msleep$awake)

# Variance
var(msleep$awake)

# Summary table
summary(msleep$awake)
summary(msleep$awake)[3]

msleep %>% 
  select(awake, sleep_total) %>% 
  summary()

# Summarize your data
msleep %>% 
  drop_na(vore) %>% 
  group_by(vore) %>% 
  summarise(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max (sleep_total), 
            Difference = max(sleep_total)-min(sleep_total)) %>% 
  arrange(Average) %>% 
  View()

# Create tables
table(msleep$vore)

msleep %>% 
  select(vore, order) %>% 
  filter(order %in% c("Rodentia", "Primates")) %>% 
  table()

# Visualise
#################

plot(pressure)

# The grammar of graphics
      # data
      # mapping
      # geometry

# Bar plots
ggplot(data = starwars,
       mapping = aes(x = gender))+    # 'mapping =' is not necessary
  geom_bar()

# Histograms
starwars %>% 
  drop_na(height) %>% 
  ggplot(aes(x = height))+ # 'x = ' it's assumed so can be removed
  geom_histogram()

# Box plots
starwars %>% 
  drop_na(height) %>% 
  ggplot(aes(height))+
  geom_boxplot(fill = "steelblue")+
  theme_bw()+
  labs(title = "Boxplot of height",
       x = "Height of charachters")

# Density plots
starwars %>% 
  drop_na(height) %>% 
  filter(sex %in% c("male", "female")) %>% 
  ggplot(aes(height,
             color = sex,
             fill = sex))+
  geom_density(alpha = 0.2)+
  theme_bw()

# Scatter plots
starwars %>% 
  filter(mass < 200) %>% 
  ggplot(aes(x = height, y = mass, color = sex))+ # not necessary to specify 'x = ' and 'y = '
  geom_point(size = 5, alpha = 0.5)+
  theme_bw()+
  labs(title = "Height and mass by sex")

# Smoothed model 
starwars %>% 
  filter(mass < 200) %>% 
  ggplot(aes(height, mass, color = sex))+
  geom_point(size = 3, alpha = 0.8)+
  geom_smooth()+ # Draws a smooth linear model 
  facet_wrap(~sex)+
  theme_bw()+
  labs(title = "Height and mass by sex")

  