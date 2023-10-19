<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
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

        .findBtn {
            margin-top: 20px;
        }

        .result {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="container">
        <div class="wrapper">
            <div class="row">
                <h1 style="text-align: center; font-weight: bold;">HandBook</h1>
                <form id="form">
                    <p style="font-size: 15pt; font-weight: bold;">입력한 이름과 폰번호로 이메일을 찾습니다.</p>
                    <label class="form-label">이름</label>
                    <div class="form-group">
                        <input type="text" class="form-control" name="user_name" required="required" id="user_name">
                    </div>
                    <div class="form-floating">
                        <label class="form-label">핸드폰 번호</label>
                        <p>
                            <select class="form-control" id="hp1" name="hp1" size="1" style="width:100px; display:inline-block;">
                                <option value="010" class="hp1">010</option>
                                <option value="011" class="hp2">011</option>
                                <option value="016" class="hp3">016</option>
                                <option value="070" class="hp4">070</option>
                            </select>
                            <span>&nbsp;&nbsp;-&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" id="hp2" name="hp2" size="3" required="required" style="width:120px; display:inline-block;" required="required">
                            <span>&nbsp;&nbsp;-&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" id="hp3" name="hp3" size="3" required="required" style="width:120px; display:inline-block;" required="required">
                        </p>
                    </div>
                    <button type="button" class="btn btn-primary btn-block findBtn" onclick="find()">찾기</button>
                </form>

                <div class="result">
                    <span class="returnemail">&nbsp;</span>
                </div>
            </div>
        </div>

    </div>
</div>
<script>
    function find() {
        var formData = $("#form").serialize();
        $.ajax({
            url: "findemailaction",
            type: 'POST',
            data: formData,
            dataType: "text",
            success: function (data) {
                if (data == "해당하는 이메일 없음") {
                    $(".returnemail").text("해당하는 이메일 없음");
                } else {
                    $(".returnemail").text("이메일은 " + data + "입니다.");
                }

            },
            error: function (xhr, status) {
                alert(xhr + " : " + status);
            }
        });
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