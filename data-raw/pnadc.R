# tive que fazer um hack pq o link está quebrado
# link que funfa:
# ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/2018/PNADC_022018_20190729.zip
td <- tempdir()
arquivos <- dir(td)

download <- microdadosBrasil::download_sourceData(
  "PnadContinua", "2018-2q", TRUE, root_path = td, replace = TRUE
)

vars <- c("Ano", "Trimestre", "UF", "Estrato",
          "V1008", "V1014", "V1016", "V1022", "V1027", "V1028", "posest",
          "V4010", "V2007", "V2010", "VD4016",
          "V2009", "V4039", "VD3001", "V4012")

arquivo <- dir(paste(td, sub("\\.zip$", "", download$name), sep = "/"),
               full.names = TRUE)

pnadc <- microdadosBrasil::read_PNADcontinua(
  "pessoas", "2018-2q", file = arquivo, vars_subset = vars
) %>%
  dplyr::as_tibble() %>%
  dplyr::rename(
    ano = Ano, trimestre = Trimestre, uf = UF, estrato = Estrato,
    num_domicilio = V1008, grupo_amostra = V1014, num_entrevista = V1016,
    situacao_domicilio = V1022, peso_sem_posestrat = V1027,
    peso_com_posestrat = V1028, profissao = V4010, sexo = V2007, cor = V2010,
    rendimento = VD4016, idade = V2009, horas_trabalhadas = V4039,
    nivel_instrucao = VD3001, tipo_vinculo = V4012
  ) %>%
  dplyr::mutate_at(dplyr::vars(ano:estrato), as.integer) %>%
  dplyr::mutate(
    sexo = ifelse(sexo == 1, "Homem", "Mulher"),
    cor = dplyr::case_when(
      cor ==  1 ~ "Branca",
      cor ==  2 ~ "Preta",
      cor ==  3 ~ "Amarela",
      cor ==  4 ~ "Parda",
      cor ==  5 ~ "Indígena",
      cor ==  9 ~ "Ignorado"
    ),
    tipo_vinculo = dplyr::case_when(
      tipo_vinculo == 1 ~ "Trabalhador doméstico",
      tipo_vinculo == 2 ~ "Militar",
      tipo_vinculo == 3 ~ "Empregado do setor privado",
      tipo_vinculo == 4 ~ "Empregado do setor público",
      tipo_vinculo == 5 ~ "Empregador",
      tipo_vinculo == 6 ~ "Conta própria",
      tipo_vinculo == 7 ~ "Trabalhador familiar não remunerado",
      TRUE ~ "Não aplicável"
    ),
    nivel_instrucao = dplyr::case_when(
      nivel_instrucao == 1 ~ "Sem instrução e menos de 1 ano de estudo",
      nivel_instrucao == 2 ~ "Fundamental incompleto ou equivalente",
      nivel_instrucao == 3 ~ "Fundamental completo ou equivalente",
      nivel_instrucao == 4 ~ "Médio incompleto ou equivalente",
      nivel_instrucao == 5 ~ "Médio completo ou equivalente",
      nivel_instrucao == 6 ~ "Superior incompleto ou equivalente",
      nivel_instrucao == 7 ~ "Superior completo",
      TRUE ~ "Não aplicável"
    )
  )

tf <- tempfile()
link_cod <- "ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/Documentacao/Ocupacao_COD.xls"
download.file(link_cod, tf)

# completar <- function(x) {
#   for (i in seq_along(x)[-1]) {
#     if (is.na(x[i])) {
#       x[i] <- x[i-1]
#     }
#   }
#   x
# }

ocupacoes <- readxl::read_xls(tf, skip = 2) %>%
  dplyr::rename(grande_grupo = 1, subgrupo_principal = 2, subgrupo = 3,
                profissao = 4, descricao = 5) %>%
  tidyr::gather(nivel, codigo, -descricao) %>%
  dplyr::filter(!is.na(codigo))

usethis::use_data(pnadc, ocupacoes, overwrite = TRUE)

