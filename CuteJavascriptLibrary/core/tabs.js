//页签
Cute.tabs = {	
	bind: function(obj, cobj) {
		$("dd>ul:eq(0)>li", obj).click(function() {
			var _class = this.className.split(" ");
			if ($.inArray("none", _class) == -1 && $.inArray("more", _class) == -1) {
				var _index = $(this).parent().children(":not(.more,.none)").index($(this).addClass("curr").siblings().removeClass("curr").end()[0]);
				if (cobj && $(cobj).length > 0) $(cobj).hide().eq(_index).show();
			}
		});
		$("dd>ul.tabs_sub>li>a", obj).click(function() {
			var _this = $(this).parent();
			var _class = _this[0].className.split(" ");
			if ($.inArray("none", _class) == -1) {
				_this.addClass("curr").siblings().removeClass("curr");
			}
		});
		if ($(".more_list li", obj).length > 0) {
			$("li.more>a:eq(0)", obj).click(function() {
				var _this = $(".more_list", obj);
				_this.toggle().out("click", function(e) {
					var found = $(e.target).closest(_this).length || e.target == this;
					if (found == 0) _this.hide();
				} .bind(this), true);
			});
		}
	}
};