<cfcomponent extends="coldbox.system.coldbox" output="false">	<!--- Modify the Name of the application--->	<cfset this.name = "codeXwiki_" & hash(getCurrentTemplatePath())>	<cfset this.sessionManagement = true>	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>	<cfset this.setClientCookies = true>	<!--- codex mapping --->	<cfset this.mappings["/codex"] = getDirectoryFromPath(getBaseTemplatePath()) />		<!--- COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP --->	<cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath())>	<!--- COLDBOX PROPERTIES --->	<cfset COLDBOX_CONFIG_FILE = "">	<!--- on Application Start --->	<cffunction name="onApplicationStart" returnType="boolean" output="false">		<cfscript>			//Load ColdBox			loadColdBox();			return true;		</cfscript>	</cffunction>		<!--- on Request Start --->	<cffunction name="onRequestStart" returnType="boolean" output="true">		<!--- ************************************************************* --->		<cfargument name="targetPage" type="string" required="true" />		<!--- ************************************************************* --->		<cfsetting enablecfoutputonly="yes">		<!--- Reload Checks --->		<cfset reloadChecks()>				<!--- Process A ColdBox Request Only --->		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>			<cfset processColdBoxRequest()>		</cfif>					<!--- WHATEVER YOU WANT BELOW --->		<cfsetting enablecfoutputonly="no">		<cfreturn true>	</cffunction>		<!--- on Application End --->	<cffunction name="onApplicationEnd" returnType="void"  output="false">		<!--- ************************************************************* --->		<cfargument name="applicationScope" type="struct" required="true">		<!--- ************************************************************* --->		<!--- WHATEVER YOU WANT BELOW --->	</cffunction>		<!--- on Session Start --->	<cffunction name="onSessionStart" returnType="void" output="false">					<cfset super.onSessionStart()>		<!--- WHATEVER YOU WANT BELOW --->	</cffunction>		<!--- on Session End --->	<cffunction name="onSessionEnd" returnType="void" output="false">		<!--- ************************************************************* --->		<cfargument name="sessionScope" type="struct" required="true">		<cfargument name="appScope" 	type="struct" required="false">		<!--- ************************************************************* --->		<cfset super.onSessionEnd(argumentCollection=arguments)>		<!--- WHATEVER YOU WANT BELOW --->	</cffunction></cfcomponent>