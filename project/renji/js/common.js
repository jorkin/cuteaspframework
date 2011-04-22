/// <reference path="jquery-1.3.2-vsdoc2.js" />
//应用扩展
var SNS = {
	config: {
		NOTICEFREQUENCY: 30 * 1000
	},
	common: {
		copy: function(obj, txt, success) {
			if (typeof ZeroClipboard == "undefined") return false;
			this.clip = null;
			ZeroClipboard.setMoviePath(Cute.config.SCRIPTPATH + "ZeroClipboard.swf");
			this.clip = new ZeroClipboard.Client();
			this.clip.setHandCursor(true);
			this.clip.setText(txt);
			this.clip.addEventListener('onComplete', success);
			$(window).resize(function() {
				this.clip.reposition();
			} .bind(this));
			this.clip.glue($(obj)[0]);
			return this.clip;
		},
		errorAnimation: function(obj) {
			obj.stop(false, true).focus();
			var _o_bgcolor = obj.css("backgroundColor");
			obj.css({
				backgroundColor: "#FFC8C8"
			}).animate({
				backgroundColor: _o_bgcolor
			}, 1000);
			return false;
		},
		blockSlide: function(options) {
			var self = this;
			var opt = $.extend(true, {
				width: 468, 	//宽度
				height: 80, 	//高度
				data: [], 	//广告列表，例：[{href:"",image:"",title:""}]
				interval: 5, //轮播间隔
				styleurl: ""	//特殊样式URL
			}, options);
			var iframe = $('<iframe />', {
				frameborder: 0,
				scrolling: "no",
				width: opt.width,
				height: opt.height
			}).css("display", "none").load(function() {
				var iDoc = iframe.contents();
				var _html = [];
				var _head = "\
					<style>\
					body{margin:0;padding:0;font-family:Arial;-webkit-text-size-adjust:none;}\
					img{border:0;}\
					.ad_list,.ad_ids{margin:0;padding:0;list-style:none;}\
					.ad_list li{ position:absolute;top:0;left:0;display:none;}\
					.ad_ids{position:absolute;bottom:10px; right:10px;z-index:50;}\
					.ad_ids li{float:left;margin-left:4px;}\
					.ad_ids li a{display:inline-block;font-size:9px;padding:2px 4px; border:1px solid #ddd;background-color:#eee;text-decoration:none;color:#888;zoom:1;}\
					.ad_ids li a:hover{text-decoration:none;}\
					.ad_ids li a.curr{border-color:#242424;color:#fff;background-color:#242424;}\
					</style>\
				";
				if (opt.styleurl) _head += '<link type="text/css" rel="stylesheet" href="' + opt.styleurl + '" />';
				iDoc.find("head").html(_head);
				var content = iDoc.find("body");
				if (opt.data.length > 0) {
					$(this).show();
					_html.push('<ul class="ad_list">');
					$.each(opt.data, function(i, item) {
						_html.push('<li><a href="' + item.url + '" target="_blank"><img dynamic-src="' + item.image + '" alt="' + item.title + '" title="' + item.title + '" width="' + opt.width + '" height="' + opt.height + '" /></a></li>');
					});
					_html.push('</ul>');
					if (opt.data.length > 1) {
						_html.push('<ul class="ad_ids">');
						$.each(opt.data, function(i, item) {
							_html.push('<li><a href="javascript:void(0)">' + (i + 1) + '</a></li>');
						});
						_html.push('</ul>');
					}
					$(this).contents().find("body").html(_html.join('')).find(".ad_ids a").click(function() {
						setAdItem(parseInt($(this).text()) - 1);
					});
					setAdItem(0);
				}
				function setAdItem(num) {
					if (num > opt.data.length - 1) {
						num = 0;
					}
					var _ulList = iDoc.find(".ad_list");
					var _ulIds = iDoc.find(".ad_ids");
					_ulList.children("li").filter(":visible").stop(true, true).fadeOut(1000, function() {
						$(this).css("z-index", 0);
					}).end().eq(num).css("z-index", 1).stop(true, true).fadeIn(1000);
					_ulList.find("img").filter(":eq(" + num + "),:eq(" + (num + 1 > opt.data.length - 1 ? 0 : (num + 1)) + ")").attr("src", function() {
						var src = $(this).attr("dynamic-src");
						$(this).removeAttr("dynamic-src");
						return src;
					});
					if (opt.data.length > 1) {
						_ulIds.find("a").removeClass().eq(num).addClass("curr");
						clearTimeout(self.timer);
						self.timer = setTimeout(function() {
							setAdItem(num + 1);
						}, opt.interval * 1000);
					}
				}
			});
			return iframe;
		},
		editor: function(el, options) {
			KE.init($.extend({
				id: el || "tbContent",
				resizeMode: 1,
				scriptsPath: Cute.config.SCRIPTPATH + "/js",
				skinsPath: Cute.config.RESOURCEURL + "/js/editor/skins/",
				pluginsPath: Cute.config.RESOURCEURL + "/js/editor/plugins/",
				loadStyleMode: true,
				filterMode: true,
				urlType: "domain",
				dialogAlignType: "",
				allowFileManager : false,
				autoSetDataMode: true,
				imageUploadJson: '/js/editor/asp/upload_json.asp',
				htmlTags: {
					font: ['color', 'size', 'face', '.background-color'],
					span: ['style'],
					a: ['href', 'target', 'style'],
					embed: ['src', 'width', 'height', 'type', 'loop', 'autostart', 'quality', 'align', 'allowscriptaccess', '/'],
					img: ['src', 'width', 'height', 'border', 'alt', 'title', 'align', 'class', '/', 'style'],
					hr: ['/'],
					br: ['/'],
					'p,ol,ul,li,blockquote,h1,h2,h3,h4,h5,h6': []
				},
				items: ['source', '|', 'fullscreen', 'undo', 'redo', 'print', 'cut', 'copy', 'paste',
						'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
						'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
						'superscript', '|', 'selectall', '-',
						'title', 'fontname', 'fontsize', '|', 'textcolor', 'bgcolor', 'bold',
						'italic', 'underline', 'strikethrough', 'removeformat', '|', 'image',
						'flash', 'media', 'advtable', 'hr', 'emoticons', 'link', 'unlink']
			}, options || {}));
			KE.create(el);
		}
	}
};

/*
* jQuery Color Animations
*/
(function(jQuery) {
	jQuery.each(['backgroundColor', 'borderBottomColor', 'borderLeftColor', 'borderRightColor', 'borderTopColor', 'color', 'outlineColor'], function(i, attr) {
		jQuery.fx.step[attr] = function(fx) {
			if (fx.state == 0) {
				fx.start = getColor(fx.elem, attr);
				fx.end = getRGB(fx.end);
			}
			fx.elem.style[attr] = "rgb(" + [
		Math.max(Math.min(parseInt((fx.pos * (fx.end[0] - fx.start[0])) + fx.start[0]), 255), 0),
		Math.max(Math.min(parseInt((fx.pos * (fx.end[1] - fx.start[1])) + fx.start[1]), 255), 0),
		Math.max(Math.min(parseInt((fx.pos * (fx.end[2] - fx.start[2])) + fx.start[2]), 255), 0)
	].join(",") + ")";
		}
	});
	function getRGB(color) {
		var result;
		if (color && color.constructor == Array && color.length == 3)
			return color;
		if (result = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(color))
			return [parseInt(result[1]), parseInt(result[2]), parseInt(result[3])];
		if (result = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(color))
			return [parseFloat(result[1]) * 2.55, parseFloat(result[2]) * 2.55, parseFloat(result[3]) * 2.55];
		if (result = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(color))
			return [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16)];
		if (result = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(color))
			return [parseInt(result[1] + result[1], 16), parseInt(result[2] + result[2], 16), parseInt(result[3] + result[3], 16)];
		return "";
	}
	function getColor(elem, attr) {
		var color;
		do {
			color = jQuery.curCSS(elem, attr);
			if (color != '' && color != 'transparent' || jQuery.nodeName(elem, "body"))
				break;
			attr = "backgroundColor";
		} while (elem = elem.parentNode);
		return getRGB(color);
	};
})(jQuery);
//站点初始化
$(function() {
	$(function() {
		if ($.browser.msie) Cute.form.bindFocus();
		Cute.form.bindDefault();
	});
	//内存整理
	$(window).unload(function() {
		$(this).removeData();
	});
});