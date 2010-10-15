/// <reference path="jquery-1.3.2-vsdoc2.js" />
//基础框架
(function(){
var Cute = window.Cute = {
	config:{
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
	error: function(msg) {
		if (this.Config.debug) {
			throw msg;
		}
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
	}
};

Cute.Class = {
	/*
	*创建一个类，并执行构造函数
	*/
	create: function() {
		var f = function() {
			this.initialize.apply(this, arguments);
		};
		for (var i = 0, il = arguments.length, it; i<il; i++) {
			it = arguments[i];
			if (it == null) continue;
			f.prototype = jQuery.extend(f.prototype, it);
		}
		return f;
	},
	/*
	 *继承一个类，暂不支持多重继承
	 */
	inherit: function(superC, opt){
		function temp() {};
		temp.prototype = superC.prototype;

		var f = function(){
			this.initialize.apply(this, arguments);
		};

		f.prototype = new temp();
		f.prototype = jQuery.extend(f.prototype, opt);
		f.prototype.superClass_ = superC.prototype;
		f.prototype.super_ = function(){
			this.superClass_.initialize.apply(this, arguments);
		};
		return f;
	}
};
Cute.Object = {
	/*
	 * 对象的完全克隆
	 */
	 clone: function(obj){
		var con = obj.constructor, cloneObj = null;
		if(con == Object){
			cloneObj = new con();
		} else if (con == Function){
			return Cute.Function.clone(obj);
		} else cloneObj = new con(obj.valueOf());

		for(var it in obj){
			if(cloneObj[it] != obj[it]){
				if(typeof(obj[it]) != 'object'){
					cloneObj[it] = obj[it];
				} else {
					cloneObj[it] = arguments.callee(obj[it])
				}
			}
		}
		cloneObj.toString = obj.toString;
		cloneObj.valueOf = obj.valueOf;
		return cloneObj;
	 }
};
Cute.Function = {
	timeout: function (fun, time) {
		return setTimeout(fun, time);
	},
	interval: function (fun, time) {
		return setInterval(fun, time);
	},
	//域绑定，可传参
	bind: function(fun) {
		var  _this = arguments[1], args = [];
		for (var i = 2, il = arguments.length; i < il; i++) {
			args.push(arguments[i]);
		}
		return function(){
			var thisArgs =  args.concat();
			for (var i=0, il = arguments.length; i < il; i++) {
				thisArgs.push(arguments[i]);
			}
			return fun.apply(_this || this, thisArgs);
		}
	},
	// 域绑定，可传事件
	bindEvent: function(fun) {
		var  _this = arguments[1], args = [];
		for (var i = 2, il = arguments.length; i < il; i++) {
			args.push(arguments[i]);
		}
		return function(e){
			var thisArgs = args.concat();
			thisArgs.unshift(e || window.event);
			return fun.apply(_this || this, thisArgs);
		}
	},
	clone: function(fun){
		var clone = function(){
			return fun.apply(this, arguments);	
		};
		clone.prototype = fun.prototype;
		for(prototype in fun){
			if(fun.hasOwnProperty(prototype) && prototype != 'prototype'){
				clone[prototype] = fun[prototype];
			}
		}
		return clone;
	}
};
Cute.Cookie = {
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
};
Cute.String = {
	//去除空格
	trim: function(str) {
		return str.replace(/^\s+|\s+$/g, '');
	},
	//格式化HTML
	escapeHTML: function(str) {
		return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
	},
	//反格式化HTML
	unescapeHTML: function(str) {
		return str.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&');
	},
	// 取得字符的字节长度，汉字认为是两个字符
	byteLength: function(str) {
  		return str.replace(/[^\x00-\xff]/g,"**").length;
	},
	// 除去最后一个字符
	delLast: function(str){
		return str.substring(0, str.length - 1);
	},
	// String to Int
	toInt: function(str) {
		return Math.floor(str);
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
    // 除去HTML标签
    removeHTML: function(str){
        return str.replace(/<\/?[^>]+>/gi, '');
    },
    //"<div>{0}</div>{1}".format(txt0,txt1);
    format: function(){
        var  str = arguments[0], args = [];
		for (var i = 1, il = arguments.length; i < il; i++) {
			args.push(arguments[i]);
		}
        return str.replace(/\{(\d+)\}/g, function(m, i){
            return args[i];
        });
    },
	// toString(16)
	on16: function(str){
		var a = [], i = 0;
        for (; i < str.length ;) a[i] = ("00" + str.charCodeAt(i ++).toString(16)).slice(-4);
        return "\\u" + a.join("\\u");
	},
	// unString(16)
	un16: function(str){
		return unescape(str.replace(/\\/g, "%"));
	}
};
Cute.Array = {
	//	判断是否包含某个值或者对象
	include: function(arr, value) {
		return this.index(arr, value) != -1;
	},
	//	判断一个对象在数组中的位置
	index: function(arr, value) {
		for (var i=0, il = arr.length; i < il; i++) {
			if (arr[i] == value) return i;
		}
		return -1;
	},
	//	过滤重复项
	unique: function(arr) {
		if(arr.length && typeof (arr[0]) == 'object'){
			var len = arr.length;
			for (var i=0, il = len; i < il; i++) {
				var it = arr[i];
				for (var j = len - 1; j>i; j--) {
					if (arr[j] == it) arr.splice(j, 1);
				}
			}
			return arr;
		} else {
			var result = [], hash = {};
			for(var i = 0, key; (key = arr[i]) != null; i++){
				if(!hash[key]){
					result.push(key);
					hash[key] = true;
				}
			}
			return result;
		}
	},
	//移去某一项
	remove: function(arr, o) {
		if (typeof o == 'number' && !Cute.Array.include(arr, o)) {
			arr.splice(o, 1);
		} else {
			var i=Cute.Array.index(arr, o);
			arr.splice(i, 1);
		}
		return arr;
	},
	//取随机一项
	random: function(arr){
		var i = Math.round(Math.random() * (arr.length-1));
		return arr[i];
	},
	//乱序
	shuffle: function(arr){	
		return arr.sort(function(a,b){
			return Math.random()>.5 ? -1 : 1;
		});
	}
};
Cute.Date = {
	// new Date().format('yyyy年MM月dd日');
	format: function(date, f){
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
};
Cute.Event = {
    out: function(el, name, fun, one){
        one = one || false;
        if(!el._Event){
			el._Event = {
				out: []
			};
		}
		var callback = function(e){
			var ele = e.target || e.srcElement;
			if(!ele) return;
			var tag = ele[0];
			var temp = false;
			while(tag){
				if(tag == el){
					temp = true;
					break;
				}
				tag = tag.parentNode;
			}
			if(!temp){
				fun(e);
				if(one){
					Cute.Event.unout(el, name, fun);
				}
			};
		};
		var c = Cute.Function.bindEvent(callback, window);
        el._Event.out.push({name: name, fun: fun, efun: c});
		jQuery.event.add(document, name, arr[i].efun);
    },
    unout: function(el, name, fun){
    	if(el._Event && el._Event.out && el._Event.out.length){
    		var arr = el._Event.out;
    		for(var i = 0; i < arr.length ; i ++){
    			if(name == arr[i].name && fun == arr[i].fun){
    				jQuery.event.remove(document.body, name, arr[i].efun);
    				arr.splice(i, 1);
					return;
    			}
    		}
    	}
    }
};
Cute.Pack = {
	_packs: {},
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
		var nameArr = names.split(','), pack, loads=[], requires = [];
		for(var i = 0, il = nameArr.length; i< il; i++){
			pack = this._getPack(nameArr[i]);
			if(pack.status != 3){
				if(pack.status == 0) loads.push(pack);
				requires.push(pack);
			}
		}
		if(requires.length == 0){
			window.setTimeout(callback, 0);
			this._options(options);
			return;
		}
		var wait = new this.Wait(requires, callback, options);
		for(var i = 0, il = requires.length; i < il; i++){
			requires[i].waits.push(wait);
		}
		for(var i = 0, il = loads.length; i < il; i++){
			this._loadPack(loads[i]);
		}
	},

	reg: function(name, content, requires){
		var pack = this._getPack(name);
		if(pack.status == 3) return;
		if(requires && typeof requires == 'string'){
			pack.status = 2;
			this.include(requires, Cute.Function.bind(this.reg, this, name, content));
		} else {
			if(content) content();
			pack.status = 3;
			jQuery.each(pack.waits, function(it){
				it.success(name)
			});
			pack.waits = [];
		}
	},
	//自定义包的路径地址
	url: function(names, url){
		names = names.replace(/\s/g, '');
		if(names == '') return;
		if(url.indexOf('/') != 0 && url.indexOf('http://') != 0)
				url = Cute._path + url;
		var a = names.split(',');
		Cute.Array.each(a, function(it){
			Cute.Pack._customUrls[it] = url;
		});
	},

	_getPack: function(name){
		var p = this._packs[name];
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
					p.url = Cute._path + name;
				}
			}
			this._packs[name] = p;
		}
		return p;
	},

	_loadPack: function(pack){
		if(pack.status != 0) return;
		pack.status = 1;
		var url = pack.url;
		if(!this._urlLoads[url]){
			this._urlLoads[url] = 1;
			if(/.css$/.test(url))
				this._p_loadCSS(url);
			else if(/.js$/.test(url))
				this._p_loadJS(url);
		} else if(this._urlLoads[url] == 2){
			pack.status = 3;
			jQuery.each(pack.waits, function(it){
				it.success(pack.name);
			});
			pack.waits = [];
		}
	},
	_p_loadCSS: function(url){
		var css = document.createElement('link');
		css.setAttribute('type','text/css');
		css.setAttribute('rel','stylesheet');
		css.setAttribute('href',url);
		$('head').append(css);
		var onload = Cute.Function.bind(function(){
			this._urlLoads[url] = 2;
			for(var it in this._packs){
				var pack = this._packs[it];
				if(pack.url == url){
					pack.status = 3;
					jQuery.each(pack.waits, function(it){
						it.success(pack.name);
					});
					pack.waits = [];
				}
			}
		}, this);
		if(jQuery.browser.msie){
			css.onreadystatechange = function(){
				if(this.readyState=='loaded'||this.readyState=='complete'){
					onload();
				}
			}
		} else {
			onload();
		}
	},

	_p_loadJS: function(url){
		jQuery.getScript(url);
	},

	_options: function(options){
		if(options && options.done){
			Cute.Hook._resourceReady = true;
			if(Cute.Hook._loaded && !Cute.Hook._included){
					Cute.Hook.run('onincludehooks');
			}
		}
	},

	Wait: Cute.Class.create({
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
			Cute.Array.remove(this.names, name);
			if(this.names.length == 0){
				window.setTimeout(this.callback, 0);
				Cute.Pack._options(this.options);
				return true;
			}
			return false;
		}
	})
};
Cute.Hook = {
	_init: function(){
		if(document.addEventListener){
			if(jQuery.browser.safari){
				var timeout = setInterval(Cute.Function.bind(function(){
					if(/loaded|complete/.test(document.readyState)){
						this._onloadHook();
						clearTimeout(timeout);
					}
				}, this), 3);
			} else {
				document.addEventListener('DOMContentLoaded', Cute.Function.bind(function(){
					this._onloadHook();
				}, this), true);
			}
		} else {
			var src = 'javascript: void(0)';
			if(window.location.protocol == 'https:'){
				src = '//:';
			}
			document.write('<script onreadystatechange="if (this.readyState==\'complete\') {this.parentNode.removeChild(this);Cute.Hook._onloadHook();}" defer="defer" ' + 'src="' + src + '"><\/script\>');
		}
		window.onload = Cute.Function.bind(function(){
			this._onloadHook();
			if(this._resourceReady){
				this._included = true;
				this.run('onincludehooks');
			}
		}, this);
		window.onbeforeunload = Cute.Function.bind(function(){
	        return this.run('onbeforeunloadhooks');
		}, this);
		window.onunload = Cute.Function.bind(function(){
			this.run('onunloadhooks');
		}, this);
	},

	_loaded: false,
	_resourceReady: false,
	_included: false,

	_onloadHook: function(){
		this.run('onloadhooks');
		this._loaded = true;
	},

	run: function(hooks){
		var isbeforeunload = hooks == 'onbeforeunloadhooks';
		var warn = null;
		do{
			var _this = Cute.Hook;
			var h = _this[hooks];
			if(!isbeforeunload){
				_this[hooks] = null;
			}
			if(!h){
				break;
			}
			for(var i = 0; i < h.length; i++){
				if(isbeforeunload){
					warn = warn || h[i]();
				} else {
					h[i]();
				}
			}
			if(isbeforeunload){
				break;
			}
		} while(this[hooks]);
		if(isbeforeunload && warn){
			return warn;
		}
	},

	add: function(hooks, handler){
		(this[hooks] ? this[hooks] : (this[hooks] = [])).push(handler);
	},

	remove: function(hooks){
		this[hooks] = [];
	}
};

Cute = jQuery.extend(Cute,{
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
	onloadHandler: function(handler){
		Cute.Hook._loaded ? handler() : Cute.Hook.add('onloadhooks', handler);
	},
	onincludeHandler: function(handler){
		(Cute.Hook._loaded && Cute.Hook._resourceReady) ? handler() : Cute.Hook.add('onincludehooks', handler);
	},
	onunloadHandler: function(handler){
		Cute.Hook.add('onunloadhooks', handler);
	},
	onbeforeunloadHandler: function(handler){
		Cute.Hook.add('onbeforeunloadhooks', handler);
	},
	wait: function(element, e, callback){
		var fun;
		if(typeof callback == 'string'){
			fun = Cute.Function.bind(function(str, el, e){
				if(str.indexOf('(') > 0) eval('('+ str +')');
				else eval('('+ str +')')(el, e);
			}, this, callback, element, e);
		} else {
			fun = Cute.Function.bind(callback, this, element, e);
		}
		if(Cute.Hook._loaded){
			fun();
		} else {
			Cute.onincludeHandler(function(){
				var type = (e || event).type;
				if(element.tagName.toLowerCase() == 'a'){
					var original_event = window.event;
					window.event = e;
					var ret_value = element.onclick.call(element, e);
					window.event = original_event;
					if (ret_value !== false && element.href) {
	                    window.location.href = element.href;
	                }
				} else {
					element[type]();
				}
			});
		}
		return false;
	}
},true);

Cute.Hook._init();

var ext = function(target, src, is){
	if(!target) target = {};
	for(var it in src){
		if(is){
			target[it] = Cute.Function.bind(function(){
				var c = arguments[0], f = arguments[1];
				var args = [this];
				for (var i=2, il = arguments.length; i < il; i++) {
					args.push(arguments[i]);
				}
				return c[f].apply(c, args);
			}, null, src, it);
		} else {
			target[it] = src[it];
		}
	}
};
ext(window.Class = {}, Cute.Class, false);
ext(Function.prototype, Cute.Function, true);
ext(String.prototype, Cute.String, true);
ext(Array.prototype, Cute.Array, true);
ext(Date.prototype, Cute.Date, true);
})();
Cute.init();


jQuery.fn.extend({	//jQuery 扩展
	drag: function(position, target, offset, func) {
		func = func || jQuery.noop;
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
				position = jQuery.browser.msie6 ? document.body : window;
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
			Cute.Event.out(this, name, listener, canMore);
		});
	},
	unout: function(name, listener) {
		return this.each(function() {
			Cute.Event.unout(this, name, listener);
		});
	},
	scrolling: function(options, func) {
		var defaults = { target: 1, timer: 1000, offset: 0 };
		func = func || jQuery.noop;
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
	}
});

jQuery.browser.msie6 = $.browser.msie && /MSIE 6\.0/i.test(window.navigator.userAgent) && !/MSIE 7\.0/i.test(window.navigator.userAgent);