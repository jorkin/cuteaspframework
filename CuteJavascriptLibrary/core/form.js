//表单
Cute.Pack.reg("core/form.js",function(){
	Cute.form = {	//表单
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
		}
	};
});