//表单验证
var jQuery_formValidator_initConfig;
define([], function() {
	Cute.include(Cute.config.RESOURCEURL + "c/public/validatorAuto.css");
	$.formValidator = {
		//各种校验方式支持的控件类型
		sustainType: function(id, setting) {
			var elem = $("#" + id).get(0);
			var srcTag = elem.tagName;
			var stype = elem.type;
			switch (setting.validatetype) {
				case "InitValidator":
					return true;
				case "InputValidator":
					if (srcTag == "INPUT" || srcTag == "TEXTAREA" || srcTag == "SELECT") {
						return true;
					} else {
						return false;
					}
				case "CompareValidator":
					if (srcTag == "INPUT" || srcTag == "TEXTAREA") {
						if (stype == "checkbox" || stype == "radio") {
							return false;
						} else {
							return true;
						}
					}
					return false;
				case "AjaxValidator":
					if (stype == "text" || stype == "textarea" || stype == "file" || stype == "password" || stype == "select-one") {
						return true;
					} else {
						return false;
					}
				case "RegexValidator":
					if (srcTag == "INPUT" || srcTag == "TEXTAREA") {
						if (stype == "checkbox" || stype == "radio") {
							return false;
						} else {
							return true;
						}
					}
					return false;
				case "FunctionValidator":
					return true;
			}
		},
		settings: {
			debug: false,
			validatorgroup: "1",
			alertmessage: false,
			validobjectids: "",
			forcevalid: false,
			onsuccess: function() { return true; },
			onerror: function() { },
			submitonce: false,
			formid: "",
			autotip: true,
			tidymode: false,
			errorfocus: true,
			wideword: true
		},
		initConfig: function(controlOptions) {
			var _settings = $.extend({}, this.settings, controlOptions || {});
			//如果是精简模式，发生错误的时候，第一个错误的控件就不获得焦点
			if (_settings.tidymode) { _settings.errorfocus = false };
			if (_settings.formid != "") {
				$(_settings.formid).submit(function() {
					return $.formValidator.pageIsValid(_settings.validatorgroup);
				});
			}
			if (jQuery_formValidator_initConfig == null) { jQuery_formValidator_initConfig = new Array(); }
			jQuery_formValidator_initConfig.push(_settings);
		},

		//如果validator对象对应的element对象的validator属性追加要进行的校验。
		appendValid: function(id, setting) {
			//如果是各种校验不支持的类型，就不追加到。返回-1表示没有追加成功
			if (!$.formValidator.sustainType(id, setting)) return -1;
			var srcjo = $("#" + id).get(0);
			//重新初始化
			if (setting.validatetype == "InitValidator" || srcjo.settings == undefined) { srcjo.settings = new Array(); }
			var len = srcjo.settings.push(setting);
			srcjo.settings[len - 1].index = len - 1;
			return len - 1;
		},

		//如果validator对象对应的element对象的validator属性追加要进行的校验。
		getInitConfig: function(validatorgroup) {
			if (jQuery_formValidator_initConfig != null) {
				for (i = 0; i < jQuery_formValidator_initConfig.length; i++) {
					if (validatorgroup == jQuery_formValidator_initConfig[i].validatorgroup) {
						return jQuery_formValidator_initConfig[i];
					}
				}
			}
			return null;
		},

		//触发每个控件上的各种校验
		triggerValidate: function(returnObj) {
			switch (returnObj.setting.validatetype) {
				case "InputValidator":
					$.formValidator.inputValid(returnObj);
					break;
				case "CompareValidator":
					$.formValidator.compareValid(returnObj);
					break;
				case "AjaxValidator":
					$.formValidator.ajaxValid(returnObj);
					break;
				case "RegexValidator":
					$.formValidator.regexValid(returnObj);
					break;
				case "FunctionValidator":
					$.formValidator.functionValid(returnObj);
					break;
			}
		},

		//设置显示信息
		setTipState: function(elem, showclass, showmsg) {
			var setting0 = elem.settings[0];
			var initConfig = $.formValidator.getInitConfig(setting0.validatorgroup);
			var tip = $("#" + setting0.tipid);
			if (showmsg == null || showmsg == "") {
				tip.removeClass();
				if (setting0.onshow) $.formValidator.setTipState(elem, "onShow", setting0.onshow);
			}
			else {
				if (initConfig.tidymode) {
					//显示和保存提示信息
					$("#fv_content").html(showmsg);
					elem.Tooltip = showmsg;
					if (showclass != "onError") { tip.removeClass("open"); }
				} else {
					tip.addClass("open");
				}
				tip.removeClass("onShow onFocus onError onCorrect onSuccess onLoad");
				tip.addClass(showclass);
				tip.html('<span class="validateTipIco"></span>' + showmsg);
			}
		},

		resetTipState: function(validatorgroup) {
			var initConfig = $.formValidator.getInitConfig(validatorgroup);
			$(initConfig.validobjectids).each(function() {
				$.formValidator.setTipState(this, "onShow", this.settings[0].onshow);
			});
		},

		//设置错误的显示信息
		setFailState: function(tipid, showmsg) {
			var tip = $("#" + tipid);
			tip.removeClass("onShow onFocus onError onCorrect onSuccess onLoad");
			tip.addClass("onError");
			tip.html(showmsg);
		},

		//根据单个对象,正确:正确提示,错误:错误提示
		showMessage: function(returnObj) {
			var id = returnObj.id;
			var elem = $("#" + id).get(0);
			var isvalid = returnObj.isvalid;
			var setting = returnObj.setting; //正确:setting[0],错误:对应的setting[i]
			var showmsg = "", showclass = "";
			var settings = $("#" + id).get(0).settings;
			var intiConfig = $.formValidator.getInitConfig(settings[0].validatorgroup);
			if (!isvalid) {
				showclass = "onError";
				if (setting.validatetype == "AjaxValidator") {
					if (setting.lastValid == "") {
						showclass = "onLoad";
						showmsg = setting.onwait;
					}
					else {
						showmsg = setting.onerror;
					}
				}
				else {
					showmsg = (returnObj.errormsg == "" ? setting.onerror : returnObj.errormsg);

				}
				if (intiConfig.alertmessage) {
					var elem = $("#" + id).get(0);
					if (elem.validoldvalue != $(elem).val()) { alert(showmsg); }
				}
				else {
					$.formValidator.setTipState(elem, showclass, showmsg);
				}
			}
			else {
				//验证成功后,如果没有设置成功提示信息,则给出默认提示,否则给出自定义提示;允许为空,值为空的提示
				showmsg = $.formValidator.isEmpty(id) ? setting.onempty : setting.oncorrect;
				$.formValidator.setTipState(elem, "onCorrect", showmsg);
			}
			return showmsg;
		},

		showAjaxMessage: function(returnObj) {
			var setting = returnObj.setting;
			var elem = $("#" + returnObj.id).get(0);
			elem.validoldvalue = $(elem)[0].defaultValue || "";
			if (elem.validoldvalue != $(elem).val()) {
				$.formValidator.ajaxValid(returnObj);
			}
			else {
				//				if (setting.isvalid != undefined && !setting.isvalid) {
				//					elem.lastshowclass = "onError";
				//					elem.lastshowmsg = setting.onerror;
				//				}
				$.formValidator.setTipState(elem, elem.lastshowclass, elem.lastshowmsg);
			}
		},

		//获取指定字符串的长度
		getLength: function(id) {
			var srcjo = $("#" + id);
			var elem = srcjo.get(0);
			sType = elem.type;
			var len = 0;
			switch (sType) {
				case "text":
				case "hidden":
				case "password":
				case "textarea":
				case "file":
					var val = srcjo.val();
					var initConfig = $.formValidator.getInitConfig(elem.settings[0].validatorgroup);
					if (initConfig.wideword) {
						for (var i = 0; i < val.length; i++) {
							if (val.charCodeAt(i) >= 0x4e00 && val.charCodeAt(i) <= 0x9fa5) {
								len += 2;
							} else {
								len++;
							}
						}
					}
					else {
						len = val.length;
					}
					break;
				case "checkbox":
				case "radio":
					len = $("input[type='" + sType + "'][name='" + srcjo.attr("name") + "']:checked").length;
					break;
				case "select-one":
					len = elem.options ? elem.options.selectedIndex : -1;
					break;
				case "select-multiple":
					len = $("select[name=" + elem.name + "] option[selected]").length;
					break;
			}
			return len;
		},

		//结合empty这个属性，判断仅仅是否为空的校验情况。
		isEmpty: function(id) {
			var _setting = $("#" + id).get(0).settings[0];
			var _empty = _setting.empty;
			var _onlyvisible = _setting.onlyvisible;
			_empty = _empty.constructor == Function ? _empty() : _empty;
			_onlyvisible = _onlyvisible.constructor == Function ? _onlyvisible() : _onlyvisible;
			_onlyvisible = $("#" + id).is(":hidden") && _onlyvisible;
			if ((_empty && $.formValidator.getLength(id) == 0) || _onlyvisible) {
				return true;
			} else {
				return false;
			}
		},

		//对外调用：判断单个表单元素是否验证通过，不带回调函数
		isOneValid: function(id) {
			return $.formValidator.oneIsValid(id, 1).isvalid;
		},

		//验证单个是否验证通过,正确返回settings[0],错误返回对应的settings[i]
		oneIsValid: function(id, index) {
			var returnObj = new Object();
			returnObj.id = id;
			returnObj.ajax = -1;
			returnObj.errormsg = "";       //自定义错误信息
			var elem = $("#" + id).get(0);
			var settings = elem.settings;
			var settingslen = settings.length;
			//只有一个formValidator的时候不检验
			if (settingslen == 1) { settings[0].bind = false; }
			if (!settings[0].bind) { return null; }
			for (var i = 0; i < settingslen; i++) {
				if (i == 0) {
					if ($.formValidator.isEmpty(id)) {
						returnObj.isvalid = true;
						returnObj.setting = settings[0];
						break;
					}
					continue;
				}
				returnObj.setting = settings[i];
				if (settings[i].validatetype != "AjaxValidator") {
					$.formValidator.triggerValidate(returnObj);
				} else {
					returnObj.ajax = i;
				}
				if (!settings[i].isvalid) {
					returnObj.isvalid = false;
					returnObj.setting = settings[i];
					break;
				} else {
					returnObj.isvalid = true;
					returnObj.setting = settings[0];
					if (settings[i].validatetype == "AjaxValidator") break;
				}
			}
			return returnObj;
		},

		//验证所有需要验证的对象，并返回是否验证成功。
		pageIsValid: function(validatorgroup) {
			if (validatorgroup == null || validatorgroup == undefined) { validatorgroup = "1" };
			var isvalid = true;
			var thefirstid = "", thefirsterrmsg;
			var returnObj, setting;
			var error_tip = "^";

			var initConfig = $.formValidator.getInitConfig(validatorgroup);
			var jqObjs = $(initConfig.validobjectids);
			jqObjs.each(function(i, elem) {
				if (elem.settings[0].bind) {
					returnObj = $.formValidator.oneIsValid(elem.id, 1);
					if (returnObj && returnObj.setting.validatetype != "AjaxValidator") {
						var tipid = elem.settings[0].tipid;
						//校验失败,获取第一个发生错误的信息和ID
						if (!returnObj.isvalid) {
							isvalid = false;
							if (thefirstid == "") {
								thefirstid = returnObj.id;
								thefirsterrmsg = (returnObj.errormsg == "" ? returnObj.setting.onerror : returnObj.errormsg)
							}
							if (thefirstid != "" && initConfig.errorfocus) { $("#" + thefirstid).trigger("focus.form", true); thefirstid == ""; }
						}
						//为了解决使用同个TIP提示问题:后面的成功或失败都不覆盖前面的失败
						if (!initConfig.alertmessage) {
							if (error_tip.indexOf("^" + tipid + "^") == -1) {
								if (!returnObj.isvalid) {
									error_tip = error_tip + tipid + "^";
								}
								$.formValidator.showMessage(returnObj);
							}
						}
					}
				}
			});
			//成功或失败后，进行回调函数的处理，以及成功后的灰掉提交按钮的功能
			if (isvalid) {
				isvalid = initConfig.onsuccess();
				if (initConfig.submitonce) { $("input[type='submit']").attr("disabled", true); }
			}
			else {
				var obj = $("#" + thefirstid).get(0);
				initConfig.onerror(thefirsterrmsg, obj);
			}
			return !initConfig.debug && isvalid;
		},

		//ajax校验
		ajaxValid: function(returnObj) {
			var id = returnObj.id;
			var srcjo = $("#" + id);
			var elem = srcjo.get(0);
			var settings = elem.settings;
			var setting = settings[returnObj.ajax];
			var ls_url = setting.url;
			if (srcjo.size() == 0 && settings[0].empty) {
				returnObj.setting = settings[0];
				returnObj.isvalid = true;
				$.formValidator.showMessage(returnObj);
				setting.isvalid = true;
				return;
			}
			if (setting.addidvalue) {
				var parm = "clientid=" + id + "&" + id + "=" + encodeURIComponent(srcjo.val());
				ls_url = ls_url + (ls_url.indexOf("?") > 0 ? ("&" + parm) : ("?" + parm));
			}
			$.ajax(
			{
				mode: "abort",
				type: setting.type,
				url: ls_url,
				cache: setting.cache,
				data: setting.data,
				async: setting.async,
				dataType: setting.datatype,
				success: function(data) {
					if (setting.success(data)) {
						$.formValidator.setTipState(elem, "onCorrect", settings[0].oncorrect);
						setting.isvalid = true;
					}
					else {
						$.formValidator.setTipState(elem, "onError", $.isFunction(setting.onerror) ? setting.onerror(data) : setting.onerror);
						setting.isvalid = false;
					}
				},
				complete: function() {
					if (setting.buttons && setting.buttons.length > 0) { setting.buttons.attr({ "disabled": false }) };
					setting.complete;
				},
				beforeSend: function(xhr) {
					//再服务器没有返回数据之前，先回调提交按钮
					if (setting.buttons && setting.buttons.length > 0) { setting.buttons.attr({ "disabled": true }) };
					var isvalid = setting.beforesend(xhr);
					if (isvalid) {
						setting.isvalid = false; 	//如果前面ajax请求成功了，再次请求之前先当作错误处理
						$.formValidator.setTipState(elem, "onLoad", settings[returnObj.ajax].onwait);
					}
					setting.lastValid = "-1";
					return isvalid;
				},
				error: function() {
					$.formValidator.setTipState(elem, "onError", $.isFunction(setting.onerror) ? setting.onerror() : setting.onerror);
					setting.isvalid = false;
					setting.error();
				},
				processData: setting.processdata
			});
		},

		//对正则表达式进行校验（目前只针对input和textarea）
		regexValid: function(returnObj) {
			var id = returnObj.id;
			var setting = returnObj.setting;
			var srcTag = $("#" + id).get(0).tagName;
			var elem = $("#" + id).get(0);
			//如果有输入正则表达式，就进行表达式校验
			if (elem.settings[0].empty && elem.value == "") {
				setting.isvalid = true;
			}
			else {
				var regexpress = setting.regexp;
				if (setting.datatype == "enum") { regexpress = eval("regexEnum." + regexpress); }
				if (regexpress == undefined || regexpress == "") {
					setting.isvalid = false;
					return;
				}
				setting.isvalid = (new RegExp(regexpress, setting.param)).test($("#" + id).val());
			}
		},

		//函数校验。返回true/false表示校验是否成功;返回字符串表示错误信息，校验失败;如果没有返回值表示处理函数，校验成功
		functionValid: function(returnObj) {
			var id = returnObj.id;
			var setting = returnObj.setting;
			var srcjo = $("#" + id);
			var lb_ret = setting.fun(srcjo.val(), srcjo.get(0));
			if (lb_ret != undefined) {
				if (typeof lb_ret == "string") {
					setting.isvalid = false;
					returnObj.errormsg = lb_ret;
				} else {
					setting.isvalid = lb_ret;
				}
			}
		},

		//对input和select类型控件进行校验
		inputValid: function(returnObj) {
			var id = returnObj.id;
			var setting = returnObj.setting;
			var srcjo = $("#" + id);
			var elem = srcjo.get(0);
			var val = srcjo.val();
			var sType = elem.type;
			var len = $.formValidator.getLength(id);
			var empty = setting.empty, emptyerror = false;
			switch (sType) {
				case "text":
				case "hidden":
				case "password":
				case "textarea":
				case "file":
					if (setting.type == "size") {
						empty = setting.empty;
						if (!empty.leftempty) {
							emptyerror = (val.replace(/^[ \s]+/, '').length != val.length);
						}
						if (!emptyerror && !empty.rightempty) {
							emptyerror = (val.replace(/[ \s]+$/, '').length != val.length);
						}
						if (emptyerror && empty.emptyerror) { returnObj.errormsg = empty.emptyerror }
					}
				case "checkbox":
				case "select-one":
				case "select-multiple":
				case "radio":
					var lb_go_on = false;
					if (sType == "select-one" || sType == "select-multiple") { setting.type = "size"; }
					var type = setting.type;
					if (type == "size") {		//获得输入的字符长度，并进行校验
						if (!emptyerror) { lb_go_on = true }
						if (lb_go_on) { val = len; }
					}
					else if (type == "date" || type == "datetime") {
						var isok = false;
						if (type == "date") { lb_go_on = isDate(val) };
						if (type == "datetime") { lb_go_on = isDate(val) };
						if (lb_go_on) { val = new Date(val); setting.min = new Date(setting.min); setting.max = new Date(setting.max); };
					} else {
						stype = (typeof setting.min);
						if (stype == "number") {
							val = (new Number(val)).valueOf();
							if (!isNaN(val)) { lb_go_on = true; }
						}
						if (stype == "string") { lb_go_on = true; }
					}
					setting.isvalid = false;
					if (lb_go_on) {
						if (val < setting.min || val > setting.max) {
							if (val < setting.min && setting.onerrormin) {
								returnObj.errormsg = setting.onerrormin;
							}
							if (val > setting.min && setting.onerrormax) {
								returnObj.errormsg = setting.onerrormax;
							}
						}
						else {
							setting.isvalid = true;
						}
					}
					break;
			}
		},

		compareValid: function(returnObj) {
			var id = returnObj.id;
			var setting = returnObj.setting;
			var srcjo = $("#" + id);
			var desjo = $("#" + setting.desid);
			var ls_datatype = setting.datatype;
			setting.isvalid = false;
			curvalue = srcjo.val();
			ls_data = desjo.val();
			if (ls_datatype == "number") {
				if (!isNaN(curvalue) && !isNaN(ls_data)) {
					curvalue = parseFloat(curvalue);
					ls_data = parseFloat(ls_data);
				}
				else {
					return;
				}
			}
			if (ls_datatype == "date" || ls_datatype == "datetime") {
				var isok = false;
				if (ls_datatype == "date") { isok = (isDate(curvalue) && isDate(ls_data)) };
				if (ls_datatype == "datetime") { isok = (isDateTime(curvalue) && isDateTime(ls_data)) };
				if (isok) {
					curvalue = new Date(curvalue);
					ls_data = new Date(ls_data)
				}
				else {
					return;
				}
			}

			switch (setting.operateor) {
				case "=":
					if (curvalue == ls_data) { setting.isvalid = true; }
					break;
				case "!=":
					if (curvalue != ls_data) { setting.isvalid = true; }
					break;
				case ">":
					if (curvalue > ls_data) { setting.isvalid = true; }
					break;
				case ">=":
					if (curvalue >= ls_data) { setting.isvalid = true; }
					break;
				case "<":
					if (curvalue < ls_data) { setting.isvalid = true; }
					break;
				case "<=":
					if (curvalue <= ls_data) { setting.isvalid = true; }
					break;
			}
		},

		localTooltip: function(e) {
			e = e || window.event;
			var mouseX = e.pageX || (e.clientX ? e.clientX + document.body.scrollLeft : 0);
			var mouseY = e.pageY || (e.clientY ? e.clientY + document.body.scrollTop : 0);
			$("#fvtt").css({ "top": (mouseY + 2) + "px", "left": (mouseX - 40) + "px" });
		}
	};
	//每个校验控件必须初始化的
	$.fn.formValidator = function(cs) {
		var setting = {
			validatorgroup: "1",
			empty: false,
			submitonce: false,
			automodify: true,
			onshow: "",
			onfocus: "",
			oncorrect: " ",
			onempty: "",
			defaultvalue: null,
			bind: true,
			validatetype: "InitValidator",
			tipcss: {},
			triggerevent: "blur.form",
			forcevalid: false,
			onlyvisible: false
		};

		//获取该校验组的全局配置信息
		cs = cs || {};
		if (cs.validatorgroup == undefined) { cs.validatorgroup = "1" };
		var initConfig = $.formValidator.getInitConfig(cs.validatorgroup);

		//如果为精简模式，tipcss要重新设置初始值
		if (initConfig.tidymode) { setting.tipcss = { "display": "none"} };

		//先合并整个配置(深度拷贝)
		$.extend(true, setting, cs);

		return this.each(function(e) {
			var jqobj = $(this);
			var setting_temp = {};
			$.extend(true, setting_temp, setting);
			var tip = setting_temp.tipid ? setting_temp.tipid : this.id + "Tip";
			//自动形成TIP
			if (initConfig.autotip) {
				//获取层的ID、相对定位控件的ID和坐标
				if ($("body [id=" + tip + "]").length == 0) {
					aftertip = setting_temp.relativeid ? setting_temp.relativeid : this.id;
					var obj = $("#" + aftertip).position();
					var y = obj.top;
					var x = $("#" + aftertip).width() + obj.left;
					if ($("#" + aftertip).attr("type") == "radio" || $("#" + aftertip).attr("type") == "checkbox") {
						$("input:radio[name=" + aftertip + "]:last,input:checkbox[name=" + aftertip + "]:last,select[name=" + aftertip + "]:last").parent().after($('<div class="formValidateTip"><div id="' + tip + '"><span class="validateTipIco"></span></div></div>').css(setting_temp.tipcss));
					} else {
						$("#" + aftertip).closest("td,div").append($('<div class="formValidateTip"><div id="' + tip + '"><span class="validateTipIco"></span></div></div>').css(setting_temp.tipcss));
					}
				}
				if (initConfig.tidymode) { jqobj.showTooltips() };
			}

			//每个控件都要保存这个配置信息
			setting.tipid = tip;
			$.formValidator.appendValid(this.id, setting);

			//保存控件ID
			var validobjectids = initConfig.validobjectids;
			if (validobjectids.indexOf("#" + this.id + " ") == -1) {
				initConfig.validobjectids = (validobjectids == "" ? "#" + this.id : validobjectids + ",#" + this.id);
			}

			//初始化显示信息
			if (!initConfig.alertmessage) {
				$.formValidator.setTipState(this, "onShow", setting.onshow);
			}

			var srcTag = this.tagName.toLowerCase();
			var stype = this.type;
			var defaultval = setting.defaultvalue;
			//处理默认值
			if (defaultval) {
				jqobj.val(defaultval);
			}

			if (srcTag == "input" || srcTag == "textarea") {
				//注册获得焦点的事件。改变提示对象的文字和样式，保存原值
				jqobj.bind("focus.form", function(event, noFocusTip) {
					if (!initConfig.alertmessage) {
						//保存原来的状态
						var tipjq = $("#" + tip);
						this.lastshowclass = tipjq.attr("class");
						this.lastshowmsg = tipjq.text();
						if (setting.onfocus && !noFocusTip) $.formValidator.setTipState(this, "onFocus", setting.onfocus);
					}
					if (stype == "password" || stype == "text" || stype == "textarea" || stype == "file") {
						this.validoldvalue = jqobj.val();
					}
				});
				//注册失去焦点的事件。进行校验，改变提示对象的文字和样式；出错就提示处理
				jqobj.bind(setting.triggerevent, function() {
					var settings = this.settings;
					var returnObj = $.formValidator.oneIsValid(this.id, 1);
					if (returnObj == null) { return; }
					if (returnObj.ajax >= 0) {
						$.formValidator.showAjaxMessage(returnObj);
					}
					else {
						var showmsg = $.formValidator.showMessage(returnObj);
						if (returnObj.isvalid) {
							//自动修正错误
							var auto = setting.automodify && (this.type == "text" || this.type == "textarea" || this.type == "file");
							if (auto && !initConfig.alertmessage) {
								$.formValidator.setTipState(this, "onCorrect", $.formValidator.isEmpty(this.id) ? setting.onempty : setting.oncorrect);
							}
							else {
								if (initConfig.forcevalid || setting.forcevalid) {
									alert(showmsg);
									this.trigger("focus.form");
								}
							}
						}
					}
				});
			}
			else if (srcTag == "select") {
				//获得焦点
				jqobj.bind("focus.form", function(event, noFocusTip) {
					if (!initConfig.alertmessage && !noFocusTip) {
						$.formValidator.setTipState(this, "onFocus", setting.onfocus);
					}
				});
				//失去焦点
				//jqobj.bind("blur", function() { jqobj.trigger("change") });
				//选择项目后触发
				jqobj.bind("change", function() {
					var returnObj = $.formValidator.oneIsValid(this.id, 1);
					if (returnObj == null) { return; }
					if (returnObj.ajax >= 0) {
						$.formValidator.showAjaxMessage(returnObj);
					} else {
						$.formValidator.showMessage(returnObj);
					}
				});
			}
		});
	};

	$.fn.inputValidator = function(controlOptions) {
		var settings = {
			isvalid: false,
			min: 0,
			max: 99999999999999,
			type: "size",
			onerror: "输入错误",
			validatetype: "InputValidator",
			empty: { leftempty: true, rightempty: true, leftemptyerror: null, rightemptyerror: null },
			wideword: true
		};
		controlOptions = controlOptions || {};
		$.extend(true, settings, controlOptions);
		return this.each(function() {
			$.formValidator.appendValid(this.id, settings);
		});
	};

	$.fn.compareValidator = function(controlOptions) {
		var settings = {
			isvalid: false,
			desid: "",
			operateor: "=",
			onerror: "输入错误",
			validatetype: "CompareValidator"
		};
		controlOptions = controlOptions || {};
		$.extend(true, settings, controlOptions);
		return this.each(function() {
			$.formValidator.appendValid(this.id, settings);
		});
	};

	$.fn.regexValidator = function(controlOptions) {
		var settings = {
			isvalid: false,
			regexp: "",
			param: "i",
			datatype: "string",
			onerror: "输入的格式不正确",
			validatetype: "RegexValidator"
		};
		controlOptions = controlOptions || {};
		$.extend(true, settings, controlOptions);
		return this.each(function() {
			$.formValidator.appendValid(this.id, settings);
		});
	};

	$.fn.functionValidator = function(controlOptions) {
		var settings = {
			isvalid: true,
			fun: function() { this.isvalid = true; },
			validatetype: "FunctionValidator",
			onerror: "输入错误"
		};
		controlOptions = controlOptions || {};
		$.extend(true, settings, controlOptions);
		return this.each(function() {
			$.formValidator.appendValid(this.id, settings);
		});
	};

	$.fn.ajaxValidator = function(controlOptions) {
		var settings = {
			isvalid: false,
			lastValid: "",
			type: "GET",
			url: "",
			addidvalue: true,
			datatype: "html",
			data: "",
			async: false,
			cache: false,
			beforesend: function() { return true; },
			success: function() { return true; },
			complete: function() { },
			processdata: true,
			error: function() { },
			buttons: null,
			onerror: "服务器校验没有通过",
			onwait: "正在等待服务器返回数据",
			validatetype: "AjaxValidator"
		};
		controlOptions = controlOptions || {};
		$.extend(true, settings, controlOptions);
		return this.each(function() {
			$.formValidator.appendValid(this.id, settings);
		});
	};

	$.fn.defaultPassed = function(onshow) {
		return this.each(function() {
			var settings = this.settings;
			for (var i = 1; i < settings.length; i++) {
				settings[i].isvalid = true;
				if (!$.formValidator.getInitConfig(settings[0].validatorgroup).alertmessage) {
					var ls_style = onshow ? "onShow" : "onCorrect";
					$.formValidator.setTipState(this, ls_style, settings[0].oncorrect);
				}
			}
		});
	};

	$.fn.unFormValidator = function(unbind) {
		return this.each(function() {
			this.settings[0].bind = !unbind;
			if (unbind) {
				$("#" + this.settings[0].tipid).removeClass("open");
			} else {
				$("#" + this.settings[0].tipid).addClass("open");
			}
		});
	};

	$.fn.showTooltips = function() {
		if ($("body [id=fvtt]").length == 0) {
			fvtt = $("<div id='fvtt' style='position:absolute;z-index:56002'></div>");
			$("body").append(fvtt);
			fvtt.before("<iframe src='about:blank' class='fv_iframe' scrolling='no' frameborder='0'></iframe>");
		}
		return this.each(function() {
			jqobj = $(this);
			s = $("<span class='top' id=fv_content style='display:block'></span>");
			b = $("<b class='bottom' style='display:block' />");
			this.tooltip = $("<span class='fv_tooltip' style='display:block'></span>").append(s).append(b).css({ "filter": "alpha(opacity:95)", "KHTMLOpacity": "0.95", "MozOpacity": "0.95", "opacity": "0.95" });
			//注册事件
			jqobj.mouseover(function(e) {
				$("#fvtt").append(this.tooltip);
				$("#fv_content").html(this.Tooltip);
				$.formValidator.localTooltip(e);
			});
			jqobj.mouseout(function() {
				$("#fvtt").empty();
			});
			jqobj.mousemove(function(e) {
				$("#fv_content").html(this.Tooltip);
				$.formValidator.localTooltip(e);
			});
		});
	}

	var regexEnum =
	{
		intege: "^-?[1-9]\\d*$", 				//整数
		intege1: "^[1-9]\\d*$", 				//正整数
		intege2: "^-[1-9]\\d*$", 				//负整数
		num: "^([+-]?)\\d*\\.?\\d+$", 		//数字
		num1: "^[1-9]\\d*|0$", 				//正数（正整数 + 0）
		num2: "^-[1-9]\\d*|0$", 				//负数（负整数 + 0）
		decmal: "^([+-]?)\\d*\\.\\d+$", 		//浮点数
		decmal1: "^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*$", //正浮点数
		decmal2: "^-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*)$", //负浮点数
		decmal3: "^-?([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0)$", //浮点数
		decmal4: "^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0$", //非负浮点数（正浮点数 + 0）
		decmal5: "^(-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*))|0?.0+|0$", //非正浮点数（负浮点数 + 0）

		email: "^([\\w-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([\\w-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$", //邮件
		color: "^[a-fA-F0-9]{6}$", 			//颜色
		url: "^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([!#\\w-./?%&=]*)?$", //url
		chinese: "^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$", 				//仅中文
		ascii: "^[\\x00-\\xFF]+$", 			//仅ACSII字符
		zipcode: "^\\d{6}$", 					//邮编
		mobile: "^(13|15|18)[0-9]{9}$", 			//手机
		ip4: "^(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)$", //ip地址
		notempty: "^\\S+$", 					//非空
		picture: "(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$", //图片
		rar: "(.*)\\.(rar|zip|7zip|tgz)$", 							//压缩文件
		date: "^\\d{4}(\\-|\\/|\.)\\d{1,2}\\1\\d{1,2}$", 				//日期
		qq: "^[1-9]*[1-9][0-9]*$", 			//QQ号码
		tel: "^(([0\\+]\\d{2,3}-)?(0\\d{2,3})-)?(\\d{7,8})(-(\\d{3,}))?$", //电话号码的函数(包括验证国内区号,国际区号,分机号)
		username: "^\\w+$", 					//用来用户注册。匹配由数字、26个英文字母或者下划线组成的字符串
		letter: "^[A-Za-z]+$", 				//字母
		letter_u: "^[A-Z]+$", 				//大写字母
		letter_l: "^[a-z]+$", 				//小写字母
		idcard: "^[1-9]([0-9]{14}|[0-9]{17})$"	//身份证
	};

	var aCity = { 11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林", 23: "黑龙江", 31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北", 43: "湖南", 44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏", 61: "陕西", 62: "甘肃", 63: "青海", 64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外" }

	function isCardID(sId) {
		var iSum = 0;
		var info = "";
		if (!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误";
		sId = sId.replace(/x$/i, "a");
		if (aCity[parseInt(sId.substr(0, 2))] == null) return "你的身份证地区非法";
		sBirthday = sId.substr(6, 4) + "-" + Number(sId.substr(10, 2)) + "-" + Number(sId.substr(12, 2));
		var d = new Date(sBirthday.replace(/-/g, "/"));
		if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) return "身份证上的出生日期非法";
		for (var i = 17; i >= 0; i--) iSum += (Math.pow(2, i) % 11) * parseInt(sId.charAt(17 - i), 11);
		if (iSum % 11 != 1) return "你输入的身份证号非法";
		return true; //aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女") 
	}

	//短时间，形如 (13:04:06)
	function isTime(str) {
		var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);
		if (a == null) { return false }
		if (a[1] > 24 || a[3] > 60 || a[4] > 60) {
			return false;
		}
		return true;
	}

	//短日期，形如 (2003-12-05)
	function isDate(str) {
		var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
		if (r == null) return false;
		var d = new Date(r[1], r[3] - 1, r[4]);
		return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
	}

	//长时间，形如 (2003-12-05 13:04:06)
	function isDateTime(str) {
		var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
		var r = str.match(reg);
		if (r == null) return false;
		var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
		return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);
	}
});