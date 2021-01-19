library(tidyverse)
#library(ggthemes)
setwd("C:/Users/wilbert osmond/Documents/Semester 6/UCACCMET2J/Week 3 - Group Project/accmet2j_demo-master/Fork-Me-Harder")
df = read_csv('gender_df.csv')

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
df2 <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/nrow(df1),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/nrow(df1),
            Perc_NetWorth = sum(Net_Worth)/nrow(df1),
            Perc_KnownFor = sum(Known_For)/nrow(df1),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/nrow(df1))