#Import data and select useful columns
install.packages("tidyverse")
install.packages("lubridate")
library(tidyverse)
library(lubridate)

plants_raw <- read_csv("plant_data.csv")

plants <- plants_raw %>%
  select(
    id,
    observed_on,
    created_at,
    quality_grade,
    num_identification_agreements,
    num_identification_disagreements,
    captive_cultivated,
    species_guess,
    scientific_name,
    common_name,
    iconic_taxon_name,
    taxon_id
  )
#Create new viariables
plants_clean <- plants %>%
  filter(!is.na(observed_on)) %>%
  mutate(
    observed_on = ymd(observed_on),
    year = year(observed_on),
    month = month(observed_on, label = TRUE, abbr = TRUE),
    cultivation_status = case_when(
      captive_cultivated == TRUE ~ "Cultivated",
      captive_cultivated == FALSE ~ "Non-cultivated",
      TRUE ~ "Unknown"
    )
  )
#Quick check of cleaned data
glimpse(plants_clean)
summary(plants_clean$year)
table(plants_clean$cultivation_status)
table(plants_clean$quality_grade)


#Figure 1 cultivated vs non-cultivated records
cultivation_summary <- plants_clean %>%
  count(cultivation_status) %>%
  mutate(
    percentage = n / sum(n) * 100,
    label = paste0(n, " records\n", round(percentage, 1), "%")
  )
cultivation_summary

figure1 <- ggplot(
  cultivation_summary,
  aes(x = cultivation_status, y = n, fill = cultivation_status)
) +
  geom_col(width = 0.65) +
  geom_text(
    aes(label = label),
    vjust = -0.3,
    size = 4
  ) +
  labs(
    x = NULL,
    y = "Number of observations",
    ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(size = 11)
  )
figure1

#Figure 2 The 15 most frequently recorded plant taxa in the iNaturalist dataset.
top_taxa <- plants_clean %>%
  filter(!is.na(scientific_name)) %>%
  count(scientific_name, cultivation_status, name = "n") %>%
  group_by(scientific_name) %>%
  mutate(total_n = sum(n)) %>%
  ungroup() %>%
  slice_max(total_n, n = 15) %>%
  mutate(
    scientific_name = fct_reorder(scientific_name, total_n)
  )
top_taxa

figure2 <- ggplot(
  top_taxa,
  aes(x = scientific_name, y = n, fill = cultivation_status)
) +
  geom_col(width = 0.7) +
  coord_flip() +
  labs(
    x = NULL,
    y = "Number of observations",
    fill = "Cultivation status"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.y = element_text(size = 10)
  )
figure2

#Figure 3: Monthly pattern of plant observations
plants_clean <- plants %>%
  filter(!is.na(observed_on)) %>%
  mutate(
    observed_on = ymd(observed_on),
    year = year(observed_on),
    month_num = month(observed_on),
    month = factor(
      month_num,
      levels = 1:12,
      labels = c(
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      )
    ),
    cultivation_status = case_when(
      captive_cultivated == TRUE ~ "Cultivated",
      captive_cultivated == FALSE ~ "Non-cultivated",
      TRUE ~ "Unknown"
    )
  )
monthly_summary <- plants_clean %>%
  count(month, name = "n")

figure3 <- ggplot(
  monthly_summary,
  aes(x = month, y = n)
) +
  geom_col(width = 0.7) +
  labs(
    x = "Month",
    y = "Number of observations"
    ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(size = 10)
  )

figure3

#Figure 4 Yearly pattern of plant observations in the iNaturalist dataset
yearly_summary <- plants_clean %>%
  count(year, name = "n")
yearly_summary

figure4 <- ggplot(
  yearly_summary,
  aes(x = year, y = n)
) +
  geom_col(width = 0.75) +
  labs(
    x = "Year",
    y = "Number of observations"
    ) +
  scale_x_continuous(
    breaks = seq(min(yearly_summary$year), max(yearly_summary$year), by = 2)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
figure4