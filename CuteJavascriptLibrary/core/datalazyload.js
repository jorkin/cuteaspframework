/**
 * �����ӳټ������
 * �޸���KISSY��datalazyload
 */
Cute.reg('datalazyload', function(S, undefined) {

    var DOM = S.DOM, Event = S.Event,
        win = window, doc = document,

        IMG_SRC_DATA = 'data-ks-lazyload',
        AREA_DATA_CLS = 'ks-datalazyload',
        CUSTOM = '-custom',
        MANUAL = 'manual',
        DISPLAY = 'display', DEFAULT = 'default', NONE = 'none',
        SCROLL = 'scroll', RESIZE = 'resize',

        defaultConfig = {

            /**
             * ������ģʽ
             *   auto   - �Զ�����html ���ʱ������ img.src ���κδ���
             *   manual - ��� html ʱ���Ѿ�����Ҫ�ӳټ��ص�ͼƬ�� src �����滻Ϊ IMG_SRC_DATA
             * ע������ textarea ���ݣ�ֻ���ֶ�ģʽ
             */
            mod: MANUAL,

            /**
             * ��ǰ�Ӵ����£�diff px ��� img/textarea �ӳټ���
             * �ʵ����ô�ֵ���������û����϶�ʱ�о������Ѿ����غ�
             * Ĭ��Ϊ��ǰ�Ӵ��߶ȣ���������Ĳ��ӳټ��أ�
             */
            diff: DEFAULT,

            /**
             * ͼ���ռλͼ��Ĭ����
             */
            placeholder: NONE
        };

    /**
     * �ӳټ������
     * @constructor
     */
    function DataLazyload(containers, config) {
        var self = this;

        // factory or constructor
        if (!(self instanceof DataLazyload)) {
            return new DataLazyload(containers, config);
        }

        // ��������� config һ������
        if (config === undefined) {
            config = containers;
            containers = [doc];
        }

        // containers ��һ�� HTMLElement ʱ
        if (!S.isArray(containers)) {
            containers = [S.get(containers) || doc];
        }

        /**
         * ͼƬ�������������Զ������Ĭ��Ϊ [doc]
         * @type Array
         */
        self.containers = containers;

        /**
         * ���ò���
         * @type Object
         */
        self.config = S.merge(defaultConfig, config);

        /**
         * ��Ҫ�ӳ����ص�ͼƬ
         * @type Array
         */
        //self.images

        /**
         * ��Ҫ�ӳٴ���� textarea
         * @type Array
         */
        //self.areaes

        /**
         * ���ӳ���󶨵Ļص�����
         * @type object
         */
        self.callbacks = {els: [], fns: []};

        /**
         * ��ʼ�ӳٵ� Y ����
         * @type number
         */
        //self.threshold

        self._init();
    }

    S.augment(DataLazyload, {

        /**
         * ��ʼ��
         * @protected
         */
        _init: function() {
            var self = this;
            self.threshold = self._getThreshold();

            self._filterItems();
            self._initLoadEvent();
        },

        /**
         * ��ȡ����ʼ����Ҫ�ӳٵ� images �� areaes
         * @protected
         */
        _filterItems: function() {
            var self = this,
                containers = self.containers,
                n, N, imgs, areaes, i, len, img, area,
                lazyImgs = [], lazyAreas = [];

            for (n = 0,N = containers.length; n < N; ++n) {
                imgs = S.query('img', containers[n]);
                lazyImgs = lazyImgs.concat(S.filter(imgs, self._filterImg, self));

                areaes = S.query('textarea', containers[n]);
                lazyAreas = lazyAreas.concat(S.filter(areaes, self._filterArea, self));
            }

            self.images = lazyImgs;
            self.areaes = lazyAreas;
        },

        /**
         * filter for lazyload image
         */
        _filterImg: function(img) {
            var self = this,
                dataSrc = img.getAttribute(IMG_SRC_DATA),
                threshold = self.threshold,
                placeholder = self.config.placeholder,
                isManualMod = self.config.mod === MANUAL;

            // �ֹ�ģʽ��ֻ������ data-src ��ͼƬ
            if (isManualMod) {
                if (dataSrc) {
                    if (placeholder !== NONE) {
                        img.src = placeholder;
                    }
                    return true;
                }
            }
            // �Զ�ģʽ��ֻ���� threshold ���� data-src ��ͼƬ
            else {
                // ע�⣺���� data-src ���������������ʵ��������������ٴδ���
                if (DOM.offset(img).top > threshold && !dataSrc) {
                    DOM.attr(img, IMG_SRC_DATA, img.src);
                    if (placeholder !== NONE) {
                        img.src = placeholder;
                    } else {
                        img.removeAttribute('src');
                    }
                    return true;
                }
            }
        },

        /**
         * filter for lazyload textarea
         */
        _filterArea: function(area) {
            return DOM.hasClass(area, AREA_DATA_CLS);
        },

        /**
         * ��ʼ�������¼�
         * @protected
         */
        _initLoadEvent: function() {
            var timer, self = this;

            // scroll �� resize ʱ������ͼƬ
            Event.on(win, SCROLL, loader);
            Event.on(win, RESIZE, function() {
                self.threshold = self._getThreshold();
                loader();
            });

            // ��Ҫ��������һ�Σ��Ա�֤��һ�����ӳ���ɼ�
            if (self._getItemsLength()) {
                S.ready(function() {
                    loadItems();
                });
            }

            // ���غ���
            function loader() {
                if (timer) return;
                timer = S.later(function() {
                    loadItems();
                    timer = null;
                }, 100); // 0.1s �ڣ��û��о�����
            }

            // �����ӳ���
            function loadItems() {
                self._loadItems();
                if (self._getItemsLength() === 0) {
                    Event.remove(win, SCROLL, loader);
                    Event.remove(win, RESIZE, loader);
                }
            }
        },

        /**
         * �����ӳ���
         */
        _loadItems: function() {
            var self = this;
            self._loadImgs();
            self._loadAreas();
            self._fireCallbacks();
        },

        /**
         * ����ͼƬ
         * @protected
         */
        _loadImgs: function() {
            var self = this;
            self.images = S.filter(self.images, self._loadImg, self);
        },

        /**
         * ��ع���������ͼƬ
         */
        _loadImg: function(img) {
            var self = this,
                scrollTop = DOM.scrollTop(),
                threshold = self.threshold + scrollTop,
                offset = DOM.offset(img);

            if (offset.top <= threshold) {
                self._loadImgSrc(img);
            } else {
                return true;
            }
        },

        /**
         * ����ͼƬ src
         * @static
         */
        _loadImgSrc: function(img, flag) {
            flag = flag || IMG_SRC_DATA;
            var dataSrc = img.getAttribute(flag);

            if (dataSrc && img.src != dataSrc) {
                img.src = dataSrc;
                img.removeAttribute(flag);
            }
        },

        /**
         * ���� textarea ����
         * @protected
         */
        _loadAreas: function() {
            var self = this;
            self.areaes = S.filter(self.areaes, self._loadArea, self);
        },

        /**
         * ��ع��������� textarea
         */
        _loadArea: function(area) {
            var self = this, top,
                isHidden = DOM.css(area, DISPLAY) === NONE;

            // ע��area ���ܴ��� display: none ״̬��DOM.offset(area).top ���� 0
            // ����������� area.parentNode �� Y ֵ�����
            top = DOM.offset(isHidden ? area.parentNode : area).top;

            if (top <= self.threshold + DOM.scrollTop()) {
                self._loadAreaData(area.parentNode, area);
            } else {
                return true;
            }
        },

        /**
         * �� textarea �м�������
         * @static
         */
        _loadAreaData: function(container, area) {
            //chengyu ����ع���ʹ������ʶ�� html �ַ������ script���������
            // Ϊ��ͨ���ԣ���Ҫ���� container �ڵ�ȫ�� script dom �ڵ�ִ��

            // �������� textarea ����ȥ����ʽ��ȥ�������� Chrome �´���
            area.style.display = NONE;
            area.className = ''; // clear hook

            var content = DOM.create('<div>');
            container.insertBefore(content, area);
            DOM.html(content, area.value, true);

            //area.value = ''; // bug fix: ע�͵���������գ����� F5 ˢ�£��ᶪ����
        },

        /**
         * �����ص�
         */
        _fireCallbacks: function() {
            var self = this,
                callbacks = self.callbacks,
                els = callbacks.els, fns = callbacks.fns,
                scrollTop = DOM.scrollTop(),
                threshold = self.threshold + scrollTop,
                i, el, fn, remainEls = [], remainFns = [];

            for (i = 0; (el = els[i]) && (fn = fns[i++]);) {
                if (DOM.offset(el).top <= threshold) {
                    fn.call(el);
                } else {
                    remainEls.push(el);
                    remainFns.push(fn);
                }

            }
            callbacks.els = remainEls;
            callbacks.fns = remainFns;
        },

        /**
         * ��ӻص��������� el ������������ͼ��ʱ������ fn
         */
        addCallback: function(el, fn) {
            var callbacks = this.callbacks;
            el = S.get(el);

            if (el && S.isFunction(fn)) {
                callbacks.els.push(el);
                callbacks.fns.push(fn);
            }
        },

        /**
         * ��ȡ��ֵ
         * @protected
         */
        _getThreshold: function() {
            var diff = this.config.diff,
                vh = DOM['viewportHeight']();

            if (diff === DEFAULT) return 2 * vh; // diff Ĭ��Ϊ��ǰ�Ӵ��߶ȣ���������Ĳ��ӳټ��أ�
            else return vh + (+diff); // �� diff ת������ֵ
        },

        /**
         * ��ȡ��ǰ�ӳ��������
         * @protected
         */
        _getItemsLength: function() {
            var self = this;
            return self.images.length + self.areaes.length + self.callbacks.els.length;
        },

        /**
         * �����Զ����ӳ�����
         * @static
         */
        loadCustomLazyData: function(containers, type) {
            var self = this, area, imgs;

            // ֧������
            if (!S.isArray(containers)) {
                containers = [S.get(containers)];
            }

            // ��������
            S.each(containers, function(container) {
                switch (type) {
                    case 'img-src':
                        if (container.nodeName === 'IMG') { // �������ͼƬ
                            imgs = [container];
                        } else {
                            imgs = S.query('img', container);
                        }
                        
                        S.each(imgs, function(img) {
                            self._loadImgSrc(img, IMG_SRC_DATA + CUSTOM);
                        });
                        
                        break;
                    
                    default:
                        area = S.get('textarea', container);
                        if (area && DOM.hasClass(area, AREA_DATA_CLS + CUSTOM)) {
                            self._loadAreaData(container, area);
                        }
                }
            });
        }
    });

    // attach static methods
    S.mix(DataLazyload, DataLazyload.prototype, true, ['loadCustomLazyData', '_loadImgSrc', '_loadAreaData']);

    S.DataLazyload = DataLazyload;

}, { requires: ['core'] });

/**
 * NOTES:
 *
 * ģʽΪ auto ʱ��
 *  1. �� Firefox �·ǳ��������ű�����ʱ����û���κ�ͼƬ��ʼ���أ������������ӳټ��ء�
 *  2. �� IE �²����������ű�����ʱ���в���ͼƬ�Ѿ���������������ӣ��ⲿ�� abort ����
 *     ���ڹ���ʱ�ӳټ��أ�������������������
 *  3. �� Safari �� Chrome �£���Ϊ webkit �ں� bug�������޷� abort �����ء���
 *     �ű���ȫ���á�
 *  4. �� Opera �£��� Firefox һ�£�������
 *  5. 2010-07-12: ������ Firefox �£�Ҳ�е��²��� Aborted ���ӡ�
 *
 * ģʽΪ manual ʱ����Ҫ�ӳټ��ص�ͼƬ��src �����滻Ϊ data-lazyload-src, ���� src ��ֵ��Ϊ placeholder ��
 *  1. ���κ�������¶���������ʵ�֡�
 *  2. ȱ���ǲ�������ǿ���� JS ʱ��ͼƬ����չʾ��
 *
 * ȱ�㣺
 *  1. ���ڴ󲿷�����£���Ҫ�϶��鿴���ݵ�ҳ�棨�����������ҳ�������ٹ���ʱ����������
 *     �����飨�û��������������ã����ر������ٲ���ʱ��
 *  2. auto ģʽ��֧�� Webkit �ں��������IE �£��п��ܵ��� HTTP �����������ӡ�
 *
 * �ŵ㣺
 *  1. ���Ժܺõ����ҳ���ʼ�����ٶȡ�
 *  2. ��һ������ת���ӳټ���ͼƬ���Լ���������
 *
 * �ο����ϣ�
 *  1. http://davidwalsh.name/lazyload MooTools ��ͼƬ�ӳٲ��
 *  2. http://vip.qq.com/ ģ�����ʱ�����滻��ͼƬ�� src
 *  3. http://www.appelsiini.net/projects/lazyload jQuery Lazyload
 *  4. http://www.dynamixlabs.com/2008/01/17/a-quick-look-add-a-loading-icon-to-your-larger-images/
 *  5. http://www.nczonline.net/blog/2009/11/30/empty-image-src-can-destroy-your-site/
 *
 * �ر�Ҫע��Ĳ�������:
 *  1. ��ʼ���ں�С�����󴰿�ʱ��ͼƬ��������
 *  2. ҳ���й���λ��ʱ��ˢ��ҳ�棬ͼƬ��������
 *  3. �ֶ�ģʽ����һ�����ӳ�ͼƬʱ����������
 *
 * 2009-12-17 ���䣺
 *  1. textarea �ӳټ���Լ����ҳ������Ҫ�ӳٵ� dom �ڵ㣬����
 *       <textarea class='ks-datalazysrc invisible'>dom code</textarea>
 *     �������� hidden �� class, �������� invisible, ���趨 height = 'ʵ�ʸ߶�'���������Ա�֤
 *     ����ʱ��diff ����ʵ��Ч��
 *     ע�⣺textarea ���غ󣬻��滻���������е��������ݡ�
 *  2. �ӳ� callback Լ����dataLazyload.addCallback(el, fn) ��ʾ�� el ��������ʱ������ fn.
 *  3. ���в���������ഥ��һ�Σ����� callback. �����϶�������ʱ��ֻ�� el ��һ�γ���ʱ�ᴥ�� fn �ص���
 */

/**
 * zTODO:
 *   - [ȡ��] ����ͼƬ���ӳټ��أ����� css ��ı���ͼƬ�� sprite ���Ѵ���
 *   - [ȡ��] ����ʱ�� loading ͼ������δ�趨��С��ͼƬ��������������[�ο����� 4]��
 */

/**
 * UPDATE LOG:
 *   - 2010-07-31 yubo IMG_SRC_DATA �� data-lazyload-src ����Ϊ data-ks-lazyload + ֧�� touch �豸
 *   - 2010-07-10 chengyu �ع���ʹ��������ʽʶ�� html �еĽű���ʹ�� EventTarget �Զ����¼�����������ص�
 *   - 2010-05-10 yubo ie6 �£��� dom ready ��ִ�У��ᵼ�� placeholder �ظ����أ�Ϊ�ȱ�������⣬Ĭ��Ϊ none, ȥ��ռλͼ
 *   - 2010-04-05 yubo �ع���ʹ�ö� YUI ������������ YDOM
 *   - 2009-12-17 yubo �� imglazyload ����Ϊ datalazyload, ֧�� textarea ��ʽ�ӳٺ��ض�Ԫ�ؼ�������ʱ�Ļص�����
 */

