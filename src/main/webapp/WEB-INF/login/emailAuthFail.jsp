<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">
    <style>
        body {
            overflow: hidden;
        }
        .wrapper {
            height: 100vh;
            display: flex;
            align-items: center; /*새로중앙*/
            flex-direction: column;
            margin-top: 150px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <p style="font-size: 1.5em;">이메일 인증 후 다시 시도해주세요! 메일함에 있습니다!</p>
    <button class="btn btn-primary" type="button" onclick="location.href='/signup/reregisterEmail?user_num=${user_num}'">다시 인증하기</button>
</div>
</body>
</html>