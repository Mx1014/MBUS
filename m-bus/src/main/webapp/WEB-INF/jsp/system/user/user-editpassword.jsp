<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ page import="com.ets.system.user.entity.tb_user" %>
<%@ page import="com.ets.bus.pmsnControl.workerMgt.entity.mb_worker" %>
<%@ include file="/common/taglibs.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    mb_worker user = (mb_worker) session.getAttribute("workerSession");
    request.setAttribute("user", user);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>申东科技 std - 通用后台管理模板系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="${ctx}/resources/plugins/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${ctx}/resources/css/admin.css" media="all">
    <link rel="stylesheet" href="${ctx}/resources/plugins/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <link rel="stylesheet" href="${ctx}/resources/css/addClass.css" media="all"/>
</head>
<body>
<div class="layui-body layui-bg-white">
    <div class="layui-fluid">
        <div class="layui-row  layui-col-space15">
            <fieldset class="layui-elem-field layui-field-title"
                      style="margin-top: 12px;">
                <legend>密码信息</legend>
            </fieldset>
            <form class="layui-form" action="" method="post">
                <input type="hidden" name="id"  value="${user.id }"/>
                <div class="layui-form-item">
                    <label class="layui-form-label">原密码:</label>
                    <div class="layui-input-block">
                        <input type="password" name="password" id="password" placeholder="请输入原密码" autocomplete="off"
                               class="layui-input"
                               lay-verify="oldpwd" value="">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">新密码:</label>
                    <div class="layui-input-block">
                        <input type="password" name="newpwd" id="newpwd" placeholder="请输入新密码" autocomplete="off"
                               class="layui-input"
                               lay-verify="newpwd" value="">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">确认密码:</label>
                    <div class="layui-input-block">
                        <input type="password" name="repeatpwd" id="repeatpwd" value=""
                               lay-verify="repeatpwd" autocomplete="off" placeholder="再次输入新密码"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit="" lay-filter="demo1" id="demo1">确认修改</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${ctx}/resources/js/jquery-1.11.2.min.js"></script>
<script src="${ctx}/resources/plugins/layui/layui.js"></script>
<script src="${ctx}/resources/js/formatTime.js"></script>

<script>

    layui.use('element', function () {
        var element = layui.element;
    });

    layui.use(['form', 'layedit', 'laydate'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate;

        form.verify({
            oldpwd: function (value, item) {

                if (value.length == 0) {
                    return '请输入旧密码';
                }
            },
            newpwd: [/(.+){6,12}$/, '密码必须6到12位'],
            repeatpwd: function (value) {
                //获取密码
                var pass = $("#newpwd").val();
                if (!new RegExp(pass).test(value)) {
                    return '两次输入的密码不一致';
                }
            }
        });
        //检查原密密码是否正确
        function pwdCheck(data){
            var num;
            $.ajax({
                type : "POST", //提交方式
                url : "${ctx}/user/pwdCheck.action", //路径
                data : data, //数据，这里使用的是Json格式进行传输
                dataType : "json",
                async : false,
                success : function(result) { //返回数据根据结果进行相应的处理
                    num = result;
                }
            });
            return num;
        }

        $("#demo1").click(function(){
            var data = $("form").serialize();
            var num=pwdCheck(data);
            if(num == 0) {
                layer.msg('原密码输入不正确,请重新输入！', {
                    icon: 7,
                    time: 2000 //2秒关闭（如果不配置，默认是3秒）
                }, function () {
                    $("#demo1").attr('disabled', false);
                });
                return false;
            }
        });


        //监听提交
        form.on('submit(demo1)', function (data) {
            var pp=$("#newpwd").val();
            $.ajax({
                type: "POST", //提交方式
                url: "${ctx}/user/editPassword.action", //路径
                data: {id: "${user.id}", newpwd: "" + $("#newpwd").val()}, //数据，这里使用的是Json格式进行传输
                dataType: "json",
                success: function (result) { //返回数据根据结果进行相应的处理
                    var status = result.status;
                    var msg = result.msg;
                    layer.msg(msg, {
                        icon: 1,
                        time: 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function () {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                },
                error: function (result) {
                    layer.msg("操作失败!", {
                        icon: 5,
                        time: 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function () {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                }
            });
            return false;
        });

    });

</script>
</body>
</html>