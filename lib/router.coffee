# Presentation stuff
PresentationController = RouteController.extend {
    layoutTemplate: 'PresentationLayout'
    onAfterAction: ->
        Blaze.addBodyClass 'presentation'
        Blaze.addBodyClass ->
            Router.current() and Router.current().route.getName()
        window.initApp();
}

Router.route '/', {
    controller: PresentationController
    name: 'presentation_home_main'
    action: ->
        @render 'presentation.home.main'
        return
}

Router.route '/interview/choose-time/:id', {
    controller: PresentationController
    name: 'presentation_interview_choose-time'
    waitOn: ->
        [
            Meteor.subscribe 'availabilities', @params.id
            Meteor.subscribe 'calendars'
            Meteor.subscribe 'interviews', @params.id
        ]
    action: ->
        interview = InterviewScheduler.Collections.Interview.first @params.id
        availabilities = InterviewScheduler.Collections.Availability.all()

        @.render 'presentation.interview.choose-time', {
            data: {
                interviewId: @params.id
                interview: interview
                availabilities: availabilities
            }
        }
        return
}

# Admin stuff
adminRoles = ['admin']

AdminController = RouteController.extend {
    layoutTemplate: 'AdminLayout'

    onBeforeAction: ->
        if not Roles.userIsInRole Meteor.userId(), ['hr']
            Router.go '/login'
        else
            @next()
    waitOn: ->
        [
            Meteor.subscribe 'calendars'
            Meteor.subscribe 'departments'
            Meteor.subscribe 'interviews'
        ]
    onAfterAction: ->
        Blaze.addBodyClass 'admin'
        Blaze.addBodyClass ->
            Router.current() and Router.current().route.getName()
        Session.set('refresh', Math.random()) # Used to refresh sidebar menu
        $('#side-menu .active').removeClass('active')
}

Router.route '/login', {
    data: {
        title: 'Please Login'
    }
    controller: PresentationController
    onBeforeAction: ->
        if Roles.userIsInRole Meteor.userId(), ['hr']
            Router.go '/admin'
        else
            @next()
    name: 'login'
    action: ->
        @.render 'login'
        return
}

Router.route '/admin', {
    data: {
        title: 'Upcoming Interviews'
        titleAction: '<a class="action" href="/admin/interview/new"> <i class="fa fa-plus-circle"></i> add new</a>'
    }
    controller: AdminController
    name: 'admin_hr_dashboard'
    waitOn: ->
        Meteor.subscribe 'interviews'
    action: ->
        calendars = InterviewScheduler.Collections.Calendar.find().fetch()

        if not calendars or not calendars.length
            Router.go '/admin/hr/setup'
        else

            now = new Date
            now = now.getTime() / GlobalSettings.timeslotDivider

            allInterviews = InterviewScheduler.Collections.Interview.where {
                $or: [
                    {
                        decided: null
                    },
                    {
                        decided:
                            $gte: now
                    }
                ]
            }

            @.render 'admin.hr.dashboard', {
                data:
                    allInterviews: allInterviews
                    upcomingInterviews: _.filter(allInterviews, (i) -> i.decided).length
                    interviewsCount: allInterviews.length
                    pendingInterviewsCount: _.filter(allInterviews, (i) -> (i.status is 'needsAction') or (not i.status and i.decided)).length
                    acceptedInterviewsCount: _.filter(allInterviews, (i) -> i.status is 'accepted').length
                    declinedInterviewsCount: _.filter(allInterviews, (i) -> i.status is 'declined').length
            }
        return
}

Router.route '/admin/hr/setup', {
    controller: AdminController
    data: {
        title: 'Set \'em Up!'
    }
    name: 'admin_hr_setup'
    action: ->
        options = {
            data: {
                departments: InterviewScheduler.Collections.Department.all()
            }
        }

        @.render 'admin.hr.setup', options
        return
}

Router.route '/admin/interview/new', {
    controller: AdminController
    data: {
        title: 'Schedule a New Interview'
    }
    waitOn: ->
        Meteor.subscribe 'calendars'
    name: 'admin_interview_new'
    action: ->
        @.render 'admin.interview.new', {
            data: {
                calendars: InterviewScheduler.Collections.Calendar.all()
            }
        }
        return
}

Router.route '/admin/interview/all', {
    controller: AdminController
    data: {
        title: 'All Interviews'
    }
    waitOn: ->
        Meteor.subscribe 'interviews'
        Meteor.subscribe 'calendars'
    name: 'admin_interview_all'
    action: ->
        @.render 'admin.interview.all', {
            data: {
                calendars: InterviewScheduler.Collections.Calendar.all()
            }
        }
        return
}

Router.route '/admin/interview/:id', {
    controller: AdminController
    loadingTemplate: 'loader'
    data: {
        title: 'Interview Availability'
    }
    name: 'admin_interview_view'
    waitOn: ->
        Meteor.subscribe 'availabilities', @params.id
        Meteor.subscribe 'calendars'
        Meteor.subscribe 'interviews'
    action: ->
        interview = InterviewScheduler.Collections.Interview.first @params.id
        availabilities = InterviewScheduler.Collections.Availability.all()

        @.render 'admin.interview.view', {
            data: {
                interviewId: @params.id
                interview: interview
                availabilities: availabilities
            }
        }
        return
}

Router.route '/admin/admins/all', {
    controller: AdminController
    data: {
        title: 'Admins - All'
    }
    action: ->
        @.render 'admin.admins.all'
        return
}

Router.route '/admin/admins/:_id/edit', {
    controller: AdminController
    action: ->
        admin = Meteor.users.findOne @params._id
        @.render 'admin.admins.edit', {
            data: admin
        }
        return
}