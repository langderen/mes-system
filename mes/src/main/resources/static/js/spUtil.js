// 工具类
var spUtil = {};

/**
 * 提交表单
 * @param param
 */
spUtil.submitForm = function (options) {
    var loadingIndex;

    var defaultConfig = {
        type: "POST",
        async: true,
        beforeSend: function () {
            loadingIndex = layer.load(2, {shade: [0.3, '#000']});
            var $btn = parent.$('.layui-layer-btn0');
            if ($btn.length > 0) {
                $btn.prop('disabled', true).css({opacity: 0.5, cursor: 'not-allowed'});
            }
        },
        success: function (result) {
            layer.close(loadingIndex);
            var $btn = parent.$('.layui-layer-btn0');
            if ($btn.length > 0) {
                $btn.prop('disabled', false).css({opacity: 1, cursor: 'pointer'});
            }

            window.spChildFrameResult = result;
            if (result.code === 0) {
                var inFrame = window !== top && parent && parent.layer && typeof parent.layer.getFrameIndex === 'function';
                var index = inFrame ? parent.layer.getFrameIndex(window.name) : null;
                var msgTarget = inFrame ? parent.layer : layer;
                msgTarget.msg('保存成功', {icon: 1, time: 800}, function () {
                    if (inFrame) {
                        if (options.reload !== false) {
                            parent.location.reload();
                        }
                        parent.layer.close(index);
                    } else if (options.reload !== false) {
                        location.reload();
                    }
                });
            } else {
                layer.msg(result.msg || '保存失败', {icon: 2});
            }
        },
        error: function (e) {
            layer.close(loadingIndex);
            var $btn = parent.$('.layui-layer-btn0');
            if ($btn.length > 0) {
                $btn.prop('disabled', false).css({opacity: 1, cursor: 'pointer'});
            }
            layer.msg('系统错误，请联系管理员', {icon: 2});
        }
    };

    var config = $.extend({}, defaultConfig, options);
    $.ajax(config);
};

/**
 * Ajax 请求
 */
spUtil.ajax = function (options) {
    var _this = this, loadingIndex;
    var opt = $.extend({}, {
        async: true,
        dataType: 'json',
        type: 'GET',
        serializable: false,
        selfProcessShow: false
    }, options);

    opt.beforeSend = function () {
        if (options.showLoading) {
            loadingIndex = layer.load();
        }
        options.beforeSend && options.beforeSend();
    };

    opt.url = _this.generateUrl(options.url);
    opt.success = function (data) {
        if (data.code === 0) {
            options.success && options.success(data);
        } else {
            if (!options.errNoTip) {
                layer.alert(data.msg, {icon: 2});
            }
        }
    };
    opt.error = function (jqXHR, textStatus, errorThrown) {
        console.log(jqXHR);
        if (_this.sessionCheck(jqXHR, textStatus, errorThrown, options.sessionNoTip)) {
            return;
        }

        if (options.error) {
            options.error();
        } else {
            layer.alert('操作失败，请重试', {icon: 2});
        }
    };

    opt.complete = function () {
        options.complete && options.complete();
        options.showLoading ? layer.close(loadingIndex) : '';
    };

    if (opt.serializable) {
        opt.contentType = 'application/json';
        opt.data = JSON.stringify(opt.data);
    }

    var ajax = $.ajax(opt);
    return ajax;
};

/**
 * session失效处理
 * @returns {boolean}
 */
spUtil.sessionCheck = function (jqXHR, textStatus, errorThrown, sessionNoTip) {
    if (jqXHR.status === 401) {
        if (!sessionNoTip) {
            layer.alert('登录状态已失效，请重新登录', {
                icon: 2
            }, function () {
                top.location = '/login-ui';
            });
        } else {
            top.location = '/login-ui';
        }
        return true;
    }

    return false;
};

/**
 * URL生成
 */
spUtil.generateUrl = function (url) {
    return url;
};
