<div class="row">
	<#if !entries?has_content>
		<<#if !themeDisplay.isSignedIn()>
			${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
		</#if>
		<div class="alert alert-info">
			<@liferay_ui["message"] key="These are not the blogs you are looking for." />
		</div>
		
	<#else>
    	<#list entries as curEntry>
			<#assign
				assetRenderer = curEntry.getAssetRenderer()
				blogEntry = assetRenderer.getAssetObject()
				entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale))
				viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry)
				creationDate = blogEntry.getDisplayDate()?date
				summary = curEntry.getDescription()
			/>
            <#if validator.isNull(summary)>
                <#assign summary = curEntry.getSummary(locale) />
            </#if>
    	    <div class="col-lg-4">
				<div class="in-blog h-100 mt-3">
					<#if (blogEntry.getCoverImageURL(themeDisplay))??>	
						<div class="in-blog-image">
							<a href="${viewURL}" title="${entryTitle}">
								<img src="${blogEntry.getCoverImageURL(themeDisplay)}" alt="${entryTitle}" />
							</a>
						</div>
					</#if>
					<div class="in-blog-content">
						<div class="in-blog-metatop">
							<span>${creationDate}</span>
							<span><a href="${viewURL}" title=${entryTitle}>LifeSeguros</a></span>
						</div>
						<h4 class="in-blog-title"><a href="${viewURL}">${entryTitle}</a></h4>
						<p>${summary?substring(0,200)}...</p>
						<div class="in-blog-authorimage">
							<@liferay_ui["user-portrait"]
									size="sm"
									userId=curEntry.userId
									userName=curEntry.userName
								/>
						</div>
						<div class="in-blog-metabottom">
							<span>Por: <a href="${viewURL}">${assetRenderer.getUserName()}</a></span>
						</div>
					</div>
				</div>
			</div>
    	</#list>
    </#if>
</div>