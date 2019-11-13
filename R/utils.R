#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' Trocar códigos pela descrição
#'
#' @param x Um vetor de códigos
#' @name descricao
#' @aliases descricao
#' @return O mesmo vetor, com suas descrições
descricao_sexo <- function(x) {
  dplyr::case_when(
    x == 1 ~ "Homem",
    x == 2 ~ "Mulher"
  )
}

#' @rdname descricao
descricao_cor <- function(x) {
  dplyr::case_when(
    x ==  1 ~ "Branca",
    x ==  2 ~ "Preta",
    x ==  3 ~ "Amarela",
    x ==  4 ~ "Parda",
    x ==  5 ~ "Indígena",
    x ==  9 ~ "Ignorado"
  )
}

#' @rdname descricao
descricao_vinculo <- function(x) {
  dplyr::case_when(
    x == 1 ~ "Trabalhador doméstico",
    x == 2 ~ "Militar",
    x == 3 ~ "Empregado do setor privado",
    x == 4 ~ "Empregado do setor público",
    x == 5 ~ "Empregador",
    x == 6 ~ "Conta própria",
    x == 7 ~ "Trabalhador familiar não remunerado",
    TRUE ~ "Não aplicável"
  )
}

#' @rdname descricao
descricao_instrucao <- function(x) {
  dplyr::case_when(
    x == 1 ~ "Sem instrução e menos de 1 ano de estudo",
    x == 2 ~ "Fundamental incompleto ou equivalente",
    x == 3 ~ "Fundamental completo ou equivalente",
    x == 4 ~ "Médio incompleto ou equivalente",
    x == 5 ~ "Médio completo ou equivalente",
    x == 6 ~ "Superior incompleto ou equivalente",
    x == 7 ~ "Superior completo",
    TRUE ~ "Não aplicável"
  )
}

#' Ler PNAD continua
#'
#' @param arquivo arquivo com microdados
#' @param periodo periodo que será lido
#'
#' @return Uma tibble com 19 variaveis com dados do período indicado
ler_pnadc <- function(arquivo, periodo) {
  vars <- c("Ano", "Trimestre", "UF", "Estrato", "UPA",
            "V1008", "V1014", "V1016", "V1022", "V1027", "V1028",
            "V1029", "posest",
            "V4010", "V2007", "V2010", "V403312",
            "V2009", "V4039", "VD3001", "V4012")

  microdadosBrasil::read_PNADcontinua(
    "pessoas", periodo, file = arquivo, vars_subset = vars
  ) %>%
    dplyr::as_tibble() %>%
    dplyr::rename(
      ano = Ano, trimestre = Trimestre, uf = UF, estrato = Estrato, upa = UPA,
      num_domicilio = V1008, grupo_amostra = V1014, num_entrevista = V1016,
      situacao_domicilio = V1022, peso_sem_posestrat = V1027,
      peso_com_posestrat = V1028, proj_pop = V1029, profissao = V4010,
      sexo = V2007, cor = V2010, rendimento = V403312, idade = V2009,
      horas_trabalhadas = V4039, nivel_instrucao = VD3001, tipo_vinculo = V4012
    ) %>%
    dplyr::mutate_at(dplyr::vars(ano:estrato), as.integer) %>%
    dplyr::mutate(
      sexo = descricao_sexo(sexo),
      cor = descricao_cor(cor),
      tipo_vinculo = descricao_vinculo(tipo_vinculo),
      nivel_instrucao = descricao_instrucao(nivel_instrucao)
    )
}


#' Listar arquivos e pastas de repositório FTP
#'
#' @param path Caminho listado
#'
#' @return Um vetor com arquivos e pastas encontrados
ftp_ls <- function(path) {
  RCurl::getURL(path, ftp.use.epsv=TRUE, dirlistonly = TRUE) %>%
    stringr::str_split("\\s+") %>%
    magrittr::extract2(1)
}


#' Listar todos os arquivos da PNAD Contínua
#'
#' @return Um vetor com o caminho para os arquivos dos microsdados da PNADC
arquivos_pnadc <- function() {
  link_raiz <- paste0(
    "ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/",
    "Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/"
  )

  pastas_anos <- ftp_ls(link_raiz) %>%
    stringr::str_subset("^\\d{4}$")

  arquivos <- paste0(link_raiz, pastas_anos, "/") %>%
    purrr::map(ftp_ls) %>%
    purrr::map(~stringr::str_subset(.x, "^PNADC.+\\.zip"))

  purrr::map2(pastas_anos, arquivos, ~paste0(link_raiz, .x, "/", .y)) %>%
    unlist()
}

#' Corrigir nomes da PNADC no pacote microdadosBrasil
#'
#' @return Um vetor de TRUE/FALSE para casos que fez a troca com sucesso.
corrigir_nomes_pnadc <- function() {
  arquivos <- dir(
    system.file("extdata", "dics", package = "microdadosBrasil"), full.names = TRUE
  ) %>%
    str_subset("PNADcontinua")

  file.rename(arquivos, stringr::str_replace(arquivos, "PNADcontinua", "PnadContinua"))
}

# Procedimento para download e leitura de arquivos
#
# download.file(link, "dados/pnadc_201201.zip")
# unzip("dados/pnadc_201201.zip")

