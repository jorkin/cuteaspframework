/**
 * 数据延迟加载组件
 * 修改自KISSY的datalazyload
 */
define(function() {
	Cute.plugin.datalazyload = function(options) {
		var opt = $.extend({
			elements: "img[dynamic-src][src=]",
			threshold: 0,
			failurelimit: 1,
			event: "scroll",
			direction: 1, //0:横、纵   1:纵   2:横
			effect: "show",
			effectspeed: 0,
			container: window
		}, options || {});
		var _this = this;
		opt.elements = $(opt.elements);
		opt.container = $(opt.container);
		if (opt.event == "scroll") {
			$(opt.container).bind("scroll.loader resize.loader", function(event) {
				var _counter = 0;
				opt.elements.each(function() {
					if (_scrollY(this, opt) && _scrollX(this, opt)) {
						if (!this.loaded) {
							if (opt.effectspeed > 0) {
								$(this).hide().attr("src", this.getAttribute("dynamic-src")).removeAttr("dynamic-src")[opt.effect](opt.effectspeed);
							} else {
								$(this).attr("src", $(this).attr("dynamic-src")).removeAttr("dynamic-src");
							}
							this.loaded = true;
						}
						if (this.loaded) {
							opt.elements = opt.elements.not(this);
						}
					} else {
						if (_counter++ > opt.failurelimit) {
							return false;
						}
					}
				});
			});
		}
		opt.elements.each(function(i, item) {
			if ($(item).attr("dynamic-src") == undefined) {
				$(item).attr("dynamic-src", function() { return this.src; });
			}
			var src = $(item).attr("src") || "";
			if (opt.event != "scroll" || src == "" || src == opt.placeholder) {
				if (opt.placeholder) {
					$(item).attr("src", opt.placeholder);
				} else {
					$(item).removeAttr("src");
				}
				item.loaded = false;
			} else {
				item.loaded = true;
			}
		});
		opt.container.triggerHandler(opt.event);
		return this;
	};
	var _scrollY = function(element, opt) {
		if (opt.direction == 0 || opt.direction == 1) {
			if (opt.container[0] === window) {
				var fold = $(window).height() + $(window).scrollTop();
			} else {
				var fold = opt.container.offset().top + opt.container.height();
			}
			return fold > $(element).offset().top - opt.threshold;
		} else {
			return true;
		}
	};
	var _scrollX = function(element, opt) {
		if (opt.direction == 0 || opt.direction == 2) {
			if (opt.container[0] === window) {
				var fold = $(window).width() + $(window).scrollLeft();
			} else {
				var fold = opt.container.offset().left + opt.container.width();
			}
			return fold > $(element).offset().left - opt.threshold;
		} else {
			return true;
		}
	}
});