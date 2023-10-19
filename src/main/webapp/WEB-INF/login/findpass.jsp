<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
        }

        .wrapper {
            display: flex;
            justify-content: center; /* 가로 중앙. */
            align-items: center; /*새로중앙*/
            height: 100%;
        }

        .submitbtn {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container">
        <div class="wrapper">
            <div class="row">
                <div>
                    <h1 style="text-align: center; font-weight: bold;">HandBook</h1>
                </div>
                <div>
                    <form role="form" action="/find/sendEmail" method="post" name="sendEmail">
                        <p style="font-size: 15pt; font-weight: bold;">입력한 이메일로 임시 비밀번호가 전송됩니다.</p>

                        <label class="form-label">Email</label>
                        <div class="form-group">
                            <input type="email" id="userEmail" name="memberEmail" class="form-control" required>
                        </div>
                        <div class="text-center submitbtn">
                            <button type="submit" class="btn btn-block btn-primary" id="checkEmail">비밀번호 발송</button>
                            <br><br>
                            <span><a href="/find/findemail">혹시 이메일을 잊으셨나요?</a></span>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $("#checkEmail").click(function () {
        const userEmail = $("#userEmail").val();
        const sendEmail = document.forms["sendEmail"];
        $.ajax({
            type: 'post',
            url: 'emailDuplication',
            data: {
                'memberEmail': userEmail
            },
            dataType: "text",
            success: function (result) {
                if (result == "yes") {
                    // 중복되는 것이 있다면 no == 일치하는 이메일이 있다!
                    alert('임시비밀번호를 전송 했습니다.');
                    sendEmail.submit();
                } else {
                    alert('가입되지 않은 이메일입니다.');
                }
            },
            error: function () {
                console.log('에러 체크!!')
            }
        })
    });

    //submit 전에 호출
    function check() {
        //이메일 중복체크
        if ($("span.idsuccess").text() != 'ok') {
            alert("아이디 중복체크를 해주세요");
            return false;
        }
    }
</script>
<script>
    //브라우저 화면크기 바뀔 때마다 리로드하면서 중앙에 배치.
    var windowHeight = window.innerHeight;
    $(".wrapper").css('height', windowHeight - 80);

    // window.onresize = function (event) {
    //     location.reload();
    // }


    // 브라우저 화면크기 바뀔 때마다 리로드하지 않고, 중앙에 배치.
    window.onresize = function (event) {
        var windowHeight = window.innerHeight;
        $(".wrapper").css('height', windowHeight - 80);
    }
</script>
</body>
</html>