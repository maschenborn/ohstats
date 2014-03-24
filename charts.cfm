<cfset charts = CreateObject("component","/charts")>

<cfset start = '2014-01-18 00:00:00'>
<cfset end = '2014-01-22 22:00:00'>
<cfset start = DateAdd('h',-6,now())>
<cfset end = now()>
<cfset messwerte = 80>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Auswertung Zeiterfassung</title>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script type="text/javascript">
      function drawVisualization() {
		<cfoutput>
		#charts.getJsonOfLeistung(start,end,messwerte)#
		#charts.getJsonOfArbeit(start,end,messwerte)#
		#charts.getJsonOfHeizungsaktoren(start,end,messwerte)#
		#charts.getJsonOfTemperatur(start,end,messwerte)#
		#charts.getJsonOfSollRM(start,end,messwerte)#
		</cfoutput>
      }
      google.setOnLoadCallback(drawVisualization);
    </script>
  </head>
  <body>
    <div id="chart0" style="width: 100%; height: 500px;"></div>
    <div id="chart4" style="width: 100%; height: 500px;"></div>
    <div id="chart1" style="width: 100%; height: 500px;"></div>
    <div id="chart2" style="width: 100%; height: 500px;"></div>
    <div id="chart3" style="width: 100%; height: 500px;"></div>
    <!---<cfdump var="#qStats#">--->
  </body>
</html>
