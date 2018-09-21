$ ->
  if $("#schedule-region").length > 0
    competitionId = $("#schedule-region").data("competition-id")

    ScheduleDay = Backbone.Model.extend({})

    ScheduleDays = Backbone.Collection.extend
      model: ScheduleDay

    Competition = Backbone.Model.extend
      urlRoot: "/api/v1/competitions"

    ScheduleApp = Marionette.Application.extend
      region: "#schedule-region"

    ScheduleDayView = Marionette.CollectionView.extend
      template: Handlebars.compile($("#schedule-day-template").html())

    ScheduleDaysView = Marionette.CollectionView.extend
      template: false
      childView: ScheduleDayView
      table: ->
        @$("table").table()

    ScheduleView = Marionette.View.extend
      template: Handlebars.compile($("#schedule-template").html())
      regions:
        scheduleDays: ".schedule-days-region"

    ScheduleEmptyView = Marionette.View.extend
      template: false
      tagName: "p"
      onAttach: ->
        @$el.text("No available schedule (yet!)")

    setTimeout(
      -> $.mobile.loading("show")
      0
    )

    competition = new Competition(id: competitionId)
    console.log(competition)
    competition.fetch()
      .done ->
        $("h1.header-title").text(competition.get("name"))
        $("title").text(competition.get("name"))

        scheduleDays = new ScheduleDays()
        scheduleDaysView = new ScheduleDaysView(collection: scheduleDays)
        scheduleView = new ScheduleView(model: competition)

        scheduleApp = new ScheduleApp()
        scheduleApp.on "start", ->
          scheduleView.on "render", ->
            scheduleView.showChildView("scheduleDays", scheduleDaysView)
          scheduleApp.showView(scheduleView)
        scheduleApp.start()

        schedule = competition.get("schedule")
        _.each _.keys(schedule), (key) ->
          scheduleDays.add(day: key, rows: schedule[key])

        if scheduleDays.length > 0
          scheduleDaysView.table()
        else
          scheduleView.showChildView("scheduleDays", new ScheduleEmptyView())
      .fail ->
        alert("Failed to load schedule!")
      .always ->
        setTimeout(
          -> $.mobile.loading("hide")
          0
        )
