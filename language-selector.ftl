<style>
    .languageSelector .icon {
        position: unset!important;
        left: unset!important;
        top: unset!important;
        line-height: unset!important;
        z-index: 3;
        display: inline-flex!important;
    }
    .languageSelector .form-select {
        height: unset!important;
        left: unset!important;
        top: unset!important;
        line-height: unset!important;
        z-index: 3;
        display: inline-flex!important;
        width:unset!important;
    }
    .languageSelector select {
        background: transparent;
        border: none!important;
        text-transform: uppercase;
        max-width: 90px;
        font-size: 13px;
        color: #919191;
    }
    .languageSelector select:focus {
        outline:none!important;
    }
</style>

<script>
    function onChange()
    {
        window.location.href=$(".languageSelectorDropDown").val();
    }
</script>
<div class="input-group-icon languageSelector">
    <@liferay_ui.icon icon="globe" markupView="lexicon" />
    <div class="form-select " id="default-select">
        <select class="languageSelectorDropDown" onChange="onChange()">
            <#list entries as curLanguage>
                <#if !curLanguage.isSelected() >
                <option value="${curLanguage.getURL()!''}"  >
                </#if>
                <#if curLanguage.isSelected() >
                <option selected value="${curLanguage.getURL()!''}"  >
                </#if>
                    ${curLanguage.longDisplayName}
                </option>
            </#list>
        </select>
    </div>
</div>