#' Perfil da força de trabalho na PNAD 2018T2.
#'
#' Um conjunto de dados contendo atributos demográficos e de inserção no mercado
#' de trabalho da força de trabalho do Brasil no segundo trimestre de 2018.
#' Há também dados sobre o desenho da amostra.
#'
#' @format Uma tibble com 556.186 observações e 19 variáveis:
#' \describe{
#'   \item{ano}{Ano da pesquisa}
#'   \item{trimestre}{Trimestre da pesquisa}
#'   \item{uf}{Código da UF}
#'   \item{estrato}{Estrato}
#'   \item{num_domicilio}{Número do domicílio}
#'   \item{grupo_amostra}{Número do grupo da amostra}
#'   \item{num_entrevista}{Número da entrevista}
#'   \item{situacao_domicilio}{1 para 'urbano', 2 para 'rural'}
#'   \item{peso_sem_posestrat}{Peso na amostra sem pós-estratificação}
#'   \item{peso_com_posestrat}{Peso na amostra com pós-estratificação}
#'   \item{posest}{Domínios da projeção}
#'   \item{sexo}{Sexo}
#'   \item{idade}{Idade, em anos}
#'   \item{cor}{Cor ou raça}
#'   \item{profissao}{Código CNAE da profissão}
#'   \item{tipo_vinculo}{Forma de participação no mercado de trabalho}
#'   \item{horas_trabalhadas}{Jornada de trabalho habitual, em horas}
#'   \item{nivel_instrucao}{Nível de instrução}
#'   \item{redimento}{Rendimento, em reais}
#' }
#' @source \url{ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados}
"pnadc"

#' Códigos das ocupações da PNAD 2018T2.
#'
#' Um conjunto de dados contendo código CNAE, nível e descrição das ocupações
#' usadas na PNAD 2018T2.
#'
#' @format Uma tibble com 614 observações e 3 variáveis:
#' \describe{
#'   \item{descricao}{Descrição da ocupação}
#'   \item{nivel}{Nível de agregação da ocupação}
#'   \item{codigo}{Código CNAE da ocupação}
#' }
#' @source \url{ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/Documentacao/Ocupacao_COD.xls}
"ocupacoes"

