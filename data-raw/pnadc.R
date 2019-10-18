# tive que fazer um hack pq o link está quebrado
# link que funfa:
# ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/2018/PNADC_022018_20190729.zip
td <- tempdir()
arquivos <- dir(td)

download <- microdadosBrasil::download_sourceData(
  "PnadContinua", "2018-2q", TRUE, root_path = td, replace = TRUE
)

arquivo <- dir(paste(td, sub("\\.zip$", "", download$name), sep = "/"),
               full.names = TRUE)

pnadc <- ler_pnadc(arquivo, "2018-2q")

tf <- tempfile()
link_cod <- "ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/Documentacao/Ocupacao_COD.xls"
download.file(link_cod, tf)

ocupacoes <- readxl::read_xls(tf, skip = 2) %>%
  dplyr::rename(grande_grupo = 1, subgrupo_principal = 2, subgrupo = 3,
                profissao = 4, descricao = 5) %>%
  tidyr::gather(nivel, codigo, -descricao) %>%
  dplyr::filter(!is.na(codigo))

usethis::use_data(pnadc, ocupacoes, overwrite = TRUE)

