library(tidyverse)
install.packages("ggthemes")
library(ggthemes)
#library(ggthemes)
setwd("~/Fork-Me-Harder")
df = read_delim('gender_df.csv', ';')

# Count non-NA for each column
df1 <- df %>%
  mutate(Alma_Mater=ifelse(Alma_Mater=='None',0,1),
         Education=ifelse(Education=='None',0,1),
         Occupation=ifelse(Occupation=='None',0,1),
         Profession=ifelse(Profession=='None',0,1),
         Net_Worth=ifelse(Net_Worth=='None',0,1),
         Known_For=ifelse(Known_For=='None',0,1),
         Relation=ifelse(Relation=='None',0,1),
         Relative=ifelse(Relative=='None',0,1),
         Spouse=ifelse(Spouse=='None',0,1),
         Children=ifelse(Children=='None',0,1),
         Parent=ifelse(Parent=='None',0,1)) %>%
  filter(!is.na(Relation) & !is.na(Relative) & !is.na(Spouse) & !is.na(Children) & !is.na(Parent) & !is.na(Occupation))

# Compute gender percentage for (grouped) features
#in the sum function there is an arg. called sum.r

df2 <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/n(),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/n(),
            Perc_NetWorth = sum(Net_Worth)/n(),
            Perc_KnownFor = sum(Known_For)/n(),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/n()) %>%
  pivot_longer(c(2, 3, 4, 5, 6),
             names_to = "Labels",
             values_to = "Percentages") 

#data.m <- melt(data, id.vars='Names')

ggplot(data = df2) +
  aes(fill = Gender, x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_minimal() +
  xlab("Attributes") +
  ylab("Percentage of Occurences") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Occurence of different attributes in male and female Wikipedia accounts", subtitle = "The Percentages of label Occuranc out of the total Wikipedia Pages in our Sample")
