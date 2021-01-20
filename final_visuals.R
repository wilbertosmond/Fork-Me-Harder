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
  filter(!is.na(Alma_Mater) & !is.na(Education) &
           !is.na(Occupation) & !is.na(Profession) &
           !is.na(Net_Worth) & !is.na(Known_For) &
           !is.na(Relation) & !is.na(Relative) & !is.na(Spouse) & !is.na(Children) & !is.na(Parent))

# Compute gender percentage for (grouped) features
#in the sum function there is an arg. called sum.r



# Plot the relative percentages without gender splitting

df3 <- df1 %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/n(),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/n(),
            Perc_NetWorth = sum(Net_Worth)/n(),
            Perc_KnownFor = sum(Known_For)/n(),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/n()) %>%
  pivot_longer(c(1, 2, 3, 4, 5),
               names_to = "Labels",
               values_to = "Percentages") 


ggplot(data = df3) +
  aes(x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_minimal() +
  xlab("Attributes") +
  ylab("Relative Prevalence (%)") +
  scale_x_discrete(labels=c("Education", "Relation", "Known For", "Net-Worth", "Occupation")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata attributes across Wikipedia Biographies")
ggsave('withoutgender.pdf')




# Plot the relative occurrences by gender without Net-Worth because 
# Previous visualization revealed that it was barely present across all entries (less than 1%)


df2 <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/n(),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/n(),
            #Perc_NetWorth = sum(Net_Worth)/n(),
            Perc_KnownFor = sum(Known_For)/n(),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/n()) %>%
  pivot_longer(c(2, 3, 4, 5),
               names_to = "Labels",
               values_to = "Percentages") 

#data.m <- melt(data, id.vars='Names')

ggplot(data = df2) +
  aes(fill = Gender, x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_minimal() +
  xlab("Attributes") +
  ylab("Relative Prevalence (%)") +
  scale_x_discrete(labels=c("Education", "Relation", "Known For", "Occupation")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata attributes by Gender")
ggsave('withgender.pdf')
