// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require js-routes
//= require jquery.turbolinks
//= require_tree .

window.loadedActivities = [];

Tinycon.setOptions({
    height: 10,
    font: '9px arial',
    colour: '#fff',
    background: '#f00',
    fallback: true
});

var thisPageTitle = document.title;

var addActivity = function(item) {
        var found = false;
        for (var i = 0; i < window.loadedActivities.length; i++) {
            if (window.loadedActivities[i].id == item.id) {
                var found = true;
            }
        }
        
        if (!found) {
            window.loadedActivities.push(item);
            window.loadedActivities.sort(function(a, b) {
               var returnValue;
               if (a.created_at > b.created_at)
                returnValue = -1;
               if (b.created_at > a.created_at)
                returnValue = 1;
               if (a.created_at == b.created_at)
                returnValue = 0;
               return returnValue;
            });
        }
    
    
    return item;
}

var renderActivities = function() {
    var source = $('#activities-template').html();
    var template = Handlebars.compile(source);
    var html = template({
        activities: window.loadedActivities,
        count: window.loadedActivities.length
                        });
    var $activityFeedLink = $('li#activity-feed');
    $activityFeedLink.addClass('dropdown');
    $activityFeedLink.html(html);
    $activityFeedLink.find('a.dropdown-toggle').dropdown();
    Tinycon.setBubble(window.loadedActivities.length);
    document.title = "(" + window.loadedActivities.length + ") " + thisPageTitle
}
var howManyTimes = 0;
var pollActivity = function () {
    howManyTimes++;
    if (howManyTimes == 1) {
    window.lastFetch = Math.floor((new Date).getTime() / 1000);
    }
    $.ajax({
        url: Routes.activities_path({format: 'json', since: window.lastFetch}),
        type: "GET",
        dataType: "json",
        success: function(data) {
            window.lastFetch = Math.floor((new Date).getTime() / 1000);
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    addActivity(data[i]);
                }
                
                renderActivities();
            }
        }
    });
}

Handlebars.registerHelper('activityFeedLink', function() {
   return new Handlebars.SafeString(Routes.activities_path()); 
});

Handlebars.registerHelper('activityLink',function() {
    var link, path, html;
    var activity = this;
    var linkText = activity.targetable_type.toLowerCase();
    
    switch (linkText) {
        case "status":
            path = Routes.status_path(activity.targetable_id);
            html = "<li><a href='" + path + "'><dl><dt><img style='margin-right: 5px;' class='img-circle pull-left' height='30px' width='30px' src='" + activity.user_avatar + "'> " + activity.user_name + " " + activity.action + " a " + linkText +":</dt><dd>" + activity.targetable.content + "</dd></dl></a></li>";
            break;
        case "album":
            path = Routes.album_path(activity.profile_name, activity.targetable_id);
            html = "<li><a href='" + path + "'><dl><dt><img style='margin-right: 5px;' class='img-circle pull-left' height='30px' width='30px' src='" + activity.user_avatar + "'> " +  activity.user_name + " " + activity.action + " an " + linkText +":</dt><dd>" + activity.targetable.title + "</dd></dl></a></li>";
            break;
        case "picture":
            path = Routes.album_picture_path(activity.profile_name, activity.targetable.album_id, activity.targetable_id);
            if (activity.action == "created") {
                activity.action = "added"
            }
            html = "<li><a href='" + path + "'><dl><dt><img style='margin-right: 5px;' class='img-circle pull-left' height='30px' width='30px' src='" + activity.user_avatar + "'> " +  activity.user_name + " " + activity.action + " a " + linkText +":</dt><dd>" + activity.targetable.caption + "</dd></dl></a></li>";
            break;
        case "userfriendship":
            path = Routes.profile_path(activity.profile_name);
            linkText = "friend";
            activity.action = "accepted";
            html = "<li><a href='" + path + "'><dl><dt><img style='margin-right: 5px;' class='img-circle pull-left' height='30px' width='30px' src='" + activity.user_avatar + "'> " +  activity.user_name + " " + activity.action + " a " + linkText +".</dt><dd></dd></dl></a></li>";
            break;
    }
    
    
    return new Handlebars.SafeString(html); 
});

var clearNotifications = function() {
    window.loadedActivities = [];
    document.title = thisPageTitle;
    Tinycon.reset();
    $('li#activity-feed').html("<a class='dropdown-toggle' href='#' data-toggle='dropdown'>Activity</a><ul class='dropdown-menu' role='menu'><li><a href='#'><dl><dd>No new activity</dd></dl></a></li><li class='divider></li><li><a href='" + Routes.activities_path() + "Activities</a></li></ul>");
}

setTimeout("jQuery('.alert').alert('close');", 3000);

window.pollInterval = window.setInterval( pollActivity, 5000 );