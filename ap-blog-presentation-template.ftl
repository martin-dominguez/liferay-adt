<hr />
<div class="container">
	<#if !entries?has_content>
		<<#if !themeDisplay.isSignedIn()>
			${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
		</#if>
		<div class="alert alert-info">
			<@liferay_ui["message"] key="These are not the blogs you are looking for." />
		</div>
		
	<#else>
		<div class="row">
			<#list entries as curEntry>
				<#assign
					curEntry = curEntry
					assetRenderer = curEntry.getAssetRenderer()
					blogEntry = assetRenderer.getAssetObject()
					entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale))
					viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry)
				/>
				<div class="col-md-4 entry-card lfr-asset-item">
					<@clay["image-card"]
						imageSrc="${blogEntry.getCoverImageURL(themeDisplay)}"
						href="${viewURL}"
						title="${entryTitle}"
						subtitle="${blogEntry.getDisplayDate()?date}"/>
				</div>
		    </#list>
		</div>	
	</#if>
</div>