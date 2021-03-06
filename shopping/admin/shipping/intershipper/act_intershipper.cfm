<!--- CFWebstore, version 6.50 --->

<!--- Updates the Intershipper settings. Called by shopping.admin&shipping=intershipper --->

<cfif ListFind(attributes.Carriers,"ALL")>
	<cfset Carriers = "ALL">
<cfelse>
	<cfset Carriers = attributes.Carriers>
</cfif>

<cfif ListFind(attributes.Classes,"ALL")>
	<cfset Classes = "ALL">
<cfelse>
	<cfset Classes = attributes.Classes>
</cfif>

<cfquery name="UpdIntership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Intershipper
SET MaxWeight = #attributes.MaxWeight#,
UnitsofMeasure = '#attributes.UnitsofMeasure#',
Carriers = '#Carriers#',
Classes = '#Classes#',
UserID = '#Trim(attributes.UserID)#',
Password = '#Trim(attributes.Password)#',
Pickup = '#attributes.Pickup#',
MerchantZip = '#attributes.MerchantZip#',
Logging = #attributes.Logging#,
Debug = #attributes.Debug#
</cfquery>

<!--- Update Cached Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getIntShipSettings()>

