//模态框
Cute.Pack.reg("ui/dialog.js",function(){
	Cute.ui.dialog = Cute.Class.create({
		initialize: function(options) {
			this.opt = $.extend({
				title: "",
				content: "",
				className: "",
				foot: "",
				width: 400,
				height: "",
				pos: false,
				mask: false,
				blur: false,
				close: null,
				maximize: false,
				minimize: false,
				open: null,
				drag: true,
				buttons: [],
				config: null,
				parentEl: null,
				func: $.noop
			},
			options || {});
			this.buttons = [];
			this._config = $.extend({}, this.config);
			this._init();
			return this;
		},
		config: {
			title: "div.title",
			head: "div.d_header",
			body: "div.d_body",
			foot: "div.d_footer",
			content: "div.d_content",
			button: "div.d_footer .button",
			closeEl: "a.btn_close",
			frame: "iframe.Iframe_Content",
			dialogBox: "div.dialog",
			mainButtonClass: "submit",
			subButtonsClass: "cancel",
			buttonClass: "button",
			loaddingHtml: "<div class='load-page'></div>"
		},
		_getEls: function() {
			this._els = {
				title: $(this._config.title, this.pannel),
				head: $(this._config.head, this.pannel),
				body: $(this._config.body, this.pannel),
				foot: $(this._config.foot, this.pannel),
				content: $(this._config.content, this.pannel),
				closeEl: $(this._config.closeEl, this.pannel),
				dialogBox: $(this._config.dialogBox, this.pannel)
			}
		},
		_init: function() {
			$("#dialog_loading").remove();
			this.pannel = this.pannel || $('<div />').appendTo(this.opt.parentEl || document.body);
			if (this.opt.mask) {
				this.mask = this.mask || $('<div class="Iframe_HideSelect" id="dialog_mask" />').appendTo(document.body).hide();
				if (this.opt.blur) {
					this.pannel.out("click", this.close.bind(this), false);
				}
			}
			var _html = [];
			_html.push('<div class="dialog ');
			_html.push(this.opt.className);
			_html.push('" style="width:');
			_html.push(this.opt.width);
			_html.push('px;"><div class="d_layout"><span class="d_tl"><span class="d_tr"><span class="d_br"><span class="d_bl"></span></span></span></span></div><div class="d_main">');
			if (typeof this.opt.title != null) {
				_html.push('<div class="d_header" style="display:none"><div class="d_header_tl"> </div><div class="d_header_tr"></div><h4 class="title">');
				_html.push(this.opt.title);
				_html.push('</h4>');
				_html.push('<div class="options">');
				if (this.opt.minimize) _html.push('<a href="javascript:void(0)" class="icon btn_minimize" title="最小化"></a>');
				if (this.opt.maximize) _html.push('<a href="javascript:void(0)" class="icon btn_maximize" title="最大化"></a>');
				if (this.opt.close) _html.push('<a href="javascript:void(0)" class="icon btn_close" title="关闭"></a>');
				_html.push('</div></div>');
			}
			_html.push('<div class="d_body" style="height:')
			_html.push(this.opt.height);
			_html.push('px;"><div class="d_content">');
			_html.push(this.opt.content);
			_html.push('</div></div>');
			_html.push('<div class="d_footer">');
			_html.push(this.opt.foot);
			_html.push('</div>');
			_html.push('</div></div>');
			this.pannel.hide().html(_html.join(""));
			this.body = $(this._config.body, this.pannel).length > 0 || this.pannel;
			this._getEls();
			this.setButtons(this.opt.buttons);
			this.inUse = true;
			this._regEvent();
			if ($.browser.msie6) {
				var maskIframe = $('<iframe class="maskIframe" scrolling="no" frameborder="0" allowtransparency="true" src="/aboutblank.htm"></iframe>').prependTo(this._els.dialogBox);
			}
			if (this.opt.foot) {
				this._els.foot.show();
			}
			if (this.opt.title != null && this.opt.title) {
				this._els.head.show();
			}
		},
		resize: function(options) {
			if (options) {
				if (options.width)
					this._els.dialogBox.width(options.width);
				if (options.height)
					this._els.body.height(options.height);
			}
			if ($.browser.msie6)
				$('iframe.maskIframe').height(this._els.dialogBox.height() - 4).width(this._els.dialogBox.width() - 4);
			if (this.opt.mask && !$.browser.msie6)
				this._els.dialogBox[0].style.position = "fixed";
			return this;
		},
		_regEvent: function() {
			var _dialog = this._els.dialogBox;
			if (this._els.closeEl && this._els.closeEl.length > 0) {
				this._els.closeEl.click(this.close.bind(this));
			}
			$(document).bind('keydown', this._keyEvent.bindEvent(this));
			$(window).resize(function() {
				if (!this.windowSize) {
					this.windowSize = {
						width: $(window).width(),
						height: $(window).height()
					};
				}
				if ($.browser.msie) {	//ie resize bug
					if ($(window).width() == this.windowSize.width && $(window).height() == this.windowSize.height)
						return;
				}
				this.setPos.bind(this, this.opt.pos);
			} .bind(this));
			if (this.opt.drag) this._els.head.drag(window, _dialog, { x: 10, y: 10 });
		},
		_show: function() {
			this.pannel.show();
			this.resize();
			this.setPos(this.opt.pos);
			if (this.opt.mask) {
				this.mask.show();
			}
			if (this.opt.close && this.opt.close.time) {
				this.close(this.opt.close.time);
			}
			if (this._mainButton != undefined && this.buttons[this._mainButton] && this.buttons[this._mainButton].find('button').length > 0) {
				this.buttons[this._mainButton].find('button').focus();
			}
			if (this.opt.open && this.opt.open.callback) {
				this.opt.open.callback.bind(this)();
			}
			return this;
		},
		_close: function() {
			this.inUse = false;
			if (this.opt.close && this.opt.close.callback) {
				this.opt.close.callback.bind(this)();
			}
			if (this.opt.mask && this.mask && this.mask.length > 0) {
				this.mask.remove();
			}
			if (this.pannel && this.pannel.length > 0) {
				this.pannel.remove();
				this._clearDom();
			}
		},
		_clearDom: function() {
			this._els = null;
			this.body = null;
			this.pannel = null;
			this.buttons = null;
			this.mask = null;
			this.timer = null;
		},
		_keyEvent: function(e) {
			if (e.keyCode == 27 && this.inUse) {
				this.close();
			}
		},
		setClassName: function(name, reset) {
			reset = reset || false;
			if (reset)
				this._els.dialogBox.attr("class", name);
			else
				this._els.dialogBox.addClass(name);
			return this;
		},
		setButtons: function(_buttons) {
			if (_buttons && _buttons != [] && _buttons != {}) {
				if (_buttons.constructor == Object) {
					_buttons = [_buttons];
				}
				if (_buttons.length > 0) {
					$.each(_buttons, function(i, item) {
						if (item && item.constructor == String) {
							var _title = item;
							item = {};
							item.title = _title;
							item.classType = this._config.subButtonsClass;
							item.type = '';
						}
						if (!item.type) {
							item.type = '';
						}
						if (item && item.constructor == Object) {
							item.classType = item.type.indexOf("main") > -1 ? this._config.mainButtonClass : this._config.subButtonsClass;
							item.buttonType = item.form ? item.form : 'button';
						}
						this.setFoot($("<span class='button " + item.classType + "'><span><button type='" + item.buttonType + "' title='" + item.title + "'>" + item.title + "</button></span></span>"));
					} .bind(this));
				}
				var buttons = this.pannel.find(this._config.button);
				if (buttons.length > 0) {
					this.buttons = [];
					buttons.each(function(i, item) {
						if (_buttons[i]) {
							this.buttons.push($(item));
							if (_buttons[i].func && _buttons[i].func.constructor == Function) {
								$(item).click(_buttons[i].func.bind(this));
							}
							if (_buttons[i].close == true) {
								$(item).click(this.close.bind(this));
							}
							if (_buttons[i].focus || _buttons[i].type == 'main') {
								if (this.pannel.is(":visible")) {
									$(item).find('button').focus();
								} else {
									this._mainButton = i;
								}
							}
						}
					} .bind(this));
				}
			} else {
				this.setFoot(this.opt.foot);
				this._mainButton = undefined;
			}
			return this;
		},
		setPos: function(pos) {
			if (!this.inUse) {
				return;
			};
			var pannelBox = (this._els.dialogBox && this._els.dialogBox.length > 0) ? this._els.dialogBox : this.pannel;
			if (pos && pos.left != undefined && pos.top != undefined) {
				pannelBox.css(pos);
				this.opt.pos = pos;
			} else {
				if (this.opt.parentEl) {
					pannelBox.css({ "top": "auto", "left": "auto" });
				} else {
					var top = pannelBox.offset().top;
					var dHeight = pannelBox.height() == 0 ? 180 : pannelBox.height();
					var dWidth = pannelBox.width() == 0 ? 180 : pannelBox.width();
					var bHeight = $(window).height();
					var bWidth = $(window).width();
					var bTop = (this.opt.mask && !$.browser.msie6) ? 0 : $(document).scrollTop();
					pannelBox.css("left", (bWidth - dWidth) / 2 + "px");
					if (dHeight < bHeight - 30) {
						pannelBox.css("top", (bHeight - dHeight) / 2 - 30 + bTop + "px");
					} else {
						pannelBox.css("top", "30px");
					}
				}
			}
			return this;
		},
		setTitle: function(html) {
			if (this._els.title && this._els.title.length > 0) {
				this._els.title.html(html);
			}
			return this;
		},
		setFoot: function(html) {
			if (this._els.foot && this._els.foot.length > 0) {
				if ((html.constructor == Object && html.length == 0) || (html.constructor == String && html.trim() == "")) {
					this._els.foot.empty().hide();
					this._mainButton = null;
					return this;
				} else {
					this._els.foot.show();
				}
				if (html.constructor == Object)
					this._els.foot.append(html);
				else {
					this._els.foot.html(html);
				}
			}
			return this;
		},
		setContent: function(html) {
			if (this._els.body && this._els.body.length > 0) {
				if (html.constructor == Object)
					this._els.content.append(html);
				else
					this._els.content.html(html);
			}
			this.setPos(this.opt.pos);
			var _iframe = this._els.content.find(this.config.frame);
			if (_iframe.length > 0) {
				_iframe.css('height', this.opt.height + "px");
			}
			return this;
		},
		setHtml: function(html) {
			if (this._els.body && this._els.body.length > 0) {
				this._els.body.empty().append(html);
			}
			this.setPos(this.opt.pos);
			var _iframe = this._els.body.find(this.config.frame);
			if (_iframe.length > 0) {
				_iframe.css('height', this.opt.height + "px");
			}
			return this;
		},
		_optionsExtend: function(opt, options) {
			var _options = options;
			if (options.buttons) {
				var _temp = _options.buttons;
				delete _options.buttons;
				if (_temp.constructor == Array) {
					if (!opt.buttons) {
						opt.buttons = [];
					} else if (opt.buttons.constructor == Object) {
						opt.buttons = [opt.buttons];
					};
					for (var i = 0; i < _temp.length; i++) {
						opt.buttons[i] = $.extend(opt.buttons[i], _temp[i]);
					}
				} else if (_temp.constructor == Object) {
					if (!opt.buttons) {
						opt.buttons = {};
					};
					opt.buttons = $.extend(opt.buttons, _temp)
				}
			};
			if (options.close) {
				var _temp = _options.close;
				delete _options.close;
				if (!opt.close) {
					opt.close = {}
				};
				opt.close = $.extend(opt.close, _temp);
			};
			return $.extend(opt, _options);
		},
		show: function() {
			if (this.timer) clearTimeout(this.timer);
			if (this.opt.open && this.opt.open.time) {
				this.show.timeout(this.opt.open.time);
			} else {
				this._show();
			}
			//if (this.opt.mask) $(document).bind("DOMMouseScroll.dialog", function() { return false; });
			this.hideStatus = false;
			return this;
		},
		hide: function(time) {
			if (time && time.constructor == Number) {
				this.timer = this.hide.bind(this).timeout(time);
				return;
			}
			this.pannel.hide();
			if (this.mask) {
				this.mask.hide();
			}
			//if (this.opt.mask) $(document).unbind("DOMMouseScroll.dialog");
			this.hideStatus = true;
			return this;
		},
		toggle: function() {
			if (this.hideStatus)
				return this.show();
			else
				return this.hide();
		},
		close: function(time) {
			if (time && time.constructor == Number) {
				if (!$.browser.msie && this.opt.close.duration) {
					this.timer = function() {
						this._els.dialogBox.animate({ opacity: 0.1 }, function() {
							this.close.bind(this)();
						} .bind(this));
					} .bind(this).timeout(time);
				} else {
					this.timer = this.close.bind(this).timeout(time);
				}
				return;
			}
			//if (this.opt.mask) $(document).unbind("DOMMouseScroll.dialog");
			clearTimeout(this.timer);
			this._close();
		},
		setClose: function(num) {
			var _num = num || 2;
			setTimeout(function() {
				this.close();
			} .bind(this), _num * 1000);
		},
		setCloseOptions: function(options) {
			if (!this.opt) this.opt = {};
			this.opt.close = options
		},
		alert: function(info, options) {
			var options = options || {};
			this.opt.content = info;
			this.opt.mask = true;
			this.opt.buttons = {
				title: '确定',
				type: 'main',
				close: true,
				func: options.callback || $.noop
			};
			this.opt.title = "提示";
			this._optionsExtend(this.opt, options);
			this._init();
			this.show();
			return this;
		},
		notice: function(info, options) {
			var options = options || {};
			this.opt.content = info;
			this.opt.mask = true;
			this.opt.close = {
				duration: true,
				time: 2.2
			};
			this.opt.buttons = {
				title: '关闭',
				type: 'main',
				close: true,
				func: options.callback || $.noop
			};
			this.opt.title = "提示";
			this._optionsExtend(this.opt, options);
			this._init();
			this.show();
			return this;
		},
		confirm: function(info, options) {
			var options = options || {};
			this.opt.content = info;
			this.opt.mask = true;
			this.opt.buttons = [{
				title: '确定',
				type: 'main',
				close: true,
				func: options.yes || $.noop
			},
			{
				title: '取消',
				type: 'cancel',
				close: true,
				func: options.no || $.noop
			}
			];
			this.opt.title = "提示";
			this._optionsExtend(this.opt, options);
			this._init();
			this.show();
			return this;
		},
		loading: function(title, options) {
			var options = options || {};
			this.opt.title = title || "加载中...";
			this.opt.drag = false;
			this.opt.content = this._config.loaddingHtml;
			this.opt.close = {};
			this.opt.buttons = [];
			this._optionsExtend(this.opt, options);
			this._init();
			this.pannel.attr("id", "dialog_loading");
			this.show();
			return this;
		},
		ajax: function(title, options) {
			var options = options || {};
			if (options.action) {
				if (title) {
					this.opt.title = title;
				}
				this.opt.content = this._config.loaddingHtml;
				this.opt.mask = true;
				this.opt.close = {};
				this._optionsExtend(this.opt, options);
				Cute.api.get(options.action, options.params || {}, function(html) {
					this._init();
					this.setContent(html);
					this.show();
				} .bind(this));
			}
			return this;
		},
		layer: function(title, options) {
			var options = options || {};
			this.opt.title = title;
			this.opt.close = true;
			var olayer = $(options.content);
			options.content = "";
			this._optionsExtend(this.opt, options);
			this._init();
			if (olayer.data("tpl_dialog") == null) {
				olayer.data("tpl_dialog", olayer.contents().clone(true)).empty();
			}
			this.setHtml(olayer.data("tpl_dialog"));
			this.show();
			return this;
		},
		iframe: function(title, options) {
			if (options.url) {
				var options = options || {};
				if (title) {
					this.opt.title = title;
				}
				this.opt.close = {};
				this.opt.mask = true;
				this.opt.content = this._config.loaddingHtml;
				this.opt.buttons = options.buttons || [];
				this._optionsExtend(this.opt, options);
				this._init();
				this.show();
				$(this._config.loaddingHtml, this.dialogBox).remove();
				this.setHtml($('<iframe />', {
					"class": "Iframe_Content",
					"src": options.url,
					"css": {
						"border": "none",
						"width": "100%"
					},
					"frameborder": "0"
				}).clone());
			}
			return this;
		},
		tooltip: function(tiptype, title, options) {
			options = $.extend({
				mask: false,
				className: "tooltip",
				drag: false,
				buttons: []
			}, options || {});
			return this[tiptype](title, options);
		},
		suggest: function(info, options) {
			this.opt.title = "";
			this.opt.content = "";
			this.opt.mask = false;
			this.opt.width = 230;
			this.opt.close = null;
			this.opt.head = null;
			this.opt.drag = false;
			this.opt.className = "suggest";
			this._optionsExtend(this.opt, options || {});
			this._init();
			this.setHtml(info);
			this.show();
			var bTop = $(document).scrollTop();
			this._els.dialogBox.stop(true, true).css({
				"top": ($(window).height() - this.pannel.height()) / 4 * 3 + bTop,
				"opacity": 0.1
			}).animate({
				"opacity": 1,
				"top": this._els.dialogBox.position().top - 30
			}, 800, function() {
				this._els.dialogBox.delay(1200).animate({
					"opacity": 0.1,
					"top": this._els.dialogBox.position().top - 30
				}, 1200, function() {
					this.close();
				} .bind(this))
			} .bind(this));
			return this;
		}
	});
});