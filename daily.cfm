<cfset cT = CreateDate(2014,3,2)>

<cfset rawDataGrid = QueryNew("Uhrzeit,P1,P2,P3,kWh,Heizstab,TistOG,TistEG,TistUG,TistAussen,Regen,Sonne,StetigOG,StetigEG,StetigUG,SollRmOG,SollRmEG,SollRmUG")>
<cfloop index="m" from="0" to="1439" step="1">
	<cfset QueryAddRow(rawDataGrid)>
    <cfset T2 = DateAdd("n",m,cT)>
    <cfset QuerySetCell(rawDataGrid,"Uhrzeit",T2)>

	<!---  rawDataGrid  --->
    <!---<cfquery name="qTmpP1" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value as P1 FROM Item24 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# 00:00.00'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>--->
    
	<!---  kWh (Gesamtleistung)  --->
    <cfset kWh = 0>
    <cfquery name="qTmp1" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item27 
    WHERE time > '#LSDateFormat(cT,"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp1.value neq ""><cfset kWh += qTmp1.value/1000></cfif>
    <cfquery name="qTmp2" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item25 
    WHERE time > '#LSDateFormat(cT,"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp2.value neq ""><cfset kWh += qTmp2.value/1000></cfif>
    <cfquery name="qTmp3" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item24
    WHERE time > '#LSDateFormat(cT,"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp3.value neq ""><cfset kWh += qTmp3.value/1000></cfif>
    <cfset QuerySetCell(rawDataGrid,"kWh",kWh)>

	<!---  P1 (Momentleistung Phase 1)  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item30 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"P1",v)>

	<!---  P2 (Momentleistung Phase 2)  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item31 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"P2",v)>

	<!---  P3 (Momentleistung Phase 3)  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item32 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"P3",v)>

	<!---  Heizstab  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item33 
    WHERE time > '#LSDateFormat(DateAdd("h",-10,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq "ON"><cfset v = 1><cfelse><cfset v = 0></cfif>
    <cfset QuerySetCell(rawDataGrid,"Heizstab",v)>

	<!---  OG Temperatur Ist  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item7 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"TistOG",v)>

	<!---  EG Temperatur Ist  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item9 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"TistEG",v)>

	<!---  UG Temperatur Ist  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item6 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"TistUG",v)>

	<!---  Wetter: Temperatur  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item11 
    WHERE time > '#LSDateFormat(DateAdd("h",-1,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq ""><cfset v = 0><cfelse><cfset v = qTmp.value></cfif>
    <cfset QuerySetCell(rawDataGrid,"TistAussen",v)>

	<!---  Wetter: Regen  --->
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item15 
    WHERE time > '#LSDateFormat(DateAdd("h",-10,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq "ON"><cfset v = 1><cfelse><cfset v = 0></cfif>
    <cfset QuerySetCell(rawDataGrid,"Regen",v)>

	<!---  Wetter: Sonnenschein
    <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
    SELECT value FROM Item15 
    WHERE time > '#LSDateFormat(DateAdd("h",-10,cT),"yyyy-mm-dd")# 00:00.00' 
    AND time < '#LSDateFormat(cT,"yyyy-mm-dd")# #TimeFormat(T2,"HH:mm.ss")#'
    ORDER BY time DESC
    LIMIT 1
    </cfquery>
    <cfif qTmp.value eq "ON"><cfset v = 1><cfelse><cfset v = 0></cfif>
    <cfset QuerySetCell(rawDataGrid,"Sonne",v)>  --->


</cfloop>

<cfset daily = {
	Datum = cT,
	Power = {
		kWh = 0,
		euro = 0,
		tendence = 0,
		grid = ""
	},
	Heating = {
		grid = queryNew("Uhrzeit,Aussen,OG,EG,UG"),
		extraheating = {
			minutes = 0,
			kWh = 0,
			euro = 0
		},
		tempMax = {
			OG = 0,
			EG = 0,
			UG = 0
		},
		tempMin = {
			OG = 0,
			EG = 0,
			UG = 0
		},
		tempAvg = {
			OG = 0,
			EG = 0,
			UG = 0
		}
	},
	Weather = {
		dusk = CreateTime(8,0,0),
		dawn = CreateTime(18,0,0),
		rainMinutes = 0,
		sunMinutes = 0,
		tempAvg = 0,
		tempMax = 0,
		tempMin = 0
	},
	Static = {
		strompreisCent = 25
	}
}>

<!---  Erkenntnisse aus Rohdaten ermitteln  --->
<cfquery name="qTmp" dbtype="query">
	SELECT sum(Heizstab) AS m FROM rawDataGrid
</cfquery>
<cfset daily.Heating.extraheating.minutes = qTmp.m>
<cfset daily.Heating.extraheating.kWh = 3*qTmp.m/60>
<cfset daily.Heating.extraheating.euro = daily.Static.strompreisCent*3*qTmp.m/60/100>

<cfquery name="qTmp" dbtype="query">
	SELECT max(kwh) AS m FROM rawDataGrid
</cfquery>
<cfset daily.Power.kWh = qTmp.m>
<cfset daily.Power.euro = qTmp.m*daily.Static.strompreisCent/100>

<cfquery name="qTmp" dbtype="query">
	SELECT Uhrzeit,P1,P2,P3,(p1+p2+p3) AS PSUM, kWh*1000 AS wh FROM rawDataGrid
</cfquery>
<cfset daily.Power.grid = qTmp>

<cfquery name="qTmp" dbtype="query">
	SELECT avg(TistOG) AS TavgOG, max(TistOG) AS TmaxOG, min(TistOG) AS TminOG FROM rawDataGrid
</cfquery>
<cfset daily.Heating.tempAvg.OG = qTmp.TavgOG>
<cfset daily.Heating.tempMax.OG = qTmp.TmaxOG>
<cfset daily.Heating.tempMin.OG = qTmp.TminOG>

<cfquery name="qTmp" dbtype="query">
	SELECT avg(TistEG) AS TavgEG, max(TistEG) AS TmaxEG, min(TistEG) AS TminEG FROM rawDataGrid
</cfquery>
<cfset daily.Heating.tempAvg.EG = qTmp.TavgEG>
<cfset daily.Heating.tempMax.EG = qTmp.TmaxEG>
<cfset daily.Heating.tempMin.EG = qTmp.TminEG>

<cfquery name="qTmp" dbtype="query">
	SELECT avg(TistUG) AS TavgUG, max(TistUG) AS TmaxUG, min(TistUG) AS TminUG FROM rawDataGrid
</cfquery>
<cfset daily.Heating.tempAvg.UG = qTmp.TavgUG>
<cfset daily.Heating.tempMax.UG = qTmp.TmaxUG>
<cfset daily.Heating.tempMin.UG = qTmp.TminUG>

<cfquery name="qTmp" dbtype="query">
	SELECT avg(TistAussen) AS TavgAussen, max(TistAussen) AS TmaxAussen, min(TistAussen) AS TminAussen FROM rawDataGrid
</cfquery>
<cfset daily.Weather.tempAvg = qTmp.TavgAussen>
<cfset daily.Weather.tempMax = qTmp.TmaxAussen>
<cfset daily.Weather.tempMin = qTmp.TminAussen>

<cfquery name="qTmp" dbtype="query">
	SELECT sum(Regen) AS m FROM rawDataGrid
</cfquery>
<cfset daily.Weather.rainMinutes = qTmp.m>

<!---<cfquery name="qTmp" dbtype="query">
	SELECT sum(Sonne) AS m FROM rawDataGrid
</cfquery>
<cfset daily.Weather.sunMinutes = qTmp.m>--->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Unbenanntes Dokument</title>
</head>

<body>


<!---   24h Chart Strom / HAs  --->
<!---   Laufzeit Heizstab  --->

<!---   24h Chart Temperatur Innen / Außen  --->
<!---   Durchschnittstemperatur Tag  --->
<!---   Durchschnittstemperatur Nacht  --->

<!---   Tendenz ggü. Vorwochenschnitt  --->

<!---   Event-Log  --->

<cfdump var="#rawDataGrid#" top="100" expand="no">
<cfdump var="#daily#" top="10">

</body>
</html>