<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by 
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 
    		
	http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
<cfoutput>

<!--- js --->
<cfif not event.valueExists("print")>
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
$(window).ready(function(){
	$(".delete").click(function(){
			var _this = this;
			return confirm("Are you sure you wish to delete the page '<strong>#rc.content.getPage().getName()#</strong>'?<br/>This cannot be undone!", function(){
				gotoLink(_this)
			});
	});
});
function createNewPage(){
	var page = ''
	page = prompt('Please enter the page name to create. Remember that namespaces are followed by a : \nEx: ISDepartment:MyGreatPage or just MyGreatPage?');
	
	if( page != undefined && page != ''){
		page = page.replace(/ /g,"_");
		window.location='#event.buildLink(linkto=rc.onCreateWiki,override=true)#/'+page+"#event.getRewriteExtension()#";
	}
	
}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
</cfif>

<!--- Print & Floating Top Bar --->
<cfif not event.valueExists("print")>
<div align="right" style="margin-bottom:15px;">
	<cfif rc.oUser.checkPermission("WIKI_CREATE")>
		<img src="includes/images/add.png" border="0" align="absmiddle">
		<a href="javascript:createNewPage()">Create Page</a>&nbsp;
	</cfif>
	<cfif rc.oUser.checkPermission("WIKI_VIEW_HISTORY")>
		<img src="includes/images/history.png" border="0" align="absmiddle">
		<a href="#event.buildLink(rc.onShowHistory & '/' & rc.urlPage)#">Page History</a>
	</cfif>
</div>
</cfif>


<!--- Messsagebox --->
#getPlugin("messagebox").renderit()#

<!--- Content --->
<p>#rc.content.render()#</p>

<!--- Category Displays --->
<cfset categories = rc.content.getCategoryArray() />
<cfif NOT ArrayIsEmpty(categories)>
	<div id="categories">
		<img src="includes/images/tag_blue.png" align="absmiddle"> 
		Categories:
		<ul>
		<cfloop array="#categories#" index="category">
			<li>
				<a href="#event.buildLink(pageShowRoot(URLEncodedFormat("Category:" & category.getName())))#">#category.getName()#</a>
			</li>
		</cfloop>
		</ul>
	</div>
</cfif>

<!--- Management Tool Bar --->
<cfif not event.valueExists("print")>
	
	<!--- Only edit if not read only --->
	<cfif rc.content.getisReadOnly() AND 
		  (rc.content.getUser().getuserid() eq rc.oUser.getUserid()) OR
		  rc.oUser.checkPermission("WIKI_ADMIN")>
	<br />
	<p class="buttons">
		<cfif rc.oUser.checkPermission("WIKI_EDIT")>
		<a href="#event.buildLink(rc.onEditWiki & '/' & rc.urlPage)#" id="buttonLinks">
			<span>Edit Page</span>
		</a>
		</cfif>
		&nbsp;
		<cfif rc.oUser.checkPermission("WIKI_DELETE_PAGE")>
		<a href="#event.buildLink(rc.onDeleteWiki & '/id/' & rc.content.getPage().getPageID())#" class="delete" id="buttonLinks">
			<span>Delete Page</span>
		</a>
		</cfif>
	</p>
	</cfif>
	<!--- Format Bar --->
	<div id="downloadFormatsBar">
		<strong>Download in other Formats:</strong><br />
		<img src="includes/images/code.png" border="0" align="absmiddle">
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/markup'))#" target="_blank">Markup</a> |
		
		<img src="includes/images/pdf_16x16.png" border="0" align="absmiddle">
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/pdf'))#" target="_blank">PDF</a> |
		
		<cfif getSetting("CFMLEngine",1) neq "RAILO">
		<img src="includes/images/flash_16x16.png" border="0" align="absmiddle">
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/flashpaper'))#" target="_blank">SWF</a> |
		</cfif>
		
		<img src="includes/images/html_16x16.png" border="0" align="absmiddle">
		<a href="#event.buildLink(pageShowRoot(rc.urlPage & '/HTML'))#" target="_blank">HTML</a>
	</div>

</cfif>
</cfoutput>