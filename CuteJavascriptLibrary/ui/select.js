Cute.Pack.reg("ui/select.js",function(){
	Cute.ui.select = Cute.Class.create({
		initialize:function (obj) {
			var self = $(obj);
			var box = $('<div class="dropselectbox" />').appendTo(self.hide().wrap('<div class="dropdown" />').parent());
			$('<h4><span class="symbol arrow">▼</span><strong>' + self.children("option:selected").text() + '</strong></h4>').hover(function() {
				$(this).toggleClass("hover", option.is(":visible") ? true : null);
			}).appendTo(box).one("click", function() {
				self.children("option").each(function(i, item) {
					$('<li><a href="javascript:void(0)">' + $(item).text() + '</a></li>').appendTo(option).click(function() {
						option.prev().children("strong").html($(item).text());
						self.val(item.value).change();
						option.hide();
					});
				});
			}).click(function() {
				option.toggle();
			}).out("click", function() {
				$(this).removeClass("hover");
				option.hide();
			}, true);
			var option = $('<ul />').appendTo(box);
			return this;
		}
	});
});