//分页控件
Cute.Pack.reg("ui/pager.js",function(){
	Cute.ui.pager = Cute.Class.create({
		initialize: function(obj, options) {
			this.element = $(obj);
			this.opt = $.extend({
				pageindex: 0,
				pagesize: 10,
				totalcount: -1,
				type: "numeric", //text
				total: false,
				skip: false,
				breakpage: 3,
				ajaxload: false
			}, options || {});
			this._init();
			return this;
		},
		_init: function() {
			var _this = this;
			if (_this.opt.pageindex < 1) _this.opt.pageindex = 1;
			if (_this.opt.totalcount > -1) {
				_this.opt.pagecount = Math.ceil(_this.opt.totalcount / _this.opt.pagesize);
				if (_this.opt.pageindex > _this.opt.pagecount) _this.opt.pageindex = _this.opt.pagecount;
			} else {
				_this.opt.pagecount = 99999;
			}
			if (_this.opt.breakpage > _this.opt.pagecount - 2) {
				_this.opt.breakpage = _this.opt.pagecount - 2;
				_ellipsis = [true, true];
			} else {
				_ellipsis = [false, false];
			}
			var _html = [];
			if (_this.opt.pagecount > 1 || _this.opt.total)
				_html.push('<div class="pager ' + (_this.opt.type == "numeric" ? "pager_numeric" : "") + '">\n');
			if (_this.opt.total) {
				_html.push('<div class="p_options">');
				_html.push('<span class="p_ptotal">' + _this.opt.pageindex + '页/' + _this.opt.pagecount + '页</span>\n');
				_html.push('<span class="p_total">共' + _this.opt.totalcount + '条</span>\n');
				_html.push('</div>');
			}
			if (_this.opt.pagecount > 1) {
				if (_this.opt.type == "text") {
					if (_this.opt.pageindex > 1) {
						if (_this.opt.pagecount < 9999) _html.push('<a class="p_start" href="' + _this._getUrl(1) + '">首页</a>\n');
						_html.push('<a class="p_prev" href="' + _this._getUrl(_this.opt.pageindex - 1) + '">上一页</a>\n');
					}
					if (_this.opt.pageindex != _this.opt.pagecount) {
						_html.push('<a class="p_next" href="' + _this._getUrl(_this.opt.pageindex + 1) + '">下一页</a>\n');
						if (_this.opt.pagecount < 9999) _html.push('<a class="p_end" href="' + _this._getUrl(_this.opt.pagecount) + '">尾页</a>\n');
					}
				}
				if (_this.opt.type == "numeric") {
					if (_this.opt.pageindex > 1) {	//第一页
						_html.push('<a class="p_prev" href="' + _this._getUrl(_this.opt.pageindex - 1) + '">上页</a>\n');
					}
					var _page = [1, _this.opt.pagecount, _this.opt.pageindex, _this.opt.pageindex - 1, _this.opt.pageindex + 1];
					_page = $.grep(_page, function(item, i) {
						return item > 0 && item <= _this.opt.pagecount;
					}).unique();
					var _count = _page.length;
					for (var i = 1; i <= _this.opt.breakpage + 2 - _count; i++) {
						_page.push(_this.opt.pageindex + (_this.opt.pageindex + i < _this.opt.pagecount ? i + 1 : -i - 1));
					}
					_page = _page.sort(function sortNumber(a, b) {
						return a - b;
					}).unique();
					var title = "";
					$.each(_page, function(i, item) {
						if (this.opt.pageindex == item) {
							_html.push('<strong>' + item + '</strong>\n');
						} else {
							if (item == 1) {
								title = "首页";
							} else if (item == _this.opt.pagecount) {
								title = "尾页";
							} else {
								title = "第" + item + "页";
							}
							if (_ellipsis[1] == false && this.opt.pageindex <= this.opt.pagecount - this.opt.breakpage && this.opt.pagecount == item) {
								_html.push('<span>...</span>\n');
								_ellipsis[1] = true;
							}
							_html.push('<a class="p_start" href="' + this._getUrl(item) + '" title="' + title + '">' + item + '</a>\n');
							if (_ellipsis[0] == false && this.opt.pageindex > this.opt.breakpage) {
								_html.push('<span>...</span>\n');
								_ellipsis[0] = true;
							}
						}
					} .bind(_this));
					if (_this.opt.pageindex < _this.opt.pagecount) {
						_html.push('<a class="p_next" href="' + _this._getUrl(_this.opt.pageindex + 1) + '">下页</a>\n');
					}
				}
				if (_this.opt.skip) {
					_html.push('<div class="p_skip">跳转到:');
					_html.push('<input type="text" class="p_text" maxlength="8" onclick="this.select()" size="3" name="page" value="' + _this.opt.pageindex + '" />');
					_html.push('<button class="p_btn" onclick="location.href=\'' + _this._getUrl() + '\'">GO</button>');
					_html.push('</div>');
				}
			}
			if (_this.opt.pagecount > 1 || _this.opt.total)
				_html.push('</div>');
			_this.element.html(_html.join(""));
		},
		_getUrl: function(page) {
			if (this.opt.ajaxload) {
				return "javascript:goPageIndex(" + page + ");";
			}
			var _url = location.pathname + "?";
			if (page && page.constructor == Number) {
				if (page <= 0) page = 1;
				return _url + Cute.params.set({
					page: page
				}).serialize() + location.hash;
			}
			return _url + location.hash;
		},
		goPageIndex: function(page) {
			this.element.html("数据加载中...");
			this.bind(this.element, $.extend(this.opt, {
				pageindex: page
			}));
		}
	});
});