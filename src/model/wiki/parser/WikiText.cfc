<cfcomponent hint="the media wiki parser" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="WikiText" output="false">
	<cfargument name="coldBoxController" type="coldbox.system.controller" required="true">
	<cfscript>
		var path = getDirectoryFromPath(getMetaData(this).path) & "/lib/bliki/";
		var qFiles = 0;
		var paths = ArrayNew(1);
	</cfscript>
	<cfdirectory action="list" filter="*.jar" directory="#path#" name="qFiles">
	<cfloop query="qFiles">
		<cfset ArrayAppend(paths, directory & "/" & name) />
	</cfloop>
	<cfscript>
		setJavaLoader(createObject("component", "coldbox.system.extras.javaloader.JavaLoader").init(paths));

		setLinkPattern(arguments.coldBoxController.getSetting('htmlBaseURL') & "/" & arguments.coldboxController.getSetting("ShowKey") & "/${title}.cfm");

		//this will eventually get replaced when we implement images
		setImagePattern("image/${image}.cfm");

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configuration method for configuraiton by the listener" access="public" returntype="void" output="false">
	<cfargument name="ignoreXMLTagList" hint="the list of xml tags to ignore" type="string" required="No" default="">
	<cfscript>
		var config = getJavaLoader().create("info.bliki.wiki.model.Configuration").init();
		var xmlTag = 0;
	</cfscript>
	<cfloop list="#arguments.ignoreXMLTagList#" index="xmlTag">
		<cfscript>
			//this tells the parser to ignore these XML tags
			config.addTokenTag(xmlTag, getJavaLoader().create("info.bliki.wiki.tags.HTMLTag").init(xmlTag));
		</cfscript>
	</cfloop>
	<cfscript>
		setConfiguration(config);
	</cfscript>
</cffunction>

<cffunction name="visitRenderable" hint="visits a renderable item" access="public" returntype="any" output="false">
	<cfargument name="renderable" hint="renderable object, should be static" type="any" required="Yes">
	<cfargument name="visitData" hint="struct of data that gets passed around" type="struct" required="Yes">
	<cfscript>
		var model = createModel();

		arguments.renderable.setContent(model.render(arguments.renderable.getContent()));

		if(NOT StructKeyExists(arguments.visitData, "categories"))
		{
			arguments.visitData.categories = ArrayNew(1);
		}

		//use java, it's fast
		arguments.visitData.categories.addAll(model.getCategories());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="createModel" hint="creates a info.bliki.model.WikiModel" access="private" returntype="any" output="false">
	<cfreturn getJavaLoader().create("info.bliki.wiki.model.WikiModel").init(getConfiguration(), "/${image}", getLinkPattern()) />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldbox.system.extras.javaloader.JavaLoader" output="false">
	<cfreturn instance.javaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldbox.system.extras.javaloader.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader />
</cffunction>

<cffunction name="getLinkPattern" access="private" returntype="string" output="false">
	<cfreturn instance.linkPattern />
</cffunction>

<cffunction name="setLinkPattern" access="private" returntype="void" output="false">
	<cfargument name="linkPattern" type="string" required="true">
	<cfset instance.linkPattern = arguments.linkPattern />
</cffunction>

<cffunction name="getImagePattern" access="private" returntype="string" output="false">
	<cfreturn instance.imagePattern />
</cffunction>

<cffunction name="setImagePattern" access="private" returntype="void" output="false">
	<cfargument name="imagePattern" type="string" required="true">
	<cfset instance.imagePattern = arguments.imagePattern />
</cffunction>

<!--- wiki parser java config object --->
<cffunction name="getConfiguration" access="private" returntype="any" output="false">
	<cfreturn instance.Configuration />
</cffunction>

<cffunction name="setConfiguration" access="private" returntype="void" output="false">
	<cfargument name="Configuration" type="any" required="true">
	<cfset instance.Configuration = arguments.Configuration />
</cffunction>

</cfcomponent>