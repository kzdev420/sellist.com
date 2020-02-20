// Amazon Side Bar Menu- by JavaScript Kit (www.javascriptkit.com)
// Date created: March 15th, 2014
// Visit JavaScript Kit at http://www.javascriptkit.com/ for full source code

document.createElement("nav") // for IE

var amazonmenu = {

	defaults: {
		animateduration: 100,
		showhidedelay: [100, 100],
		hidemenuonclick: true
	},

	setting: {},
	menuzindex: 1000,
	touchenabled: !!('ontouchstart' in window) || !!('ontouchstart' in document.documentElement) || !!window.ontouchstart || !!window.Touch || !!window.onmsgesturechange || (window.DocumentTouch && window.document instanceof window.DocumentTouch),

	showhide:function($li, action, setting){
		clearTimeout( $li.data('showhidetimer') )
		if (action == 'show'){
			$li.data().showhidetimer = setTimeout(function(){
				$li.addClass('selected')
				$li.data('$submenu')
					.data('fullyvisible', false)
					.css({zIndex: amazonmenu.menuzindex++})
					.fadeIn(setting.animateduration, function(){
						$(this).data('fullyvisible', true)
					})
				}, this.setting.showhidedelay[0])
		}
		else{
			$li.data().showhidetimer = setTimeout(function(){
				$li.removeClass('selected')
				$li.data('$submenu').stop(true, true).fadeOut(setting.animateduration)
				var $subuls = $li.data('$submenu').find('.issub').css({display: 'none'})
				if ($subuls.length > 0){
					$subuls.data('$parentli').removeClass('selected')
				}
			}, this.setting.showhidedelay[1])
		}
	},

	setupmenu:function($menu, setting){
		var $topul = $menu.children('ul:eq(0)')

		function addevtstring(cond, evtstr){
			return (cond)? ' ' + evtstr : ''
		}

		$topul.find('li>div, li>ul').each(function(){ // find drop down elements
			var $parentli = $(this).parent('li')
			var $dropdown = $(this)
			$parentli
				.addClass('hassub')
				.data({$submenu: $dropdown, showhidetimer: null})
				.on('mouseenter click', function(e){
					amazonmenu.showhide($(this), 'show', setting)
				})
				.on('click', function(e){
					e.stopPropagation()
				})
				.children('a').on('click', function(e){
					e.preventDefault() // prevent menu anchor links from firing
				})
			$dropdown
				.addClass('issub')
				.data({$parentli: $parentli})
				.on('mouseleave' + addevtstring(setting.hidemenuonclick || amazonmenu.touchenabled, 'click'), function(e){
					if ($(this).data('fullyvisible') == true){
						amazonmenu.showhide($(this).data('$parentli'), 'hide', setting)
					}
					if (e.type == 'click'){
						e.stopPropagation()
					}
				})
		}) // end find
		$topul.on('click', function(e){
			if ($(this).data('fullyvisible') == true){
				amazonmenu.showhide($(this).children('li.hassub.selected'), 'hide', setting)
			}
		})
		var $mainlis = $topul.children('li.hassub').on('mouseleave', function(){
			amazonmenu.showhide($(this), 'hide', setting)		
		})
	},

	init:function(options){
		var $menu = $('#' + options.menuid)
		this.setting = $.extend({}, options, this.defaults)
		this.setting.animateduration = Math.max(50, this.setting.animateduration)
		this.setupmenu($menu, this.setting)
	}

}