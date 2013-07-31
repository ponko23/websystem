navWrite = () ->
  obj = [
    "title": "Home"
    "path": "/"
  ,
    "title": "Profile",
    "path": "/profile/"
  ,
    "title": "TimeSheet",
    "path": "/timesheet/"
  ]
  navlist = ['<ul>']
  for page in obj
    navlist.push '<li><a href="', page.path, '">', page.title, '</a></li>'
  navlist.push '</ul>'
  $('nav').append navlist.join ''

  url = location.pathname
  $("nav a[href=\"#{url}\"]").css 'background-color', '#fff'


###
  $.ajax
    url: '/data/sitemap.json'
    dataType: 'json'
    type: 'GET'
    success: (obj) ->
      navlist = ['<ul>']
      for page in obj.siteMap
        navlist.push '<li><a href="', page.path, '">', page.title, '</a></li>'
      navlist.push '</ul>'
      $('nav').append navlist.join ''

      url = location.pathname
      $("nav a[href=\"#{url}\"]").css 'background-color', '#fff'
###
$(document).ready ->
  navWrite()
