devtools::install_github("tchiluanda/Rgfs")

library(Rgfs)
dataCompleteTimeSeries(account="Despesa") %>% 
  graphCompleteTimeSeries(selected_country="Brasil", text_max = FALSE )

Rgfs::dataAccountDistribution() %>%
  graphAccountDistribution()