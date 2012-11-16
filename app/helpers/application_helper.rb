module ApplicationHelper
  def date_with_format(fecha)
    unless fecha == nil
      meses = "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre".split(" ")
      mes = meses[fecha.month-1]
      fecha = fecha.hour.to_s+":" +fecha.min.to_s + " " + fecha.day.to_s + " " + mes + " " + fecha.year.to_s
      return fecha
    end
  end
end
