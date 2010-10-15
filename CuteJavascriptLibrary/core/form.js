//表单
Cute.form = {
	bindDefault: function(obj) {
		$(obj || "input.default,textarea.default").live("focus", function() {
			if (this.value == this.defaultValue) {
				this.value = '';
				this.style.color = "#000";
			}
		}).live("blur", function() {
			if (this.value == '') {
				this.value = this.defaultValue;
				this.style.color = '#ccc';
			}
		});
	},
	bindFocus: function(obj) {
		$(obj || "input.text,textarea.textarea").live("focus", function() {
			$(this).addClass("focus");
		}).live("blur", function() {
			$(this).removeClass("focus");
		});
	},
	isInputNull: function(obj) {
		obj = $(obj);
		if (obj.length == 0) return false;
		var _value = obj.val().trim();
		if (_value == "" || _value == obj[0].defaultValue) {
			return true;
		}
		return false;
	},
	bindSelect: function(obj) {
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
	}
};