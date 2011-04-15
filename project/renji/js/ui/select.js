//下拉菜单
Cute.ui.select = Cute.Class.create({
	initialize: function(obj) {
		var self = $(obj).hide();
		var wrap = self.wrap('<div class="dropdown" />').parent();
		var box = $('<div class="dropselectbox" />').appendTo(wrap);
		$('<h4><span class="symbol arrow">▼</span><strong>' + self.children("option:selected").text() + '</strong></h4>').appendTo(box).hover(function() {
			$(this).toggleClass("hover", option.is(":visible") ? true : null);
		}).click(function(e) {
			option.toggle();
		}).out("click", function() {
			$(this).removeClass("hover");
			option.hide();
		}, true);
		var option = $('<ul />').appendTo(box);
		self.children("option").each(function(i, item) {
			$('<li><a href="##">' + $(item).text() + '</a></li>').appendTo(option).click(function() {
				option.prev().children("strong").html($(item).text());
				self.val(item.value).change();
				option.hide();
			});
		});
		wrap.width(option.outerWidth());
		return self;
	}
});