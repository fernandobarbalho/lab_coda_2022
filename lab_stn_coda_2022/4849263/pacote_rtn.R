install.packages("devtools")
devtools::install_github("tchiluanda/rtn")
#install.packages("colorspace")
#install.packages("tidyverse")

library(rtn)
library(tidyverse)
library(colorspace)

#Busca as contas disponíveis
contas<- rtn::get_full_account_name()

#Examina a estrutura de contas
contas

#Examina os dados de transferência para estados e municipios
#Essa conta foi uma das mais impactadas durante a pandemia~

#A função get_account_data_by_month busca todos os dados da série temporal para uma dada conta para um 
#dado conjunto de meses
apoio_ee_mm<- rtn::get_account_data_by_month("4.3.03  Apoio Fin. EE/MM", #nome completo da conta
                                             month = 1:12, #busca os dados de todos os meses
                                             )

#Dados da série temporal
apoio_ee_mm

#Gráfico da série temporal. Observar o pico na época da pandemia
apoio_ee_mm %>%
  plot_rtn_series()



#Examina gastos com financiamento de campanha eleitoral

rtn::get_account_data_by_month("campanha eleitoral", #nome parcial da conta
                               month=1:12, #busca os dados de todos os meses
                               match_required = FALSE #faz busca pelo nome parcial da conta
                               ) %>%
  plot_rtn_series()

#Compara gastos obrigatórios com gastos discricionários em Saúde
#gastos apresentados nos valores mensais

rtn::get_account_data_by_month("Saúde", #nome parcial da conta
                               month=1:12, #busca os dados de todos os meses
                               match_required = FALSE #faz busca pelo nome parcial da conta
) %>%
  mutate(Rubrica=ifelse(Rubrica=="4.4.1.3 Saúde","Saúde obrigatória", "Saúde discricionária")) %>%
  ggplot()+
  geom_line(aes(x=Data, y= valor_atualizado, color= Rubrica))+
  scale_fill_discrete_qualitative(palette= "Dark 2")+
  theme_light()+
  theme(
    panel.grid = element_blank(),
    panel.background  = element_rect(fill = "black")
  )+
  labs(
    y= "Valor atualizado em R$ mi"
  )
    

#Compara gastos obrigatórios com gastos discricionários em Educação
#gastos apresentados nos valores acumulados em 12 meses

rtn::get_12_month_accumulated_account_data_by_month ( c("4.4.1.4 Educação","4.4.2.2 Educação"), #conjunto de nomes completos de contas
                               month=1:12 #busca os dados de todos os meses
                               ) %>%
  mutate(Rubrica=ifelse(Rubrica=="4.4.1.4 Educação","Educação obrigatória", "Educação discricionária")) %>%
  ggplot()+
  geom_line(aes(x=Data, y= valor_atualizado, color= Rubrica))+
  scale_fill_discrete_qualitative(palette= "Dark 2")+
  theme_light()+
  theme(
    panel.grid = element_blank(),
    panel.background  = element_rect(fill = "black")
  )+
  labs(
    y= "Valor atualizado em R$ mi"
  )



