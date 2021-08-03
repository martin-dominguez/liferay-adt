<script>
	var _calendarEvents = [];
	
    const getDescription = (desc) => {
        var div = document.createElement("div");
        div.innerHTML = desc;
        return ( (div.textContent || div.innerText || "").substr(0,150));
    };
</script>
<#assign flag = false />
<#if entries?has_content>
	<#list entries as curEntry>
		<#assign
			renderer = curEntry.getAssetRenderer()
			className = renderer.getClassName()
		/>

		<#if className !="com.liferay.calendar.model.CalendarBooking">
			<#assign flag = true />
			<#break>
		</#if>
		<#assign
			assetObject = renderer.getAssetObject()
			title = assetObject.getTitle(locale, true)
			description = assetObject.getDescription(locale, true)! ""
			id = assetObject.getCalendarBookingId()
            startTime = assetObject.getStartTime()
			startDate = startTime?number_to_datetime
			endTime = assetObject.getEndTime()
			endDate = assetObject.getEndTime()?number_to_datetime
			formattedStartDate = startDate?string[ "M/d/yyyy"]
			formattedEndDate = endDate?string[ "M/d/yyyy"]
			formattedStartTime = startDate?string[ "HH:ss"]
			formattedEndTime = endDate?string[ "HH:ss"]
			calendarId = assetObject.getCalendarId()
            recurrenceRule = assetObject.getRecurrence()
		/>
		<script>
            var eventStartDate = new Date(${startTime});
            var eventEndDate = new Date(${endTime});
            var recurrence = "${recurrenceRule}";
            
            if (recurrence) {
                const recurrenceRule = recurrence.split(":")[1];
                const recurrenceSplit = recurrenceRule.split(";");
                
                var period = "";
                var interval = 0;
                var lastDay = new Date(new Date().getFullYear() + 1, 0, 1);
                
                recurrenceSplit.forEach((ele) => {
                    const eleSplit = ele.split("=");
                    const key = eleSplit[0].trim();
                    const value = eleSplit[1].trim();
                    
                    switch ( key ) {
                        case "FREQ":
                            period = value;
                            break;
                        case "INTERVAL":
                            interval = parseInt(value);
                            break;
                        case "UNTIL":
                            const lastDDay = value.substr(-2);
                            const lastMonth = value.substr(4,2);
                            const lastYear = value.substr(0,4);
                            lastDay = new Date(lastYear, lastMonth -1, lastDDay);
                            break;
                    }
                }); 
                
                do {
                    var event = { 
                        id: "${id}",
                        name: "${title}.",
                        date: [eventStartDate.getMonth() + 1  + "/" + eventStartDate.getDate() + "/" + eventStartDate.getFullYear(), eventEndDate.getMonth() + 1  + "/" + eventEndDate.getDate() + "/" + eventEndDate.getFullYear()],
                        type: "${calendarId}",
                        description: "<span class='font-weight-bold'>${formattedStartTime} - ${formattedEndTime}</span><br/>"+ getDescription(`${description}`)
                    };
                    _calendarEvents.push(event);
                    
                    switch (period) {
                        case "DAILY":
                            eventStartDate.setDate(eventStartDate.getDate() + (1 * interval));
                            eventEndDate.setDate(eventEndDate.getDate() + (1 * interval));
                            break;
                        case "WEEKLY":
                            eventStartDate.setDate(eventStartDate.getDate() + (7 * interval));
                            eventEndDate.setDate(eventEndDate.getDate() + (7 * interval));
                            break;
                        case "MONTHLY":
                            eventStartDate.setMonth(eventStartDate.getMonth() + (1 * interval));
                            eventEndDate.setMonth(eventEndDate.getMonth() + (1 * interval));
                            break;
                    }
                } while (eventStartDate.getTime() < lastDay)
            } else {
                var event = { 
                    id: "${id}",
                    name: "${title}",
                    date: ["${formattedStartDate}", "${formattedEndDate}"],
                    type: "${calendarId}",
                    description: "<span class='font-weight-bold'>${formattedStartTime} - ${formattedEndTime}</span><br/>"+ getDescription(`${description}`)
                };
                _calendarEvents.push(event);
            }
		</script>
	</#list>
</#if>
<#if flag==false>
    <!-- Add jQuery library (required) -->
    <script src="//cdn.jsdelivr.net/npm/jquery@3.4.1/dist/jquery.min.js"></script>
    
    <!-- Add the evo-calendar.js for.. obviously, functionality! -->
    
    <script src="//cdn.jsdelivr.net/npm/evo-calendar@1.1.2/evo-calendar/js/evo-calendar.min.js"></script>
    <!-- Add the evo-calendar.css for styling -->
    
    <link href="//cdn.jsdelivr.net/npm/evo-calendar@1.1.0/evo-calendar/css/evo-calendar.min.css" rel="stylesheet" type="text/css" />
    
    <style>
        body {
            font-family: var(--font-family-base);
        }
        /* Shadows */
        .evo-calendar {
            -webkit-box-shadow: 0 10px 25px -20px #000;
            box-shadow: 0 10px 25px -20px #000;
        }
        #sidebarToggler,
        #eventListToggler,
        .evo-calendar .calendar-sidebar{
            -webkit-box-shadow: 5px 0 18px -6px #000 !important;
            box-shadow: 5px 0 18px -6px #000 !important;
        }
        .evo-calendar.sidebar-hide .calendar-sidebar {
            -webkit-box-shadow: none !important;
            box-shadow: none !important;
        }
        /* Theme colors */
        .calendar-sidebar,
        .calendar-sidebar > span#sidebarToggler,
        .calendar-sidebar > .calendar-year,
        .calendar-sidebar > .month-list,
        tr.calendar-body .calendar-day .day.calendar-today,
        #eventListToggler,
        .event-container > .event-icon > div[class^="event-bullet-"],
        .event-indicator > .type-bullet > div[class^="type-"] {
            background-color: var(--primary);
        }
        th[colspan="7"] {
             color: var(--primary);
        }
        .event-list > .event-empty {
            border-color: var(--primary);
        }
        .calendar-sidebar>.month-list>.calendar-months>li.active-month,
        .calendar-sidebar>.month-list>.calendar-months>li:hover {
            background-color: var(--secondary);
        }
        
        .evo-calendar tr.calendar-body .calendar-day {
            padding: 0px;
        }
        
        .evo-calendar tr.calendar-body .calendar-day .day {
            padding: 5px;
            width: initial;
            height: initial;
            max-width: 34px;
        }
        .evo-calendar  tr.calendar-header .calendar-header-day {
            padding: 5px;
            color: var(--dark);
        }
        .evo-calendar .calendar-inner .calendar-table {
            font-size: 14px;
        }
        .evo-calendar th[colspan="7"],
        .evo-calendar .calendar-events>.event-header>p {
            font-size: 20px;
            color: var(--dark);
        }
        .evo-calendar .calendar-sidebar>span#sidebarToggler,
        .evo-calendar span#eventListToggler{
            width: 50px;
            height: 50px;
        }
        
        .evo-calendar button.icon-button>span.bars,
        .evo-calendar button.icon-button>span.bars::before, 
        .evo-calendar button.icon-button>span.bars::after {
            height: 3px;
        }
        
        .evo-calendar button.icon-button>span.bars::before { top: -9px; }
        .evo-calendar button.icon-button>span.bars::after { bottom: -9px; }
        
        .evo-calendar button.icon-button>span.chevron-arrow-right {
            width: 20px;
            height: 20px;
        }
        
        .evo-calendar .calendar-sidebar>.calendar-year>button.icon-button>span[class^="chevron-arrow-"] {
            width: 10px;
            height: 10px;
        }
        
        .evo-calendar .calendar-sidebar>.calendar-year>p {
            margin-left:; 3px;
            font-size: 20px;
        }
        
        .evo-calendar .calendar-sidebar>.calendar-year {
            padding: 10px 0px 0px;
        }
        
        .evo-calendar .calendar-sidebar>.month-list>.calendar-months>li {
            font-size: 12px;    
            padding: 3px 30px;
        }
        
        .evo-calendar .calendar-inner {
            padding: 40px 30px 70px 30px;
            max-width: calc(100% - 400px);
        }
        .evo-calendar .calendar-events{
            padding: 40px 30px 70px 30px;
        }
        
        .evo-calendar .event-indicator {
            top: 130%;
        }
        
        .evo-calendar .calendar-events>.event-header>p {
           font-size: 20px;
        }
        .evo-calendar .calendar-events .event-info p{
           font-size: 14px;
        }
        .evo-calendar .event-container>.event-info> p.even-title {
            font-weight: 600;
        }
        .evo-calendar p.event-desc {
            max-width: 250px;
        }
        
        .evo-calendar p.event-title {
            font-weight: 500;
        }
        
        /* fallback color */
        .evo-calendar .event-container>.event-icon>div[class^="event-bullet-"] {
            width: 100%;
            height: 100%;
            border-radius: 50%;
        }
        .evo-calendar .event-container>.event-icon>div.event-bullet-226906,
        .evo-calendar .event-indicator>.type-bullet>div.type-226906 {
            background-color: #5abfb3;
        }
        .evo-calendar .event-container>.event-icon>div.event-bullet-48417,
        .evo-calendar .event-indicator>.type-bullet>div.type-48417 {
            background-color: #d96868;
        }
    </style>
    
    <div id="evoCalendar"></div>
    <script>
    $('#evoCalendar').evoCalendar({
        language: Liferay.ThemeDisplay.getLanguageId().substr(0,2),
        firstDayOfWeek: 1,
        calendarEvents: _calendarEvents,
        sidebarDisplayDefault: false
    });
    </script>
<#else>
	<div>
		<p>Please select a valid calendar events collection</p>
	</div>
</#if>