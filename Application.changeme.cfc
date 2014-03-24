<cfcomponent><cfsetting enablecfoutputonly="yes">
<cfset This.name="MAohstats">
<cfset This.Sessionmanagement=true>
<cfset This.Sessiontimeout="#createtimespan(0,0,30,0)#">
<cfset This.applicationtimeout="#createtimespan(0,1,0,0)#">

<cffunction name="onApplicationStart">
	<cfset Application.dbName = "enterDSNname">
	<cfset Application.dbUser = "enterUserName">
	<cfset Application.dbPass = "enterPassword">
</cffunction>

<cffunction name="onSessionStart">
	<cfparam name="Cookie.lastTask" default="0" type="integer">
</cffunction>

<cffunction name="OnRequestStart">
     <cfif isDefined('url.refresh')></cfif>
</cffunction>

<cfsetting enablecfoutputonly="no"></cfcomponent>