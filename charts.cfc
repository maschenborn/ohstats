<cfcomponent>
	<cffunction name="renderGoogleChartJS" access="package" returntype="string">
    	<cfargument name="id" type="string" required="yes">
    	<cfargument name="jsonDiagramData" type="string" required="yes">
    	<cfargument name="fieldnames" type="string" required="yes">
    	<cfargument name="title" type="string" required="yes">
    	<cfargument name="unit" type="string" required="yes">
    	<cfargument name="type" type="string" required="no" default="LineChart">
    	<cfargument name="options" type="string" required="no" default="">
		<cfsavecontent variable="myOutput">
		<cfoutput>
        var data = new google.visualization.DataTable(
            {
                cols: [
                    {id: 'Date', label: 'Zeit', type: 'datetime'}
                    <cfloop index="n" list="#fieldnames#">
                    ,{id: 'Value', label: '#n#', type: 'number'}
                    </cfloop>
                ]
            },0.6
        )
        
        data.addRows([#arguments.jsonDiagramData#]);

        <cfif arguments.options eq "">
		var options = {
          title : "#arguments.title#",
          vAxis: {title: "#arguments.unit#"},
          hAxis: {title: "Datum"}
        };
        <cfelse>#arguments.options#</cfif>
        var #arguments.id# = new google.visualization.#arguments.type#(document.getElementById('#arguments.id#'));
        #arguments.id#.draw(data, options);
		</cfoutput>
		</cfsavecontent>
    	<cfreturn myOutput>
	</cffunction>	

	<cffunction name="getJsonOfHeizungsaktoren" access="public" returntype="string">
		<cfargument name="start" type="date" required="no" default="2014-01-20 00:00:00">
		<cfargument name="end" type="date" required="no" default="2014-01-22 22:00:00">
		<cfargument name="messwerte" type="numeric" required="no" default="50">
		<cfargument name="tableIDs" type="string" required="no" default="16,3,2">

        <cfset tables = "">
        <cfset fieldnames = "">
        <cfset fieldtypes = "">
        <cfloop index="i" list="#arguments.tableIDs#">
            <cfquery name="qFn" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
            SELECT ItemName FROM Items WHERE ItemId = #i#
            </cfquery>
            <cfset tables = ListAppend(tables,'Item#i#')>
            <cfset fieldnames = ListAppend(fieldnames,qFn.ItemName)>
            <cfset fieldtypes = ListAppend(fieldtypes,'decimal')>
        </cfloop>
        
        <cfset interval = Round(DateDiff('n',arguments.start,arguments.end)/arguments.messwerte)>
        
        <cfset qStats = QueryNew('timestamp,#fieldnames#','timestamp,#fieldtypes#')>
        <cfset cT = arguments.start>
        <cfloop condition="cT lt arguments.end">
            <cfset QueryAddRow(qStats)>
            <cfset QuerySetCell(qStats,'timestamp',cT)>
            
            <cfloop index="i" from="1" to="#ListLen(arguments.tableIDs)#">
                <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
                SELECT value FROM #ListGetAt(tables,i)# WHERE time < '#LSDateFormat(cT,"yyyy-mm-dd")# #LSTimeFormat(cT,"HH:mm:ss")#' ORDER BY time DESC LIMIT 1
                </cfquery>
                <cfset QuerySetCell(qStats,ListGetAt(fieldnames,i),qTmp.value)>
            </cfloop>
            
            <cfset cT = DateAdd('n',interval,cT)>
        </cfloop>
        
        <cfset jsonDiagrammDaten = "">
        <cfloop query="qStats">
            <cfset valList = "">
            <cfloop index="n" list="#fieldnames#">
                <cfset valList = ListAppend(valList,evaluate(n))>
            </cfloop>
            <cfset jsonDiagrammDaten = ListAppend(jsonDiagrammDaten,"[new Date(#LSDateFormat(qStats.timestamp,'yyyy, m, d, ')##LSTimeFormat(qStats.timestamp,'H, m, s')#), #valList#]")>
        </cfloop>
		
		<cfreturn renderGoogleChartJS('chart1',jsonDiagrammDaten, fieldnames, 'Heizungsaktoren', '%')>
	</cffunction>

	<cffunction name="getJsonOfTemperatur" access="public" returntype="string">
		<cfargument name="start" type="date" required="no" default="2014-01-20 00:00:00">
		<cfargument name="end" type="date" required="no" default="2014-01-22 22:00:00">
		<cfargument name="messwerte" type="numeric" required="no" default="50">
		<cfargument name="tableIDs" type="string" required="no" default="7,9,6,11">

        <cfset tables = "">
        <cfset fieldnames = "">
        <cfset fieldtypes = "">
        <cfloop index="i" list="#arguments.tableIDs#">
            <cfquery name="qFn" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
            SELECT ItemName FROM Items WHERE ItemId = #i#
            </cfquery>
            <cfset tables = ListAppend(tables,'Item#i#')>
            <cfset fieldnames = ListAppend(fieldnames,qFn.ItemName)>
            <cfset fieldtypes = ListAppend(fieldtypes,'decimal')>
        </cfloop>
        
        <cfset interval = Round(DateDiff('n',arguments.start,arguments.end)/arguments.messwerte)>
        
        <cfset qStats = QueryNew('timestamp,#fieldnames#','timestamp,#fieldtypes#')>
        <cfset cT = arguments.start>
        <cfloop condition="cT lt arguments.end">
            <cfset QueryAddRow(qStats)>
            <cfset QuerySetCell(qStats,'timestamp',cT)>
            
            <cfloop index="i" from="1" to="#ListLen(arguments.tableIDs)#">
                <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
                SELECT value FROM #ListGetAt(tables,i)# WHERE time < '#LSDateFormat(cT,"yyyy-mm-dd")# #LSTimeFormat(cT,"HH:mm:ss")#' ORDER BY time DESC LIMIT 1
                </cfquery>
                <cfset QuerySetCell(qStats,ListGetAt(fieldnames,i),qTmp.value)>
            </cfloop>
            
            <cfset cT = DateAdd('n',interval,cT)>
        </cfloop>
        
        <cfset jsonDiagrammDaten = "">
        <cfloop query="qStats">
            <cfset valList = "">
            <cfloop index="n" list="#fieldnames#">
                <cfset valList = ListAppend(valList,evaluate(n))>
            </cfloop>
            <cfset jsonDiagrammDaten = ListAppend(jsonDiagrammDaten,"[new Date(#LSDateFormat(qStats.timestamp,'yyyy, m, d, ')##LSTimeFormat(qStats.timestamp,'H, m, s')#), #valList#]")>
        </cfloop>
		
		<cfreturn renderGoogleChartJS('chart2',jsonDiagrammDaten, fieldnames, 'Temperatur', '°C')>
	</cffunction>

	<cffunction name="getJsonOfSollRM" access="public" returntype="string">
		<cfargument name="start" type="date" required="no" default="2014-01-20 00:00:00">
		<cfargument name="end" type="date" required="no" default="2014-01-22 22:00:00">
		<cfargument name="messwerte" type="numeric" required="no" default="50">
		<cfargument name="tableIDs" type="string" required="no" default="4,8,5">

        <cfset tables = "">
        <cfset fieldnames = "">
        <cfset fieldtypes = "">
        <cfloop index="i" list="#arguments.tableIDs#">
            <cfquery name="qFn" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
            SELECT ItemName FROM Items WHERE ItemId = #i#
            </cfquery>
            <cfset tables = ListAppend(tables,'Item#i#')>
            <cfset fieldnames = ListAppend(fieldnames,qFn.ItemName)>
            <cfset fieldtypes = ListAppend(fieldtypes,'decimal')>
        </cfloop>
        
        <cfset interval = Round(DateDiff('n',arguments.start,arguments.end)/arguments.messwerte)>
        
        <cfset qStats = QueryNew('timestamp,#fieldnames#','timestamp,#fieldtypes#')>
        <cfset cT = arguments.start>
        <cfloop condition="cT lt arguments.end">
            <cfset QueryAddRow(qStats)>
            <cfset QuerySetCell(qStats,'timestamp',cT)>
            
            <cfloop index="i" from="1" to="#ListLen(arguments.tableIDs)#">
                <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
                SELECT value FROM #ListGetAt(tables,i)# WHERE time < '#LSDateFormat(cT,"yyyy-mm-dd")# #LSTimeFormat(cT,"HH:mm:ss")#' ORDER BY time DESC LIMIT 1
                </cfquery>
                <cfset QuerySetCell(qStats,ListGetAt(fieldnames,i),qTmp.value)>
            </cfloop>
            
            <cfset cT = DateAdd('n',interval,cT)>
        </cfloop>
        
        <cfset jsonDiagrammDaten = "">
        <cfloop query="qStats">
            <cfset valList = "">
            <cfloop index="n" list="#fieldnames#">
                <cfset valList = ListAppend(valList,evaluate(n))>
            </cfloop>
            <cfset jsonDiagrammDaten = ListAppend(jsonDiagrammDaten,"[new Date(#LSDateFormat(qStats.timestamp,'yyyy, m, d, ')##LSTimeFormat(qStats.timestamp,'H, m, s')#), #valList#]")>
        </cfloop>
		
		<cfreturn renderGoogleChartJS('chart3',jsonDiagrammDaten, fieldnames, 'Temperatur-Sollwert', '°C')>
	</cffunction>

	<cffunction name="getJsonOfLeistung" access="public" returntype="string">
		<cfargument name="start" type="date" required="no" default="2014-01-20 00:00:00">
		<cfargument name="end" type="date" required="no" default="2014-01-22 22:00:00">
		<cfargument name="messwerte" type="numeric" required="no" default="50">
		<cfargument name="tableIDs" type="string" required="no" default="30,31,32">

        <cfset tables = "">
        <cfset fieldnames = "">
        <cfset fieldtypes = "">
        <cfloop index="i" list="#arguments.tableIDs#">
            <cfquery name="qFn" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
            SELECT ItemName FROM Items WHERE ItemId = #i#
            </cfquery>
            <cfset tables = ListAppend(tables,'Item#i#')>
            <cfset fieldnames = ListAppend(fieldnames,qFn.ItemName)>
            <cfset fieldtypes = ListAppend(fieldtypes,'decimal')>
        </cfloop>
        
        <cfset interval = Round(DateDiff('n',arguments.start,arguments.end)/arguments.messwerte)>
        
        <cfset qStats = QueryNew('timestamp,#fieldnames#,Sum','timestamp,#fieldtypes#,decimal')>
        <cfset cT = arguments.start>
        <cfloop condition="cT lt arguments.end">
            <cfset QueryAddRow(qStats)>
            <cfset QuerySetCell(qStats,'timestamp',cT)>
            
            <cfloop index="i" from="1" to="#ListLen(arguments.tableIDs)#">
                <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
                SELECT value FROM #ListGetAt(tables,i)# WHERE time < '#LSDateFormat(cT,"yyyy-mm-dd")# #LSTimeFormat(cT,"HH:mm:ss")#' ORDER BY time DESC LIMIT 1
                </cfquery>
                <cfset QuerySetCell(qStats,ListGetAt(fieldnames,i),qTmp.value)>
            </cfloop>
            
            <cfset cT = DateAdd('n',interval,cT)>
        </cfloop>
        
        <cfset jsonDiagrammDaten = "">
        <cfloop query="qStats">
            <cfset valList = "">
	        <cfset SumVal = 0>
            <cfloop index="n" list="#fieldnames#">
                <cfset valList = ListAppend(valList,evaluate(n))>                
		        <cfset SumVal += evaluate(n)>
            </cfloop>
            <cfset valList = ListAppend(valList,SumVal)>
            <cfset jsonDiagrammDaten = ListAppend(jsonDiagrammDaten,"[new Date(#LSDateFormat(qStats.timestamp,'yyyy, m, d, ')##LSTimeFormat(qStats.timestamp,'H, m, s')#), #valList#]")>
        </cfloop>
		<cfset fieldnames = ListAppend(fieldnames,'SumVal')>		
		<cfreturn renderGoogleChartJS('chart0',jsonDiagrammDaten, fieldnames, 'Leistung', 'W')>
	</cffunction>


	<cffunction name="getJsonOfArbeit" access="public" returntype="string">
		<cfargument name="start" type="date" required="no" default="2014-01-20 00:00:00">
		<cfargument name="end" type="date" required="no" default="2014-01-22 22:00:00">
		<cfargument name="messwerte" type="numeric" required="no" default="50">
		<cfargument name="tableIDs" type="string" required="no" default="27,25,24">

        <cfset tables = "">
        <cfset fieldnames = "">
        <cfset fieldtypes = "">
        <cfloop index="i" list="#arguments.tableIDs#">
            <cfquery name="qFn" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
            SELECT ItemName FROM Items WHERE ItemId = #i#
            </cfquery>
            <cfset tables = ListAppend(tables,'Item#i#')>
            <cfset fieldnames = ListAppend(fieldnames,qFn.ItemName)>
            <cfset fieldtypes = ListAppend(fieldtypes,'decimal')>
        </cfloop>
        
        <cfset interval = Round(DateDiff('n',arguments.start,arguments.end)/arguments.messwerte)>
        
        <cfset qStats = QueryNew('timestamp,value','timestamp,decimal')>
        <cfset cT = arguments.start>
        <cfloop condition="cT lt arguments.end">
            <cfset QueryAddRow(qStats)>
            <cfset QuerySetCell(qStats,'timestamp',cT)>
            <cfset val = 0>
            <cfloop index="i" from="1" to="#ListLen(arguments.tableIDs)#">
                <cfquery name="qTmp" datasource="#Application.dbName#" username="#Application.dbUser#" password="#Application.dbPass#">
                SELECT value FROM #ListGetAt(tables,i)# WHERE time < '#LSDateFormat(cT,"yyyy-mm-dd")# #LSTimeFormat(cT,"HH:mm:ss")#' ORDER BY time DESC LIMIT 1
                </cfquery>
                <cfset val = val + qTmp.value>
            </cfloop>
            <cfset QuerySetCell(qStats,'value',val)>
            
            <cfset cT = DateAdd('n',interval,cT)>
        </cfloop>
        
        <cfset jsonDiagrammDaten = "">
        <cfloop query="qStats">
            <cfset valList = "">
            <cfloop index="n" list="value">
                <cfset valList = ListAppend(valList,evaluate(n)/1000)>
            </cfloop>
            <cfset jsonDiagrammDaten = ListAppend(jsonDiagrammDaten,"[new Date(#LSDateFormat(qStats.timestamp,'yyyy, m, d, ')##LSTimeFormat(qStats.timestamp,'H, m, s')#), #valList#]")>
        </cfloop>
		
		<cfreturn renderGoogleChartJS('chart4',jsonDiagrammDaten, 'value', 'Arbeit', 'kWh')>
	</cffunction>

</cfcomponent>