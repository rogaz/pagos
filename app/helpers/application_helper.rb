module ApplicationHelper
  def date_with_format(fecha)
    unless fecha == nil
      meses = "Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre".split(" ")
      mes = meses[fecha.month-1]
      if fecha.respond_to?(:hour)
        fecha = fecha.day.to_s + " " + mes + " " + fecha.year.to_s + " " + fecha.hour.to_s+":" +fecha.min.to_s
      else
        fecha = fecha.day.to_s + " " + mes + " " + fecha.year.to_s
      end
      return fecha
    end
  end
  
  def traduce_month(month_and_year)
    a = "january february march april may june july august september october november december".split()
    b = "enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre".split()
    month = month_and_year.split()[0]
    year = " " + month_and_year.split()[1]
    return b[a.index(month.downcase)].capitalize + year
  end
end
