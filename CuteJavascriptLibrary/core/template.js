Cute.Pack.reg("template.js",function(){
	Cute.template = function(tplname, data, isCached) {	//模板
		if (!this._templateCache) this._templateCache = {};
		tplname = "_" + tplname.toUpperCase() + "_TPL_";
		var func = this._templateCache[tplname];
		null == data && (data = {});
		if (!func) {
			var tpl = $("#" + tplname).html(); //.replace(/&lt;/g, "<").replace(/&gt;/g, ">");
			func = new Function("obj", "var _=[];with(obj){_.push('" +
					tpl.replace(/[\r\t\n]/g, " ")
					.replace(/'(?=[^#]*#>)/g, "\t")
					.split("'").join("\\'")
					.split("\t").join("'")
					.replace(/<#=(.+?)#>/g, "',$1,'")
					.split("<#").join("');")
					.split("#>").join("_.push('")
					+ "');}return _.join('');");
			(null == isCached || true === isCached) && (this._templateCache[tplname] = func);
		}
		return func(data);
	}
});