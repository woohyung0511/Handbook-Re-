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
</head>
<body>
<div>
    <div style="margin:0px auto; width: 400px; margin-top: 100px;">
        <p style="font-size: 3em;" align="center">handbook</p>
        <div>
            <form action="/login/loginprocess" method="post">
                <div class="form-floating">
                    <input type="text" class="form-control" id="user_id" name="user_id" placeholder="아이디 입력">
                </div>
                <br>
                <div class="form-floating">
                    <input type="password" class="form-control" id="user_pass" name="user_pass" placeholder="비밀번호 입력">
                </div>
                <br>
                <div class="d-grid gap-2">
                    <button class="btn btn-primary btn-block" type="submit">로그인</button>
                </div>
                <br>
            </form>
            <div align="center">
                <a href="#">계정을 잊으셨나요?</a>
            </div>
            <br>
        </div>
    </div>
</div>
</body>
</html>