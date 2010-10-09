/// <reference path="jquery-1.3.2-vsdoc2.js" />
//基础框架
var Cute = {
	Config:{
		siteUrl:"",
		resourceUrl:"",
		scriptPath: "scripts/",
		debug: true
	},
	isReady: false,
	init: function(){
		this._module = {
			"core.ui":{
				"name": "core.ui",
				"path": "cute-ui"
			},
			"core.widget": {
				"name":"core.widget",
				"path":"widget"
			},
			"core.formvalidator": {
				"name":"core.formValidator",
				"path": "formValidator",
				"csspath":"style/validatorAuto.css",
				"requires":["core.formvalidatorregex"]
			},
			"core.formvalidatorregex": {
				"name":"core.formvalidatorregex",
				"path": "formValidatorRegex"
			},
			"tools.editor": {
				"name":"tools.editor",
				"path": "kindeditor"
			},
			"tools.flash": {
				"name":"tools.flash",
				"path": "swfobject_modified"
			}
		};
		// 可以通过在 url 上加 ?cute-debug 来开启 debug 模式
		if (window.location.search && window.location.search.indexOf('cute-debug') !== -1) {
			this.Config.debug = true;
		}
		return this;
	},
	Module:{
		_mods: {},
		_customUrls: {},
		_urlLoads:{},
		include: function(names, callback, options){
			callback = callback || function(){};
			names = names.replace(/\s/g, '');
			if(names == ''){
				window.setTimeout(callback, 0);
				this._options(options);
				return;
			}
			var nameArr = names.split(','), mod, loads=[], requires = [];
			for(var i = 0, il = nameArr.length; i< il; i++){
				mod = this._getModule(nameArr[i]);
				if(mod.status != 3){
					if(mod.status == 0) loads.push(mod);
					requires.push(mod);
				}
			}
			if(requires.length == 0){
				window.setTimeout(callback, 0);
				this._options(options);
				return;
			}
			var wait = new Cute.Wait(requires, callback, options);
			for(var i = 0, il = requires.length; i < il; i++){
				requires[i].waits.push(wait);
			}
			for(var i = 0, il = loads.length; i < il; i++){
				this._loadModule(loads[i]);
			}
		},
		reg: function(name, callback, requires){
			var mod = this._getModule(name);
			if(mod.status == 3) return;
			if(requires && typeof requires == 'string'){
				mod.status = 2;
				this.include(requires, Como.Function.bind(this.reg, this, name, callback));
			} else {
				if(callback) callback();
				mod.status = 3;
				$.each(mod.waits, function(it){
					it.success(name)
				});
				mod.waits = [];
			}
		},
		//自定义包的路径地址
		url: function(names, url){
			names = names.replace(/\s/g, '');
			if(names == '') return;
			if(url.indexOf('/') != 0 && url.indexOf('http://') != 0)
					url = Cute.Config.scriptPath + url;
			var a = names.split(',');
			$.each(a, function(it){
				Cute.Module._customUrls[it] = url;
			});
		},
		_getModule: function(name){
			var p = this._mods[name];
			if(!p){
				p = {
					name: name,
					status: 0,	//0为初始化状态，为获取任何实体及依赖信息
					waits: []		//关注池
				};
				if(this._customUrls[name]){
					p.url = this._customUrls[name];
				} else {
					p.url = name;
					if(name.indexOf('/') != 0 && name.indexOf('http://') !=0 ){
						p.url = Cute.Config.scriptPath + name;
					}
				}
				this._mods[name] = p;
			}
			return p;
		},
		_loadModule: function(mod){
			if(mod.status != 0) return;
			mod.status = 1;
			var url = mod.url;
			if(!this._urlLoads[url]){
				this._urlLoads[url] = 1;
				this._include(url);
			} else if(this._urlLoads[url] == 2){
				mod.status = 3;
				$.each(mod.waits, function(it){
					it.success(mod.name);
				});
				mod.waits = [];
			}
		},
		_options: function(options){
			if(options && options.done){
				Como.Hook._resourceReady = true;
				if(Como.Hook._loaded && !Como.Hook._included){
						Como.Hook.run('onincludehooks');
				}
			}
		},
		_include: function(url, callback) {
			var afile = url.toLowerCase().replace(/^\s|\s$/g, "").match(/([^\/\\]+)\.(\w+)$/);
			if (!afile) return false;
			switch (afile[2]) {
				case "css":
					var el = $('<link />',{
						rel: "stylesheet",
						id: afile[1],
						type: "text/css",
						href: 'data:text/css,' + escape(url)
					}).appendTo("head");
					if($.isFunction(callback)){
						if ($.browser.msie) {
							el.load(function() {
								callback();
							});
						} else {
							callback();
						}
					}
					break;
				case "js":;;p
					$.ajax({
						global: false,
						ifModified: true,
						dataType: "script",
						url: escape(url),
						success: callback || $.noop
					});
					break;
				default:
					break;
			}
		}
	},
	Wait: Cute.register({
		initialize: function(requires, callback, options){
			this.names = [];
			for(var i = 0, il = requires.length; i < il; i++){
				this.names.push(requires[i].name);
			}
			this.callback = callback;
			this.options = options;
			return this;
		},
		success: function(name){
			Como.Array.remove(this.names, name);
			if(this.names.length == 0){
				window.setTimeout(this.callback, 0);
				Como.Module._options(this.options);
				return true;
			}
			return false;
		}
	}),
	log: function(msg, src) {
		if (this.Config.debug) {
			if (src) {
				msg = src + ': ' + msg;
			}
			if (window['console'] !== undefined && console.log) {
				console.log(msg);
			}
		}
		return this;
	},
	namespace: function() {
		var l = arguments.length, o = null, i, j, p;
		for (i = 0; i < l; ++i) {
			p = ('' + arguments[i]).split('.');
			o = this;
			for (j = (win[p[0]] === o) ? 1 : 0; j < p.length; ++j) {
				o = o[p[j]] = o[p[j]] || {};
			}
		}
		return o;
	},
	error: function(msg) {
		if (this.Config.debug) {
			throw msg;
		}
	},
	register: function(module) {
		var _this = this;
		var _func = function(module) {
			if (module && _this[module]) {
				for (var i in _this[module]) {
					this[i] = _this[module][i];
				}
			}
			return this;
		};
		return new _func(module);
	},
	common: {
		confirm: function(msg, url) {
			if (arguments.length == 1) {
				url = msg;
				msg = '真的要删除吗？';
			}
			Cute.dialog.confirm(msg, {
				yes: function() {
					if (url.constructor == String) {
						location.href = url;
					} else if (url.constructor == Function) {
						url();
					}
				}
			});
			return false;
		}
	},
	copy: function(txt) {
		if (window.clipboardData) {
			window.clipboardData.clearData();
			window.clipboardData.setData("Text", txt);
		} else if (navigator.userAgent.indexOf("Opera") != -1) {
			window.location = txt;
		} else if (window.netscape) {
			try {
				netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			} catch (e) {
				alert("您的firefox安全限制限制您进行剪贴板操作，请打开'about:config'将signed.applets.codebase_principal_support'设置为true'之后重试");
				return false;
			}
			var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
			if (!clip) return false;
			var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
			if (!trans) return false;
			trans.addDataFlavor('text/unicode');
			var str = new Object();
			var len = new Object();
			var str = Components.classes['@mozilla.org/supports-string;1'].createInstance(Components.interfaces.nsISupportsString);
			var copytext = txt;
			str.data = copytext;
			trans.setTransferData("text/unicode", str, copytext.length * 2);
			var clipid = Components.interfaces.nsIClipboard;
			if (!clip) return false;
			clip.setData(trans, null, clipid.kGlobalClipboard);
		} else {
			return false;
		}
		return true;
	},
	params: {	//参数操作
		init: function() {
			this.list = {};
			$.each(location.search.match(/(?:[\?|\&])[^\=]+=[^\&|#|$]*/gi) || [], function(n, item) {
				var _item = item.substring(1);
				var _key = _item.split("=", 1)[0];
				var _value = _item.replace(eval("/" + _key + "=/i"), "");
				this.list[_key.toLowerCase()] = Cute.tools.string.decode(_value);
			} .bind(this));
			return this;
		},
		get: function(item) {
			if (typeof this.list == "undefined") this.init();
			var _item = this.list[item.toLowerCase()];
			return _item ? _item : "";
		},
		set: function(options) {
			if (typeof this.list == "undefined") this.init();
			this.list = $.extend(true, this.list, options || {});
			return this;
		},
		serialize: function() {
			if (typeof this.list == "undefined") this.init();
			return $.param(this.list, true);
		},
		hashString: function(item) {
			if (!item) return location.hash.substring(1);
			var sValue = location.hash.match(new RegExp("[\#\&]" + item + "=([^\&]*)(\&?)", "i"));
			sValue = sValue ? sValue[1] : "";
			return sValue == location.hash.substring(1) ? "" : sValue == undefined ? location.hash.substring(1) : Cute.tools.string.decode(sValue);
		}
	},
	string: {
		encode: encodeURIComponent,
		decode: decodeURIComponent,
		escapeHTML: function(str) {
			return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
		},
		unescapeHTML: function(str) {
			return str.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&');
		},
		substitute: function(str, o, regexp) {
			if(!str || str.constructor != String) return str;
			return str.replace(regexp || /\\?\{([^{}]+)\}/g, function(match, name) {
				if (match.charAt(0) === '\\') return match.slice(1);
				return (o[name] !== undefined) ? o[name] : "";
			});
		},
		format: function() {
			var  str = arguments[0], args = [];
			for (var i = 1, il = arguments.length; i < il; i++) {
				args.push(arguments[i]);
			}
			return str.replace(/\{(\d+)\}/g, function(m, i){
				return args[i];
			});
		},
		htmlEncode: function(html) {
			return html.replace(/&/g, '&amp').replace(/\"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
		},
		length: function(str) {
			return str.replace(/[^\x00-\xff]/g,"**").length;
		},
		// 取左边多少字符，中文两个字节
		left: function(str, n){
			var s = str.replace(/\*/g, " ").replace(/[^\x00-\xff]/g, "**");
			s = s.slice(0, n).replace(/\*\*/g, " ").replace(/\*/g, "").length;
			return str.slice(0, s);
		},
		// 取右边多少字符，中文两个字节
		right: function(str, n){
			var len = str.length;
			var s = str.replace(/\*/g, " ").replace(/[^\x00-\xff]/g, "**");
			s = s.slice(s.length - n, s.length).replace(/\*\*/g, " ").replace(/\*/g, "").length;
			return str.slice(len - s, len);
		},
		on16: function(str){
			var a = [], i = 0;
			for (; i < str.length ;) a[i] = ("00" + str.charCodeAt(i ++).toString(16)).slice(-4);
			return "\\u" + a.join("\\u");
		},
		un16: function(str){
			return unescape(str.replace(/\\/g, "%"));
		}
	},
	date: {
		format: function(date, f) {
			var o = {
				"M+": date.getMonth() + 1,
				"d+": date.getDate(),
				"h+": date.getHours(),
				"m+": date.getMinutes(),
				"s+": date.getSeconds(),
				"q+": Math.floor((date.getMonth() + 3) / 3),
				"S": date.getMilliseconds()
			};
			if (/(y+)/.test(f))
				f = f.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
			for (var k in o)
				if (new RegExp("(" + k + ")").test(f))
					f = f.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
			return f;
		}
	},
	cookie: {
		get: function(name){
			var v = document.cookie.match('(?:^|;)\\s*' + name + '=([^;]*)');
			return v ? decodeURIComponent(v[1]) : null;
		},
		set: function(name, value ,expires, path, domain){
			var str = name + "=" + encodeURIComponent(value);
			if (expires != null || expires != '') {
				if (expires == 0) {expires = 100*365*24*60;}
				var exp = new Date();
				exp.setTime(exp.getTime() + expires*60*1000);
				str += "; expires=" + exp.toGMTString();
			}
			if (path) {str += "; path=" + path;}
			if (domain) {str += "; domain=" + domain;}
			document.cookie = str;
		},
		del: function(name, path, domain){
			document.cookie = name + "=" +
				((path) ? "; path=" + path : "") +
				((domain) ? "; domain=" + domain : "") +
				"; expires=Thu, 01-Jan-70 00:00:01 GMT";
		}
	},
	tools:{
		checkAll: function(obj, elName) {
			$(obj).closest("form").find("input:checkbox[name=" + elName + "]").attr("checked", $(obj).attr("checked"));
		},
		insertSelection: function(obj, str) {
			obj.focus();
			if (typeof document.selection != "undefined") {
				document.selection.createRange().text = str;
				obj.createTextRange().duplicate().moveStart("character", -str.length);
			} else {
				var tclen = obj.value.length;
				var m = obj.selectionStart;
				obj.value = obj.value.substr(0, obj.selectionStart) + str + obj.value.substring(obj.selectionStart, tclen);
				obj.selectionStart = m + str.length;
				obj.setSelectionRange(m + str.length, m + str.length);
			}
		},
		getRangPos: function(obj) {
			var obj = $(obj)[0];
			var pos = {};
			if (typeof document.selection != "undefined") {
				var range = document.selection.createRange();
				if (obj != range.parentElement()) return
				var range_all = document.body.createTextRange();
				range_all.moveToElementText(obj);
				for (var sel_start = 0; range_all.compareEndPoints('StartToStart', range) < 0; sel_start++) {
					range_all.moveStart('character', 1);
				}
				for (var i = 0; i <= sel_start; i++) {
					if (obj.value.charAt(i) == '\n')
						sel_start++;
				}
				pos.start = sel_start;
				var range_all = document.body.createTextRange();
				range_all.moveToElementText(obj);
				for (var sel_end = 0; range_all.compareEndPoints('StartToEnd', range) < 0; sel_end++)
					range_all.moveStart('character', 1);
				for (var i = 0; i <= sel_end; i++) {
					if (obj.value.charAt(i) == '\n')
						sel_end++;
				}
				pos.end = sel_end;
			} else if (obj.selectionStart || obj.selectionStart == '0') {
				pos.start = obj.selectionStart;
				pos.end = obj.selectionEnd;
			}
			return pos;
		}
	},
	api: {	//接口调用方法
		ajax: function(type, action, data, callback, cache, async, options) {
			if (action != undefined)
				var url = Cute.SERVICEURL + "?a=" + action;
			else
				var url = location.pathname;
			$.ajax($.extend({
				url: url,
				data: data,
				async: typeof async != "undefined" ? async : true,
				type: typeof type != "undefined" ? type : "GET",
				//dataType: "text",
				ifModified: false,
				timeout: 8000,
				traditional: false,
				cache: typeof cache != "undefined" ? cache : true,
				success: callback,
				//				dataFilter: function(data) {
				//					return eval("(" + data + ")");
				//				},
				error: function() {
					if (async == false) {
						Cute.dialog.alert(Cute.LANG.syserror);
					}
					$("#dialog_loading,#dialog_mask").remove();
					return false;
				},
				beforeSend: function() {
				}
			}, options || {}));
		},
		get: function(action, data, callback, cache, async, options) {
			this.ajax("GET", action, data, callback, cache, async, options);
		},
		post: function(action, data, callback, cache, async, options) {
			this.ajax("POST", action, data, callback, cache, async, options);
		}
	},
	template: function(tplname, data, isCached) {	//模板
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
	},
	delayLoader: {
		init: function(options) {
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
						if (_this._scrollY(this, opt) && _this._scrollX(this, opt)) {
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
		},
		_scrollY: function(element, opt) {
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
		},
		_scrollX: function(element, opt) {
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
	}
};
Cute.init();
jQuery.extend({
	out: function(el, name, func, canMore) {
		var callback = function(e) {
			var src = e.target || e.srcElement;
			var isIn = false;
			while (src) {
				if (src == el) {
					isIn = true;
					break;
				}
				src = src.parentNode;
			}
			if (!isIn) {
				func.call(el, e);
				if (!canMore) {
					jQuery.event.remove(document.body, name, c);
					if (el._EVENT && el._EVENT.out && el._EVENT.out.length) {
						var arr = el._EVENT.out;
						for (var i = 0, il = arr.length; i < il; i++) {
							if (arr[i].efunc == c && arr[i].name == name) {
								arr.splice(i, 1);
								return;
							}
						}
					}
				}
			}
		}
		var c = callback.bindEvent(window);
		if (!el._EVENT) {
			el._EVENT = {
				out: []
			}
		}
		el._EVENT.out.push({
			name: name,
			func: func,
			efunc: c
		});
		jQuery.event.add(document.body, name, c);
	},
	unout: function(el, name, func) {
		if (el._EVENT && el._EVENT.out && el._EVENT.out.length) {
			var arr = el._EVENT.out;
			for (var i = 0, il = arr.length; i < il; i++) {
				if ((func == undefined || arr[i].func == func) && arr[i].name == name) {
					jQuery.event.remove(document.body, name, arr[i].efunc);
					arr.splice(i, 1);
					return;
				}
			}
		}
	}
});
jQuery.fn.extend({	//jQuery 扩展
	drag: function(position, target, offset, func) {
		func = func || $.noop;
		target = jQuery(target || this);
		position = position || window;
		offset = offset || { x: 0, y: 0 };
		return this.css("cursor", "move").bind("mousedown.drag", function(e) {
			e.preventDefault();
			e.stopPropagation();
			//if (e.which && (e.which != 1)) return;
			//if (e.originalEvent.mouseHandled) { return; }
			if (document.defaultView) {
				var _top = document.defaultView.getComputedStyle(target[0], null).getPropertyValue("top");
				var _left = document.defaultView.getComputedStyle(target[0], null).getPropertyValue("left");
			} else {
				if (target[0].currentStyle) {
					var _top = target.css("top");
					var _left = target.css("left");
				}
			}
			var width = target.outerWidth(),
				height = target.outerHeight();
			if (position === window) {
				position = $.browser.msie6 ? document.body : window;
				var mainW = jQuery(position).width() - offset.x,
					mainH = jQuery(position).height() - offset.y;
			} else {
				var mainW = jQuery(position).outerWidth() - offset.x,
					mainH = jQuery(position).outerHeight() - offset.y;
			}
			target.posX = e.pageX - parseInt(_left);
			target.posY = e.pageY - parseInt(_top);
			if (target[0].setCapture) target[0].setCapture();
			else if (window.captureEvents) window.captureEvents(Event.MOUSEMOVE | Event.MOUSEUP);
			jQuery(document).unbind(".drag").bind("mousemove.drag", function(e) {
				var posX = e.pageX - target.posX,
					posY = e.pageY - target.posY;
				target.css({
					left: function() {
						if (posX > 0 && posX + width < mainW)
							return posX;
						else if (posX <= 0)
							return offset.x;
						else if (posX + width >= mainW)
							return mainW - width
					},
					top: function() {
						if (posY > 0 && posY + height < mainH)
							return posY;
						else if (posY <= 0)
							return offset.y;
						else if (posY + height >= mainH)
							return mainH - height;
					}
				});
				func(_top, _left, width, height, posY, posX);
			}).bind("mouseup.drag", function(e) {
				if (target[0].releaseCapture) target[0].releaseCapture();
				else if (window.releaseEvents) window.releaseEvents(Event.MOUSEMOVE | Event.MOUSEUP);
				jQuery(this).unbind(".drag");
			});
		});
	},
	out: function(name, listener, canMore) {
		return this.each(function() {
			jQuery.out(this, name, listener, canMore);
		});
	},
	unout: function(name, listener) {
		return this.each(function() {
			jQuery.unout(this, name, listener);
		});
	},
	scrolling: function(options, func) {
		var defaults = { target: 1, timer: 1000, offset: 0 };
		func = func || $.noop;
		var o = jQuery.extend(defaults, options || {});
		this.each(function(i) {
			switch (o.target) {
				case 1:
					var targetTop = jQuery(this).offset().top + o.offset;
					jQuery("html,body").animate({ scrollTop: targetTop }, o.timer, func.bind(this));
					break;
				case 2:
					var targetLeft = jQuery(this).offset().left + o.offset;
					jQuery("html,body").animate({ scrollLeft: targetLeft }, o.timer, func.bind(this));
					break;
			}
			return false;
		});
		return this;
	},
	isUndefined: function(o){
		return o === undefined;
	},
	isBoolean: function(o) {
		return typeof o === 'boolean';
	},
	isString: function(o) {
		return typeof o === 'string';
	},
	isNumber: function(o) {
		return typeof o === 'number' && isFinite(o);
	}
});


$.browser.msie6 = $.browser.msie && /MSIE 6\.0/i.test(window.navigator.userAgent) && !/MSIE 7\.0/i.test(window.navigator.userAgent);
//函数扩展
Function.prototype.bind = function() {	//绑定域
	var method = this,
	_this = arguments[0],
	args = [];
	for (var i = 1,
	il = arguments.length; i < il; i++) {
		args.push(arguments[i]);
	}
	return function() {
		var thisArgs = args.concat();
		for (var i = 0,
		il = arguments.length; i < il; i++) {
			thisArgs.push(arguments[i]);
		}
		return method.apply(_this, thisArgs);
	};
};
Function.prototype.bindEvent = function() {	//绑定Event
	var method = this,
	_this = arguments[0],
	args = [];
	for (var i = 1,
	il = arguments.length; i < il; i++) {
		args.push(arguments[i]);
	}
	return function(e) {
		var thisArgs = args.concat();
		thisArgs.unshift(e || window.event);
		return method.apply(_this, thisArgs);
	};
};

//数组扩展
Array.prototype.include = function(value) {		//是否包含
	if(this.constructor != Array) return;
	return this.index(value) != -1;
};
Array.prototype.index = function(value) {	//查找值索引
	for (var i = 0,
	il = this.length; i < il; i++) {
		if (this[i] == value) return i;
	}
	return -1;
};
Array.prototype.unique = function() {	//删除重复
	for (var i = 0; i < this.length; i++) {
		var it = this[i];
		for (var j = this.length - 1; j > i; j--) {
			if (this[j] == it) this.splice(j, 1);
		}
	}
	return this;
};
Array.prototype.remove = function(o) {	//删除元素
	if (typeof o == 'number' && !this.include(o)) {
		this.splice(o, 1);
	} else {
		var i = this.index(o);
		this.splice(i, 1);
	}
	return this;
};
Array.prototype.random = function(){	//乱序
	return arr.sort(function(a,b){
		return Math.random()>.5 ? -1 : 1;
	});
};
//字符串扩展
String.prototype.trim = function() {		//去除前后空格
	return $.trim(this);
};
