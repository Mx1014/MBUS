<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
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
                <legend>用户信息</legend>
            </fieldset>
            <form class="layui-form" action="" method="post">
                <input type="hidden" name="id" id="id" value="${user.id }"/>
                <div class="layui-form-item" >
                    <label class="layui-form-label">账号:</label>
                    <div class="layui-input-block" id="div-username">
                        <input type="text" name="username" id="username" value="${user.username }"
                               lay-verify="title" autocomplete="off" placeholder="请输入账号"
                               class="layui-input">
                    </div>
                </div>
                
                 <div class="layui-form-item">
                    <label class="layui-form-label">真实姓名:</label>
                    <div class="layui-input-block">
                        <input type="text" name="realname" id="realname" value="${user.realname }"
                               lay-verify="realname" autocomplete="off" placeholder="请输入realname"
                               class="layui-input">
                    </div>
                </div>
                
                <div class="layui-form-item" id="div-password">
                    <label class="layui-form-label">密码</label>

                    <div class="layui-input-block">
                        <input type="password" name="password" id="password" placeholder="请输入密码" autocomplete="off" class="layui-input"
                               lay-verify="password" value="${user.password}">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">邮箱:</label>
                    <div class="layui-input-block">
                        <input type="text" name="email" id="email" value="${user.email }"
                               lay-verify="email" autocomplete="off" placeholder="请输入邮箱"
                               class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">手机:</label>
                    <div class="layui-input-block">
                        <input type="text" name="tel" id="tel" value="${user.tel }"
                               lay-verify="required|phone" autocomplete="off" placeholder="请输入手机"
                               class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">是否启动 :</label>
                    <div class="layui-input-block">
                        <input type="checkbox"
                               <c:if test="${user.isclose==1}">checked="checked"</c:if>
                               name="isclose" value="1" lay-skin="switch"
                               lay-filter="switchTest" lay-text="ON|OFF">
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-submit="" lay-filter="demo1" id="demo1">提交</button>
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
   var id=$("#id").val();
   if (id !="" && id !=null) {
       $("#div-password").attr("style","display:none");
       $("#div-username").html("<label class=\"layui-form-mid\">${user.username }</label>")
   }



    layui.use('element', function () {
        var element = layui.element;
    });

    layui.use(['form', 'layedit', 'laydate'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate;


        //自定义验证规则
        form.verify({
            title:function (value) {
                if (value.length < 5) {
                    return '请输入至少5位的用户名';
                }
                if (value.length > 10) {
                    return '请输入小于10位的用户名'
                }
            }
            ,phone: [/^1[3|4|5|7|8]\d{9}$/, '手机必须11位，只能是数字！']
            ,email: [/^[a-z0-9._%-]+@([a-z0-9-]+\.)+[a-z]{2,4}$|^1[3|4|5|7|8]\d{9}$/, '邮箱格式不对']
            ,password: [/(.+){6,12}$/, '密码必须6到12位']
        });

        //创建一个编辑器
        layedit.build('LAY_demo_editor');

        //监听指定开关
        form.on('switch(switchTest)', function (data) {
            if (this.checked == true) {
                layer.msg('已启用')
            } else {
                layer.msg('已禁用')
            }
        });
        //检查用户的唯一性
        function isCheckUser(data){
            var num;
            $.ajax({
                type : "POST", //提交方式
                url : "${ctx}/user/isCheckUser.action", //路径
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
            var num=isCheckUser(data);
            if(num != 0 && num != -1) {
                layer.msg('用户名已存在,请重新输入！', {
                    icon: 7,
                    time: 2000 //2秒关闭（如果不配置，默认是3秒）
                }, function () {
                    $("#username").focus();
                    $("#demo1").attr('disabled', false);
                });
                return false;
            }
        });

        //监听提交
        form.on('submit(demo1)', function (data) {
            var data = $("form").serialize();
            $.ajax({
                type : "POST", //提交方式
                url : "${ctx}/user/save.action", //路径
                data : data, //数据，这里使用的是Json格式进行传输
                dataType : "json",
                async : false,
                success : function(result) { //返回数据根据结果进行相应的处理
                    var status = result.status;
                    var msg = result.msg;
                    layer.msg(msg, {
                        icon : 1,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                },
                error : function(result) {
                    layer.msg("操作失败!", {
                        icon : 5,
                        time : 2000 //2秒关闭（如果不配置，默认是3秒）
                    }, function() {
                        layer.close(layer.index);
                        window.parent.location.reload();
                    });
                }
            });
            return false;
        });
    })
</script>
</body>
</html>