<!--- CFWebstore, version 6.50 --->

<!--- Displays the list of reviews. Called by product.admin&review=list --->

<cfparam name="attributes.displaycount" default="12">

<!--- Create the string with the filter parameters --->		
<cfset fieldlist="review,uid,uname,search_string,product_ID,rating,recommend,approved,needsCheck,order,sortby,editorial,recent_days">
<cfinclude template="../../../includes/act_setpathvars.cfm">
		
<cfparam name="currentpage" default="1">

<cfinclude template="../../../queries/qry_getpicklists.cfm">				

<!--- Create the page through links, max records set by the display count --->		
<cfmodule template="../../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_reviews.recordcount#" 
	currentpage="#currentpage#"
	templateurl="#thisSelf#"
	addedpath="#addedpath##request.token2#"
	displaycount="#attributes.displaycount#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilightcolor="###request.getcolors.mainlink#" 
	>
	
<cfsetting enablecfoutputonly="no">		
	
<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Product Review Manager"
	width="650"
	>
	
	<cfoutput>	
<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext" style="color: ###Request.GetColors.OutputTText#;">	

	<tr>
		<td colspan="3">
			<!---
			<a href="#self#?fuseaction=product.admin&review=add#Request.Token2#">New Review</a> |
			---> <a href="#self#?#replace(addedpath,"list","listform")##request.token2#">Edit Form</a></td>
		<td colspan="4" align="right">#pt_pagethru#</td>
	</tr>

	<form action="#self#?fuseaction=product.admin&review=list#request.token2#" method="post">
	
	<tr>
		<td><span class="formtextsmall"><br/></span>
		<input type="submit" value="Search" class="formbutton"/></td>
			
		<td><span class="formtextsmall">product ID<br/></span>
		<input type="text" name="product_ID" size="5" maxlength="8" class="formfield" value="#attributes.product_ID#"/>
		</td>	
			
		<td><span class="formtextsmall">title, comment search word<br/></span>
			<input type="text" name="search_string" size="30" maxlength="30" class="formfield" value="#HTMLEditFormat(attributes.search_string)#"/></td>	
			
		<td><span class="formtextsmall">order by<br/></span>
		<select name="sortby" size="1" class="formfield">
			<option value=""></option>
			<option value="newest" #doSelected(attributes.sortby,'newest')#>newest</option>
			<option value="oldest" #doSelected(attributes.sortby,'oldest')#>oldest</option>
			<option value="highest" #doSelected(attributes.sortby,'highest')#>best</option>
			<option value="lowest" #doSelected(attributes.sortby,'lowest')#>worst</option>
			<option value="mosthelp" #doSelected(attributes.sortby,'mosthelp')#>helpful</option>
			<option value="leasthelp" #doSelected(attributes.sortby,'leasthelp')#>not helpful</option>
		</select>
		</td>			

		<td><span class="formtextsmall">editorial<br/></span>
		<select name="editorial" size="1" class="formfield">
			<option value="">all</option>
			<cfmodule template="../../../customtags/form/dropdown.cfm"
			mode="valuelist"
			valuelist="#qry_getpicklists.Review_Editorial#"
			selected="#attributes.editorial#"
			/>
	 	</select>
			</td>	
			
		<td><span class="formtextsmall">display<br/></span>
		<select name="display_status" class="formfield">
			<option value="" #doSelected(attributes.display_status,'')#>all</option>
			<option value="check" #doSelected(attributes.display_status,'check')#>check</option>
			<option value="pending" #doSelected(attributes.display_status,'pending')#>pending</option>
			<option value="editor" #doSelected(attributes.display_status,'editor')#>editor</option>
			<option value="day" #doSelected(attributes.display_status,'day')#>day</option>
			<option value="week" #doSelected(attributes.display_status,'week')#>week</option>
			<option value="month" #doSelected(attributes.display_status,'month')#>month</option>
		</select></td>			
					
		<td><span class="formtextsmall"><br/></span>
		<a href="#self#?fuseaction=product.admin&review=list#Request.Token2#">ALL</a><br/>
		</td></tr>
		</form>

		<tr>
			<td colspan="7" style="BACKGROUND-COLOR: ###Request.GetColors.outputHBgcolor#;">
			<img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="1" /></td>
		</tr>
			
<cfif qry_get_reviews.recordcount gt 0>					
	<cfloop query="qry_get_reviews" startrow="#PT_StartRow#" endrow="#PT_EndRow#">
		<tr>
			<td><a href="#self#?fuseaction=product.admin&review=edit&Review_ID=#Review_ID##Request.Token2#">
			Edit #Review_ID#</a></td>
					
			<td colspan="2">
				<a href="#Request.StoreSelf#?fuseaction=product.reviews&do=display&Review_ID=#Review_ID##request.token2#" target="store"><strong>#LEFT(title, 27)#</strong></a><br/>
				
			#dateformat(posted,"mm/dd/yy")# &nbsp; <a href="#Request.StoreSelf#?fuseaction=product.display&product_ID=#product_ID##request.token2#" target="store">#LEFT(product_Name, 30)#</a>
				
			</td>			

			
			<td>
			<img src="#Request.ImagePath#icons/#Rating#_med_stars.gif" alt="" /><br/>
			<cfif helpful gte 0.8>
				Very Helpful
			<cfelseif helpful gte 0.6>
				Helpful
			<cfelseif helpful gte 0.4>
				Somewhat Helpful
			<cfelseif helpful gt 0>
				Not Very Helpful
			<cfelse>
				Unranked
			</cfif>
			</td>
			
						
			<td>#Editorial#</td>

			<td>
		<cfif approved is "0"><span style="color: red;"><strong>pending</strong></span>
		<cfelseif needsCheck is "1"><span style="color: orange;"><strong>check</strong></span>
		<cfelse>active</cfif>		
			</td>
			
			<td></td>
		</tr>
	
			</cfloop>	
	</table>
		
	<div align="right" class="formtext">#pt_pagethru#</div>
		
	<cfelse>	
		<td colspan="7">
		<br/>
		<span class="formerror">No records selected</span>
		</td>
	</table>	
	</cfif>
	
</cfoutput>

</cfmodule>

		
