//日期联动菜单
Cute.plugin.dateSelector = Cute.Class.create({
	initialize: function(yobj, mobj, dobj, options) {
		options = options || {};
		if (arguments.length == 0) return false;
		var y = $(yobj),
			m = $(mobj),
			d = $(dobj);
		if (y.length == 0) return;
		var newDate = new Date();
		y[0].options.length = 81;
		for (var i = 1; i < y[0].options.length; i++) {
			y[0].options[i].text = newDate.getFullYear() - 60 + i;
			y[0].options[i].value = newDate.getFullYear() - 60 + i;
		}
		if (arguments.length > 1) {
			if (m.length == 0) return;
			m[0].options.length = 13;
			for (var i = 1; i < m[0].options.length; i++) {
				m[0].options[i].text = i;
				m[0].options[i].value = i;
			}
			y.change(function() { m.change(); });
			if (arguments.length > 2) {
				if (d.length == 0) return;
				m.change(function() {
					var _index = d[0].selectedIndex;
					d[0].options.length = new Date(y.val(), m.val(), 0).getDate() + 1;
					for (var i = 1; i < d[0].options.length; i++) {
						d[0].options[i].text = i;
						d[0].options[i].value = i;
					}
					if (_index >= d[0].options.length) {
						d[0].selectedIndex = d[0].options.length - 1;
					} else {
						d[0].selectedIndex = _index;
					}
					d.change();
				});
			}
		}
		if (options.value) {
			setTimeout(function() {
				y.find("option[value=" + options.value.Year + "]").attr("selected", true).end().change();
				m.val(options.value.Month).change();
				d.val(options.value.Day).change();
			}, 0);
		}
	}
});