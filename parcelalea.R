parcelalea <- function(
  estudiante = '',
  tipos = c(''),
  tiposcol = 'nombre', idcol = 'layer',
  sf = parcelas_uasd, n = 20, total = 11, semilla){
  require(sf)
  st_geometry(sf) <- NULL
  ntipos <- length(tipos)
  tiposcoma <- paste(tipos, collapse = ', ')
  tiposgrep <- paste(tipos, collapse = '|')
  tiposunicos <- unique(grep(tiposgrep, sf[,tiposcol], value = T))
  sffiltrado <- sf[sf[,tiposcol] %in% tiposunicos,]
  muestras <- lapply(
    tiposunicos,
    function(x){
      props <- nrow(sffiltrado[sffiltrado[,tiposcol] %in% x,])/nrow(sffiltrado)
      if(props<=0.35) props <- 0.4
      if(props>=0.65) props <- 0.6
      nm <- round(n*props,0)
      rver <- as.numeric(paste(version$major, gsub('\\.','', version$minor), sep = '.'))
      if(rver>=3.6){
        RNGkind(sample.kind = "Rounding") #Utiliza redondeo (compatibilidad entre versiones de R)
      }
      set.seed(semilla)
      m <- sort(sample(sffiltrado[sffiltrado[,tiposcol] %in% x, idcol], nm))
      cat(
        'Usuario/a ', estudiante,
        ', de la cobertura tipo "',
        x,
        '", elegir al menos ', round(props*total,0),
        ' de las siguientes parcelas: ',
        paste(m, collapse = ', '), '\n', sep = '')
    }
  )
  return(invisible(muestras))
}
