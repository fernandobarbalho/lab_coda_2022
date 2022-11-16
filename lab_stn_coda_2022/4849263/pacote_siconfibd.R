devtools::install_github("tchiluanda/siconfiBD")
library(siconfiBD)

#Faz a conexão com o BD. O argumento deve ser substituído pelo seu projeto no googlecloud.
#Para saber como criar um projeto no google cloud acesse: 
#https://github.com/fernandobarbalho/lab_coda_2022

siconfiBD::setup_siconfi("nice-diorama-306223")



#buscar as contas disponíveis
contas_siconfi<- siconfiBD::get_distinct_rev_account()


#Buscar as contas que se associam a iptu na série temporal de 2013 a 2020
contas_iptu<- siconfiBD::get_rev_account_by_name(year = 2013:2020, name="Imposto sobre a Propriedade Predial e Territorial Urbana") 


contas_iptu_coleta_coleta<-
contas_iptu %>%
  filter(portaria %in% c("1.1.1.2.02.00.00","1.1.1.8.01.1.0")) %>%
  arrange(ano)

#Busca a participação do iptu no total de receitas de Fortaleza e Ipueiras

#2304400 - Código ibge Fortaleza
#2305902 - Código ibge Ipueiras  

dados_iptu<-
siconfiBD::get_perc_budgetary_rev_municipality(year = 2013:2020,
                                               municipality = c("2304400","2305902"),
                                               account = unique(contas_iptu_coleta_coleta$conta))

dados_iptu %>%
  mutate(nome_municipio = ifelse(id_municipio=="2304400",'Fortaleza',"Ipueiras"),
         ano = as.factor(ano)) %>%
  ggplot()+
  geom_line(aes(x=ano, y=perc, color = nome_municipio, group = nome_municipio ))


#busca as funções de governo
funcoes<- siconfiBD::get_distinct_function()

#busca a evolução do gasto com assitência hospitalar e ambulatorial de Recife

#2611606- ibge Recife
#função- Assistência Hospitalar e Ambulatorial

dados_gastos_hosiptalar<- 
  siconfiBD::get_function_expenses_municipality(year = 2013:2020,
                                                 municipality = "2611606",
                                                 gov_function = funcoes$conta[9],
                                                expense_stage = "Despesas Pagas")
dados_gastos_hosiptalar %>%
  mutate(ano= as.factor(ano)) %>%
  ggplot() +
  geom_col(aes(x=ano, y=valor))
