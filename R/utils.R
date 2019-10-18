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
