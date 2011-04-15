/// <reference path="jquery-1.3.2-vsdoc2.js" />
//基础框架
(function() {
	var $ = window.$ = jQuery;
	var Cute = window.Cute = {
		config: {
			SITEURL: "",
			RESOURCEURL: "",
			SCRIPTPATH: "",
			SERVICEURL: "",
			DEBUG: true
		},
		init: function() {
			// 可以通过在 url 上加 ?cute-DEBUG 来开启 DEBUG 模式
			if (window.location.search && window.location.search.indexOf('cute-DEBUG') !== -1) {
				this.config.DEBUG = true;
			}
			return this;
		},
		log: function(msg, src) {
			if (this.config.DEBUG) {
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
			if (this.config.DEBUG) {
				throw msg;
			}
		},
		common: {
			confirm: function(msg, url) {
				if (arguments.length == 1) {
					url = msg;
					msg = "真的要删除吗？";
				}
				new Cute.ui.dialog().confirm(msg, {
					yes: function() {
						if (url.constructor == String) {
							location.href = url;
							return false;
						} else if (url.constructor == Function) {
							url();
							return false;
						}
						return true;
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
				var obj = $(obj)[0];
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
			selectText: function(obj, start, end) {
				var obj = $(obj)[0];
				obj.focus();
				if (typeof document.selection != "undefined") {
					var range = obj.createTextRange();
					range.collapse(true);
					range.moveEnd("character", end);
					range.moveStart("character", start);
					range.select();
				} else {
					obj.setSelectionRange(start, end);  //设光标 
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
			},
			scrolling: function(obj, options, func) {
				var defaults = { target: 1, timer: 1000, offset: 0 };
				func = func || $.noop;
				var o = $.extend(defaults, options || {});
				$(obj).each(function(i) {
					switch (o.target) {
						case 1:
							var targetTop = $(obj).offset().top + o.offset;
							$("html,body").animate({ scrollTop: targetTop }, o.timer, Cute.Function.bind(func, obj));
							break;
						case 2:
							var targetLeft = $(obj).offset().left + o.offset;
							$("html,body").animate({ scrollLeft: targetLeft }, o.timer, Cute.Function.bind(func, obj));
							break;
					}
					return false;
				});
				return this;
			}
		},
		ui: {},
		plugin: {}
	};

	Cute.params = {	//参数操作
		init: function() {
			this.list = {};
			$.each(location.search.match(/(?:[\?|\&])[^\=]+=[^\&|#|$]*/gi) || [], function(n, item) {
				var _item = item.substring(1);
				var _key = _item.split("=", 1)[0];
				var _value = _item.replace(eval("/" + _key + "=/i"), "");
				this.list[_key.toLowerCase()] = Cute.String.urldecode(_value);
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
			$.extend(true, this.list, options || {});
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
			return sValue == location.hash.substring(1) ? "" : sValue == undefined ? location.hash.substring(1) : Cute.String.urldecode(sValue);
		}
	};

	Cute.api = {	//接口调用方法
		ajax: function(type, action, data, callback, cache, async, options) {
			if (typeof data == 'function' && typeof callback == 'undefined') {
				callback = data;
				data = undefined;
			}
			var url = "";
			if (action != undefined) {
				if (action.indexOf("/") != -1 || action.indexOf(".") != -1) {
					url = action;
				} else {
					url = Cute.config.SERVICEURL + "?a=" + action;
				}
			} else {
				url = location.pathname;
			}
			return $.ajax($.extend({
				url: url,
				data: data,
				async: typeof async != "undefined" ? async : true,
				type: typeof type != "undefined" ? type : "GET",
				//dataType: "text",
				ifModified: false,
				timeout: 8000,
				traditional: false,
				cache: typeof cache != "undefined" ? cache : false,
				success: callback,
				//				dataFilter: function(data) {
				//					return eval("(" + data + ")");
				//				},
				error: function() {
					if (async == false) {
						new Cute.ui.dialog().alert(Cute.LANG.syserror);
					}
					$("#dialog_loading").remove();
					return false;
				},
				beforeSend: function() {
				}
			}, options || {}));
		},
		get: function(action, data, callback, cache, async, options) {
			return this.ajax("GET", action, data, callback, cache, async, options);
		},
		post: function(action, data, callback, cache, async, options) {
			return this.ajax("POST", action, data, callback, cache, async, options);
		}
	};

	Cute.Class = {
		/*
		*创建一个命名空间
		*/
		namespace: function(module) {
			var space = module.split('.');
			var s = '';
			for (var i in space) {
				if (space[i].constructor == String) {
					if (0 == s.length)
						s = space[i];
					else
						s += '.' + space[i];
					eval("if ((typeof(" + s + ")) == 'undefined') " + s + " = {};");
				}
			}
		},
		/*
		*创建一个类，并执行构造函数
		*/
		create: function() {
			var f = function() {
				this.initialize.apply(this, arguments);
			};
			for (var i = 0, il = arguments.length, it; i < il; i++) {
				it = arguments[i];
				if (it == null) continue;
				$.extend(f.prototype, it);
			}
			return f;
		},
		/*
		*继承一个类，暂不支持多重继承
		*/
		inherit: function(superC, opt) {
			function temp() { };
			temp.prototype = superC.prototype;

			var f = function() {
				this.initialize.apply(this, arguments);
			};

			f.prototype = new temp();
			$.extend(f.prototype, opt);
			f.prototype.superClass_ = superC.prototype;
			f.prototype.super_ = function() {
				this.superClass_.initialize.apply(this, arguments);
			};
			return f;
		}
	};
	Cute.Object = {
		/*
		* 对象的完全克隆
		*/
		clone: function(obj) {
			var con = obj.constructor, cloneObj = null;
			if (con == Object) {
				cloneObj = new con();
			} else if (con == Function) {
				return Cute.Function.clone(obj);
			} else cloneObj = new con(obj.valueOf());

			for (var it in obj) {
				if (cloneObj[it] != obj[it]) {
					if (typeof (obj[it]) != 'object') {
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
		timeout: function(fun, time) {
			return setTimeout(fun, time * 1000);
		},
		interval: function(fun, time) {
			return setInterval(fun, time * 1000);
		},
		//域绑定，可传参
		bind: function(fun) {
			var _this = arguments[1], args = [];
			for (var i = 2, il = arguments.length; i < il; i++) {
				args.push(arguments[i]);
			}
			return function() {
				var thisArgs = args.concat();
				for (var i = 0, il = arguments.length; i < il; i++) {
					thisArgs.push(arguments[i]);
				}
				return fun.apply(_this || this, thisArgs);
			}
		},
		// 域绑定，可传事件
		bindEvent: function(fun) {
			var _this = arguments[1], args = [];
			for (var i = 2, il = arguments.length; i < il; i++) {
				args.push(arguments[i]);
			}
			return function(e) {
				var thisArgs = args.concat();
				thisArgs.unshift(e || window.event);
				return fun.apply(_this || this, thisArgs);
			}
		},
		clone: function(fun) {
			var clone = function() {
				return fun.apply(this, arguments);
			};
			clone.prototype = fun.prototype;
			for (prototype in fun) {
				if (fun.hasOwnProperty(prototype) && prototype != 'prototype') {
					clone[prototype] = fun[prototype];
				}
			}
			return clone;
		}
	};
	Cute.Cookie = {
		get: function(name) {
			var v = document.cookie.match('(?:^|;)\\s*' + name + '=([^;]*)');
			return v ? decodeURIComponent(v[1]) : null;
		},
		set: function(name, value, expires, path, domain) {
			var str = name + "=" + encodeURIComponent(value);
			if (expires != null || expires != '') {
				if (expires == 0) { expires = 100 * 365 * 24 * 60; }
				var exp = new Date();
				exp.setTime(exp.getTime() + expires * 60 * 1000);
				str += "; expires=" + exp.toGMTString();
			}
			if (path) { str += "; path=" + path; }
			if (domain) { str += "; domain=" + domain; }
			document.cookie = str;
		},
		del: function(name, path, domain) {
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
		urldecode: decodeURIComponent,
		urlencode: encodeURIComponent,
		//格式化HTML
		escapeHTML: function(str) {
			return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
		},
		//反格式化HTML
		unescapeHTML: function(str) {
			return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
		},
		// 取得字符的字节长度，汉字认为是两个字符
		byteLength: function(str) {
			return str.replace(/[^\x00-\xff]/g, "**").length;
		},
		// 除去最后一个字符
		delLast: function(str) {
			return str.substring(0, str.length - 1);
		},
		// String to Int
		toInt: function(str) {
			return Math.floor(str);
		},
		// 取左边多少字符，中文两个字节
		left: function(str, n) {
			var s = str.replace(/\*/g, " ").replace(/[^\x00-\xff]/g, "**");
			s = s.slice(0, n).replace(/\*\*/g, " ").replace(/\*/g, "").length;
			return str.slice(0, s);
		},
		// 取右边多少字符，中文两个字节
		right: function(str, n) {
			var len = str.length;
			var s = str.replace(/\*/g, " ").replace(/[^\x00-\xff]/g, "**");
			s = s.slice(s.length - n, s.length).replace(/\*\*/g, " ").replace(/\*/g, "").length;
			return str.slice(len - s, len);
		},
		// 除去HTML标签
		removeHTML: function(str) {
			return str.replace(/<\/?[^>]+>/gi, '');
		},
		//"<div>{0}</div>{1}".format(txt0,txt1);
		format: function() {
			var str = arguments[0], args = [];
			for (var i = 1, il = arguments.length; i < il; i++) {
				args.push(arguments[i]);
			}
			return str.replace(/\{(\d+)\}/g, function(m, i) {
				return args[i];
			});
		},
		// toString(16)
		on16: function(str) {
			var a = [], i = 0;
			for (; i < str.length; ) a[i] = ("00" + str.charCodeAt(i++).toString(16)).slice(-4);
			return "\\u" + a.join("\\u");
		},
		// unString(16)
		un16: function(str) {
			return unescape(str.replace(/\\/g, "%"));
		}
	};
	Cute.Array = {
		//	判断是否包含某个值或者对象
		include: function(arr, value) {
			if (arr.constructor != Array) return false;
			return this.index(arr, value) != -1;
		},
		//	判断一个对象在数组中的位置
		index: function(arr, value) {
			for (var i = 0, il = arr.length; i < il; i++) {
				if (arr[i] == value) return i;
			}
			return -1;
		},
		//	过滤重复项
		unique: function(arr) {
			if (arr.length && typeof (arr[0]) == 'object') {
				var len = arr.length;
				for (var i = 0, il = len; i < il; i++) {
					var it = arr[i];
					for (var j = len - 1; j > i; j--) {
						if (arr[j] == it) arr.splice(j, 1);
					}
				}
				return arr;
			} else {
				var result = [], hash = {};
				for (var i = 0, key; (key = arr[i]) != null; i++) {
					if (!hash[key]) {
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
				var i = Cute.Array.index(arr, o);
				if (i >= 0) arr.splice(i, 1);
			}
			return arr;
		},
		//取随机一项
		random: function(arr) {
			var i = Math.round(Math.random() * (arr.length - 1));
			return arr[i];
		},
		//乱序
		shuffle: function(arr) {
			return arr.sort(function(a, b) {
				return Math.random() > .5 ? -1 : 1;
			});
		}
	};
	Cute.Date = {
		// new Date().format('yyyy年MM月dd日');
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
	};
	Cute.Event = {
		out: function(el, name, func, many) {
			var callback = function(e) {
				var src = e.target || e.srcElement,
				isIn = false;
				while (src) {
					if (src == el) {
						isIn = true;
						break;
					}
					src = src.parentNode;
				}
				if (!isIn) {
					func.call(el, e);
					if (!many) {
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
			jQuery.event.add(document, name, c);
		},
		unout: function(el, name, fun) {
			if (el._EVENT && el._EVENT.out && el._EVENT.out.length) {
				var arr = el._EVENT.out;
				for (var i = 0; i < arr.length; i++) {
					if (name == arr[i].name && fun == arr[i].fun) {
						$.event.remove(document.body, name, arr[i].efun);
						arr.splice(i, 1);
						return;
					}
				}
			}
		}
	};
	$.extend(Cute, {
		isUndefined: function(o) {
			return o === undefined;
		},
		isBoolean: function(o) {
			return typeof o === 'boolean';
		},
		isString: function(o) {
			return typeof o === 'string';
		},
		isNumber: function(o) {
			return !isNaN(Number(o)) && isFinite(o);
		},
		include: function(url, callback) {
			var afile = url.toLowerCase().replace(/^\s|\s$/g, "").match(/([^\/\\]+)\.(\w+)$/);
			if (!afile) return false;
			switch (afile[2]) {
				case "css":
					var el = $('<link rel="stylesheet" id="' + afile[1] + '" type="text/css" />').appendTo("head").attr("href", url);
					if ($.browser.msie) {
						el.load(function() {
							if (typeof callback == 'function') callback();
						});
					} else {
						var i = 0;
						var checkInterval = setInterval(function() {
							if ($("head>link").index(el) != -1) {
								if (i < 10) clearInterval(checkInterval)
								if (typeof callback == 'function') callback();
								i++;
							}
						}, 200);
					}
					break;
				case "js":
					$.ajax({
						global: false,
						cache: true,
						ifModified: true,
						dataType: "script",
						url: url,
						success: callback
					});
					break;
				default:
					break;
			}
		}
	}, true);


	Cute.Widget = {
		drag: function(obj, position, target, offset, func) {
			func = func || $.noop;
			target = $(target || obj);
			position = position || window;
			offset = offset || { x: 0, y: 0 };
			return obj.css("cursor", "move").bind("mousedown.drag", function(e) {
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
					var mainW = $(position).width() - offset.x,
					mainH = $(position).height() - offset.y;
				} else {
					var mainW = $(position).outerWidth() - offset.x,
					mainH = $(position).outerHeight() - offset.y;
				}
				target.posX = e.pageX - parseInt(_left);
				target.posY = e.pageY - parseInt(_top);
				if (target[0].setCapture) target[0].setCapture();
				else if (window.captureEvents) window.captureEvents(Event.MOUSEMOVE | Event.MOUSEUP);
				$(document).unbind(".drag").bind("mousemove.drag", function(e) {
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
					$(this).unbind(".drag");
				});
			});
		}
	};
	var ext = function(target, src, is) {
		if (!target) target = {};
		for (var it in src) {
			if (is) {
				target[it] = Cute.Function.bind(function() {
					var c = arguments[0], f = arguments[1];
					var args = [this];
					for (var i = 2, il = arguments.length; i < il; i++) {
						args.push(arguments[i]);
					}
					return c[f].apply(c, args);
				}, null, src, it);
			} else {
				target[it] = src[it];
			}
		}
	};
	if (window.require) {
		Cute.define = window.define;
		Cute.require = window.require;
		Cute.ready = window.require.ready;
	}
	ext(window.Class = {}, Cute.Class, false);
	ext(Function.prototype, Cute.Function, true);
	ext(String.prototype, Cute.String, true);
	ext(Array.prototype, Cute.Array, true);
	ext(Date.prototype, Cute.Date, true);
	//让IE支持VML
	if ($.browser.msie) {
		$("html").attr("xmlns:v", "");
		document.createStyleSheet().addRule("v\\:*","behavior:url(#default#VML);");
	}
})();


jQuery.fn.extend({	//jQuery 扩展
	out: function(name, listener, many) {
		return this.each(function() {
			Cute.Event.out(this, name, listener, many);
		});
	},
	unout: function(name, listener) {
		return this.each(function() {
			Cute.Event.unout(this, name, listener);
		});
	},
	drag: function(position, target, offset, func) {
		Cute.Widget.drag(this,position, target, offset, func)
	},
	scrolling: function(options, func) {
		Cute.common.scrolling(this,options, func);
	}
});

jQuery.browser.msie6 = $.browser.msie && /MSIE 6\.0/i.test(window.navigator.userAgent) && !/MSIE 7\.0/i.test(window.navigator.userAgent) && !/MSIE 8\.0/i.test(window.navigator.userAgent);
