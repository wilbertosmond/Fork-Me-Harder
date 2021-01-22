# Preamble: Load libraries and read in DataFrame
library(tidyverse)
library(ggthemes)
df = read_csv2('gender_df.csv')

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
  mutate(Edu_Group=ifelse(Alma_Mater==1|Education==1,1,0), # Mutates new columns for aggregating education, occupation, and family data
         Occ_Group=ifelse(Occupation==1|Profession==1,1,0),
         Family=ifelse(Parent==1|Children==1|Spouse==1|Relative==1|Relation==1,1,0)) %>%
  drop_na()

# Computes Number of Male and Female Entries, and Proportions
gender_num <- group_by(df1, Gender) %>% summarise(Number = n())
# Entries: Males = 534967, Females = 96257
# Proportion: Males = 85%, Females = 0.15%

# Computes relative prevalence of attributes of interest across all (cleaned) 
# DBpedia entries
df_ungrouped <- df1 %>%
  summarise(Perc_Education = sum(Edu_Group)/n(),
            Perc_Occupation = sum(Occ_Group)/n(),
            Perc_NetWorth = sum(Net_Worth)/n(),
            Perc_KnownFor = sum(Known_For)/n(),
            Perc_Family = sum(Family)/n()) %>%
  pivot_longer(c(1, 2, 3, 4, 5),
               names_to = "Labels",
               values_to = "Percentages")

# Plots Ungrouped Attribute Prevalence
ggplot(data = df_ungrouped) +
  aes(x = Labels, y = Percentages) +
  geom_bar(fill = '#666666', position = "dodge", stat = "identity") +
  theme_clean() +
  xlab("Metadata Attributes") +
  ylab("Entries Containing Attribute (%)") +
  scale_x_discrete(labels=c("Education", "Family", "Known For", "Net Worth", "Occupation")) +
  scale_y_continuous(limits = c(0, 0.2), n.breaks = 6, labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata Attributes in Wikipedia Biographies") +
  geom_hline(yintercept=0.05, color="red") +
  annotate("text", x=3.5, y=0.06, label="Inclusion Threshold", size=3)
ggsave('bargraph_ungrouped.pdf')

# Computes relative prevalence of (cleaned) attributes of interest grouped by gender
df_grouped <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Education = sum(Edu_Group)/n(),
            Perc_Occupation = sum(Occ_Group)/n(),
            Perc_Family = sum(Family)/n()) %>%
  pivot_longer(c(2, 3, 4),
               names_to = "Labels",
               values_to = "Percentages")

# Computes relative prevalence of Family-related attributes by gender
df_fam_grouped <- df1 %>%
  group_by(Gender) %>%
  summarise(Perc_Relation = sum(Relation)/n(),
            Perc_Relative = sum(Relative)/n(),
            Perc_Spouse = sum(Spouse)/n(),
            Perc_Children = sum(Children)/n(),
            Perc_Parent = sum(Parent)/n()) %>%
  pivot_longer(c(2, 3, 4,5,6),
               names_to = "Labels",
               values_to = "Percentages")

# Plots Grouped Bar Graphs for Relative Prevalence of Metadata Attributes by Gender
ggplot(data = df_grouped) +
  aes(fill = Gender, x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_clean() +
  xlab("Attributes") +
  ylab("Entries Containing Attribute (% by Gender)") +
  scale_x_discrete(labels=c("Education", "Family", "Occupation")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Relative Prevalence of Metadata Attributes by Gender")
ggsave('bargraph_grouped.pdf')

# Plots Grouped Bargraphs for Relative Prevalence of Family-Related Metadata Attributes by Gender
ggplot(data = df_fam_grouped) +
  aes(fill = Gender, x = Labels, y = Percentages) +
  geom_bar(position = "dodge", stat = "identity", ) +
  theme_clean() +
  xlab("Attributes") +
  ylab("Entries Containing Attribute (% by Gender)") +
  scale_x_discrete(labels=c("Children", "Parent", "Relation","Relative","Spouse")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Relative Prevalence of Family-Related Metadata Attributes by Gender")
ggsave('bargraph_fam_grouped.pdf')

# Total DBpedia Entries: 1,517,815
# Cleaned DBpedia Entries (excl. Fictional Characters & Entries w/o birthDate/birthYear): 975,235
# Total Entries Merged Dataset: 631,258

# Plots Normalized Frequency of Male vs Female Articles by Birth Year
birth_year_df <- read_csv2('birth_year.csv') %>%
  mutate(Birth_Year = as.numeric(Birth_Year)) %>%
  drop_na() %>%
  filter(10 <= Birth_Year & Birth_Year <= 2016) %>%
  drop_na() %>%
  pivot_wider(names_from = Gender, values_from = Birth_Year)

ggplot(data = birth_year_df) +
  geom_histogram(aes(x=MALE, y = stat(count / sum(count)), fill = 'Male'), alpha=0.6, binwidth = 20) +
  geom_histogram(aes(x=FEMALE, y = stat(count / sum(count)), fill = 'Female'), alpha=0.6, binwidth = 20) +
  theme_clean () +
  xlab("Birth Year") +
  ylab("Normalized Frequency") +
  scale_x_continuous(limits = c(1500, 2016)) +
  labs(title = "Distribution of Male vs Female Articles by Birth Year",
       fill="Gender")
ggsave('histogram_gender_birthyear.pdf')