/*! Built with Catalyst. */(function(){$(function(){var a,t,e,n;e="3xlPd7HNCu",t="2047353728.75c688d.ac058af6b2cf44b6a0b491636a3a3eaa",a="f305462cd1557500084f9aa7c2c993d2c8e6b12f",n={labels:[],data:[]},FastClick.attach(document.body),$.extend(Chart.defaults.global,{tooltipFillColor:"rgba(24, 24, 25, 0.8)",tooltipFontSize:13,tooltipYPadding:10,tooltipXPadding:10,tooltipTemplate:"<%=label%>: <%= value %> stars"}),async.parallel([function(t){$.getJSON("https://api.github.com/users/haydenbleasel/repos?access_token="+a+"&callback=?",function(a){a.data.sort(function(a,t){return t.stargazers_count-a.stargazers_count}),async.each(a.data,function(a,t){return!a.fork&&n.labels.length<6&&(n.labels.push(a.name),n.data.push(a.stargazers_count)),t()},function(a){return t(null)})})},function(a){$.getJSON("https://api.instagram.com/v1/media/shortcode/"+e+"?access_token="+t+"&callback=?",function(t){return $("#count").text(t.data.likes.count),$("#instagram").css("background-image",'url("'+t.data.images.standard_resolution.url+'")'),$("#link").attr("href",t.data.link),a(null)})},function(a){$("#information").fullpage({anchors:["hayden","career","education","design","code"],navigation:!0,navigationPosition:"right",navigationTooltips:["hayden","career","education","design","code"],easingcss3:"cubic-bezier(0.25, 0.46, 0.45, 0.94)",paddingTop:"60px",paddingBottom:"60px",sectionSelector:"section",afterRender:function(){return a(null)}})}],function(a){var t,e;$("body").removeClass("hidden"),e=$("#canvas").get(0).getContext("2d"),t=new Chart(e).Bar({labels:n.labels,datasets:[{label:"Stargazers",fillColor:"rgba(96,101,115,0.25)",strokeColor:"rgba(96,101,115,0)",highlightFill:"rgba(96,101,115,0.5)",highlightStroke:"rgba(96,101,115,0)",data:n.data}]},{showScale:!1})})})}).call(this);