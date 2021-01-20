# Preamble: Load libraries and read in DataFrame

library(tidyverse)
df = read_delim('gender_df.csv', ';')

# Mutate Columns to indicate 0 (Absence) or 1 (Presence) for each metadata 
# attribute of interest and remove rows for which NA values are present
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
  drop_na()

# Computes relative prevalence of attributes of interest across all (cleaned) 
# DBpedia entries
df_ungrouped <- df1 %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/n(),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/n(),
            Perc_NetWorth = sum(Net_Worth)/n(),
            Perc_KnownFor = sum(Known_For)/n(),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/n()) %>%
  pivot_longer(c(1, 2, 3, 4, 5),
               names_to = "Labels",
               values_to = "Percentages") 

# Plots Ungrouped Attribute Prevalence
ggplot(data = df_ungrouped) +
  aes(x = Labels, y = Percentages) +
  geom_bar(color = 'black', fill = '#FFC300', position = "dodge", stat = "identity", ) +
  theme_clean() +
  xlab("Metadata Attributes") +
  ylab("Entries Containing Attribute (%)") +
  scale_x_discrete(labels=c("Education", "Relation", "Known For", "Net-Worth", "Occupation")) +
  scale_y_continuous(limits = c(0, 0.2), n.breaks = 6, labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata Attributes in Wikipedia Biographies")
ggsave('bargraph_ungrouped.pdf')

# Computes relative prevalence of (cleaned) attributes of interest grouped by gender
df_grouped <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Education = (sum(Alma_Mater)+sum(Education))/n(),
            Perc_Occupation = (sum(Occupation)+sum(Profession))/n(),
            Perc_Family = (sum(Relation)+sum(Relative)+sum(Spouse)+sum(Children)+sum(Parent))/n()) %>%
  pivot_longer(c(2, 3, 4),
               names_to = "Labels",
               values_to = "Percentages") 

# Plots 
ggplot(data = df_grouped) +
  aes(fill = Gender, x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_clean() +
  xlab("Attributes") +
  ylab("Entries Containing Attribute (% by Gender)") +
  scale_x_discrete(labels=c("Education", "Relation", "Occupation")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata Attributes by Gender")
ggsave('bargraph_grouped.pdf')

# Total DBpedia Entries: 1,517,815
# Cleaned DBpedia Entries (excl. Fictional Characters & Entries w/o birthDate/birthYear): 975,235
# Total Entries Merged Dataset: 631,258