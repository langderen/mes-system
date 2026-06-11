<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MES系统</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <link rel="shortcut icon" href="./favicon.ico" type="image/x-icon"/>
    <#include "${request.contextPath}/common/common.ftl">
    <script src="${request.contextPath}/lib/jq-module/jquery.particleground.min.js" charset="utf-8"></script>
    <link rel="stylesheet" href="${request.contextPath}/css/start.css" media="all">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
        }
        body:after {
            content: '';
            background-repeat: no-repeat;
            background-size: cover;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: -1;
        }

        .layui-container {
            width: 100%;
            height: 100%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .admin-login-background {
            width: 380px;
            padding: 40px;
            position: relative;
        }

        .logo-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-title h1 {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
            letter-spacing: 3px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }

        .logo-title p {
            color: rgba(255,255,255,0.8);
            font-size: 12px;
            margin-top: 8px;
            letter-spacing: 1px;
        }

        .login-form {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 16px;
            padding: 30px 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .login-form .layui-form-item {
            position: relative;
            margin-bottom: 20px;
        }

        .login-form .layui-form-item label {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 24px;
            line-height: 24px;
            text-align: center;
            color: rgba(255,255,255,0.8);
            font-size: 18px;
            z-index: 10;
        }

        .login-form .layui-form-item input {
            padding-left: 42px;
            height: 42px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            transition: all 0.3s;
        }

        .login-form .layui-form-item input:focus {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
        }

        .login-form .layui-form-item input::placeholder {
            color: rgba(255,255,255,0.6);
        }

        .captcha {
            width: 60%;
            display: inline-block;
        }

        .captcha-img {
            display: inline-block;
            width: 34%;
            float: right;
            cursor: pointer;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s;
        }

        .captcha-img:hover {
            transform: scale(1.05);
        }

        .captcha-img img {
            height: 42px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 8px;
            width: 100%;
        }

        .layui-form-item .layui-form-checkbox[lay-skin="primary"] {
            margin-top: 0 !important;
        }

        .layui-form-item .layui-form-checkbox[lay-skin="primary"] span {
            color: rgba(255,255,255,0.8) !important;
            font-size: 13px;
        }

        .layui-form-item .layui-form-checked[lay-skin="primary"] span {
            color: #fff !important;
        }

        .layui-btn-fluid {
            height: 44px;
            line-height: 44px;
            font-size: 16px;
            font-weight: 500;
            letter-spacing: 2px;
            color: #fff;
            background: linear-gradient(145deg, #7a6fe0, #5d4fb3);
            border: none;
            border-radius: 22px;
            box-shadow: -2px -2px 8px rgba(255, 255, 255, 0.1),
                        -2px -2px 12px rgba(255, 255, 255, 0.05),
                        inset 2px 2px 4px rgba(255, 255, 255, 0.1),
                        2px 2px 8px rgba(0, 0, 0, 0.25);
            transition: all 0.3s;
            cursor: pointer;
        }

        .layui-btn-fluid:hover {
            box-shadow: inset -2px -2px 8px rgba(0, 0, 0, 0.2),
                        inset -2px -2px 12px rgba(0, 0, 0, 0.15),
                        inset 2px 2px 4px rgba(255, 255, 255, 0.1),
                        inset 2px 2px 8px rgba(0, 0, 0, 0.25);
            transform: none;
        }

        .layui-btn-fluid:active {
            box-shadow: inset -2px -2px 8px rgba(0, 0, 0, 0.3),
                        inset -2px -2px 12px rgba(0, 0, 0, 0.2),
                        inset 2px 2px 4px rgba(255, 255, 255, 0.05),
                        inset 2px 2px 8px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
<div class="stars"></div>
<div class="layui-container">
    <div class="admin-login-background">
        <div class="layui-form login-form">
            <form class="layui-form" action="">
                <div class="layui-form-item logo-title">
                    <h1>MES系统-登录</h1>
                    <p>Manufacturing Execution System</p>
                </div>
                <div class="layui-form-item">
                    <label class="layui-icon layui-icon-username" for="username"></label>
                    <input type="text" name="username" lay-verify="required|account" placeholder="用户名或者邮箱" autocomplete="off" class="layui-input" value="admin" >
                </div>
                <div class="layui-form-item">
                    <label class="layui-icon layui-icon-password" for="password"></label>
                    <input type="password" name="password" lay-verify="required|password" placeholder="密码" autocomplete="off" class="layui-input" value="123" >
                </div>
                <div class="layui-form-item">
                    <label class="layui-icon layui-icon-vercode" for="captcha"></label>
                    <input type="text" name="captcha" lay-verify="required|captcha" placeholder="图形验证码" autocomplete="off" class="layui-input verification captcha" >
                    <div class="captcha-img">
                        <img id="captchaPic" >
                    </div>
                </div>
                <div class="layui-form-item ">
                    <input type="checkbox" name="rememberMe" value="true" lay-skin="primary" title="记住密码">
                </div>
                <div class="layui-form-item">
                    <button class="layui-btn layui-btn-fluid" lay-submit="" lay-filter="login">登 入</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    layui.use(['form', 'layer'], function () {
        var form = layui.form,
            layer = layui.layer;

        // 登录过期的时候，跳出ifram框架
        if (top.location != self.location) top.location = self.location;
        // 进行登录操作
        form.on('submit(login)', function (data) {
            $.ajax({
                type: "POST",
                //请求的媒体类型
                url: "${request.contextPath}/login",
                data: data.field,
                success: function (result) {
                    if (result.code === 0) {
                        location.href = '${request.contextPath}/admin'
                    } else {
                        layer.alert(result.msg, {
                            icon: 2
                        })
                    }
                },
                error: function (e) {
                    layer.alert(e, {
                        icon: 2
                    })
                }
            });
            return false;
        });
        /**
         * 获取图形验证码
         */
        $('#captchaPic').click(function () {
            this.src = "${request.contextPath}/verification/code?" + Math.random();
        });
        $("#captchaPic").click();
    });
</script>

<script>
    $(document).ready(function(){
        var stars=800;  /*星星的密集程度，数字越大越多*/
        var $stars=$(".stars");
        var r=800;   /*星星的看起来的距离,值越大越远,可自行调制到自己满意的样子*/
        for(var i=0;i<stars;i++){
            var $star=$("<div/>").addClass("star");
            $stars.append($star);
        }
        $(".star").each(function(){
            var cur=$(this);
            var s=0.2+(Math.random()*1);
            var curR=r+(Math.random()*300);
            cur.css({
                transformOrigin:"0 0 "+curR+"px",
                transform:" translate3d(0,0,-"+curR+"px) rotateY("+(Math.random()*360)+"deg) rotateX("+(Math.random()*-50)+"deg) scale("+s+","+s+")"

            })
        })
    })
</script>
</body>
</html>