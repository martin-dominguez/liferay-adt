<#assign 
    vocabularyLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService")
    catPropertyLocalService = serviceLocator.findService("com.liferay.asset.category.property.service.AssetCategoryPropertyLocalService")
    dlFileEntryLocalService =  serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")
    stringPool = staticUtil["com.liferay.petra.string.StringPool"]
/>

<!-- Just interested in categorized elements -->
<#list vocabularyLocalService.getGroupVocabularies(getterUtil.getLong(groupId)) as vocabulary>
    <#if vocabulary.getName() == "asset type">
        <#assign assetTypeId = vocabulary.getVocabularyId() />
    </#if>
</#list>

<#if entries?has_content>
    <style>
        ul.asset-list li {
            box-shadow: 0.25rem 0.25rem 0.6rem rgba(0,0,0,0.05), 0 0.5rem 1.125rem rgba(75,0,0,0.05);
            border-radius: 1em;
        }
        .asset-list .list-badge {
            width: 42px !important;
            height: 42px !important;
            padding: 1em;
        }
        .asset-list .badge {
            border-radius: 1em;
        }
        .asset-list .cat-tag {
            width: 300px;
        }
        .asset-list .titles h4 {
            margin-bottom: 0;
        }
        
        .asset-list .asset-name {
            font-size: 1rem;
            font-weight: 700;
        }
        
        /* Medium devices (landscape tablets, 768px and up) */
        @media only screen and (max-width: 600px) {
            ul.asset-list li,
            ul.asset-list li .cat-tag {
                flex-direction: column;
                text-align: center;
            }
            
            .asset-list .badge {
                justify-content: center;
            }
            
            .asset-list .asset-name {
                font-size: 1.2rem;
                margin: 1em 0 !important;
            }
        }
        
    </style>
    <ul class="asset-list list-unstyled">
	    <#list entries as entry>
    		<#assign 
    		    entry = entry 
    		    assetRenderer = entry.getAssetRenderer()
    		    entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale))
    		    viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, assetRenderer, entry, !stringUtil.equals(assetLinkBehavior, "showFullContent"))
    		    
    		    dateFormat = "dd MMM yyyy"
    		    className = assetRenderer.getClassName()
    		/>
    		
    		<#list className?split(".") as z>
    		    <#if z?is_last>
    		        <#assign assetType = z />
    		    </#if>
    		</#list>
    		
    		<li class="d-flex align-items-center justify-content-between p-3 mb-4">
    		    <!-- Categories -->
    		    <div class="cat-tag d-flex">
                    <#list entry.getCategories() as category>
                        
                        <#if assetTypeId?? && category.getVocabularyId() == assetTypeId>
                            <#assign 
                                catIcon = catPropertyLocalService.getCategoryProperty(category.getCategoryId(), "icon").value
                                catBadgeColor = catPropertyLocalService.getCategoryProperty(category.getCategoryId(), "color").value
                            />
                        </#if>
                        <span class="badge badge-${catBadgeColor} text-white">
                            <span class="badge-item badge-item-expend">
                                <@clay["icon"] 
                                    className = "list-badge"
                                    symbol=catIcon
                                />
                            </span>
                        </span>
                		    
                        <div class="cat-name-tags ml-sm-3">
                            <a 
                                href="${themeDisplay.getURLCurrent()}&p_r_p_categoryId=${category.getCategoryId()}" 
                                class="category-link d-block text-primary" 
                                title="${category.name}"
                            >
                                <span class="category text-uppercase">${category.name}</span>
                            </a>
                            <!-- Tags -->
                    		<@liferay_asset["asset-tags-summary"]
                    			className=entry.getClassName()
                    			classPK=entry.getClassPK()
                    			portletURL=renderResponse.createRenderURL()
                    		/>
                        </div>
                    </#list>
                </div>
                
    		    <!-- Document title -->
        		<h3 class="asset-name ml-sm-3 mb-0">
                    <a href="${viewURL}" class="text-dark">
                        ${entryTitle}
                    </a>
                </h3>
                
                <!-- Date Published -->
        		<div class="data-published ml-sm-auto mr-sm-3">
        		    ${dateUtil.getDate(entry.getPublishDate(), dateFormat, locale)}
        		</div>
        		
        		<!-- Ratings -->
        		<#if getterUtil.getBoolean(enableRatings) && assetRenderer.isRatable()>
            		<div class="asset-ratings">
            			<@liferay_ratings["ratings"]
            				className=entry.getClassName()
            				classPK=entry.getClassPK()
            			/>
            		</div>
            	</#if>
            	
            	
                <div class="d-flex" style="min-width: 120px">
                    <!-- Asset Type -->
            		<div class="asset-type">
            		    <#if assetType??>
            		        <#assign assetTypeIcon = "question" />
            		        <#if assetType == "DLFileEntry" >
            		            <#assign assetTypeIcon = "document-text" />
            		        <#elseif assetType == "BlogsEntry">
            		            <#assign assetTypeIcon = "blogs" />
            		        <#elseif assetType == "JournalArticle">
            		            <#assign assetTypeIcon = "web-content" />
                    		</#if>
                    		<span class="badge badge-white border border-primary text-primary ml-1">
                    		    <span class="badge-item badge-item-expend">
                		        <@clay["icon"] symbol=assetTypeIcon className="list-badge" />
                		        </span>
                            </span>
            		    </#if>
        		    </div>
            		
            		<!-- Download -->
            		<#if assetType == "DLFileEntry" >
                        <#assign
                		    dlFileEntryId = assetRenderer.getClassPK()
                		    dlFileEntry = dlFileEntryLocalService.getFileEntry(dlFileEntryId)
                		    dlFileVersion = dlFileEntry.getLatestFileVersion(false)
                		    
                		    viewURL = themeDisplay.getPortalURL() + themeDisplay.getPathContext() + "/documents/" + dlFileEntry.getGroupId() + stringPool.SLASH + dlFileEntry.getFolderId() + stringPool.SLASH + urlCodec.encodeURL(htmlUtil.unescape(dlFileEntry.getTitle())) + stringPool.SLASH + dlFileEntry.getUuid() + "?version=" + dlFileVersion.getVersion()
                		/>
                		
                		<div class="download-icon">
                		    <a href="${viewURL}" title="Download" target="_blank">
                        		<span class="badge badge-white border border-secondary text-secondary ml-1">
                        		    <span class="badge-item badge-item-expend">
                    		        <@clay["icon"] symbol="download" className="list-badge" />
                    		        </span>
                                </span>
                		    </a>
                		</div>
                	</#if>
                </div>
        		
        		
        		
    		</li>
    		
    		
    	</#list>
    </ul>
<#else>
	<#if !themeDisplay.isSignedIn()>
		${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
	</#if>

	<div class="alert alert-info">
		<@liferay_ui["message"]
			key="there-are-no-results"
		/>
	</div>
</#if>

<#macro getPrintIcon>
	<#if getterUtil.getBoolean(enablePrint)>
		<#assign printURL = renderResponse.createRenderURL() />

		${printURL.setParameter("mvcPath", "/view_content.jsp")}
		${printURL.setParameter("assetEntryId", entry.getEntryId()?string)}
		${printURL.setParameter("viewMode", "print")}
		${printURL.setParameter("type", entry.getAssetRendererFactory().getType())}
		${printURL.setWindowState("pop_up")}

		<@liferay_ui["icon"]
			icon="print"
			markupView="lexicon"
			message="print"
			url="javascript:Liferay.Util.openModal({headerHTML: '" + languageUtil.format(locale, "print-x-x", ["hide-accessible", entryTitle], false) + "', id:'" + renderResponse.getNamespace() + "printAsset', url: '" + htmlUtil.escapeURL(printURL.toString()) + "'});"
		/>
	</#if>
</#macro>