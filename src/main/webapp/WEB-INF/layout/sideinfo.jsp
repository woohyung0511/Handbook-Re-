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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <style type="text/css">
        .up {
            width: 50px;
            height: 50px;
        }
        
        .sidebar {
            position: fixed;
            top: 80px;
            right: 0;
            width: 300px;
            height: 100%;
            background-color: #F0F2F5;
            padding: 20px;
            overflow-y: auto; /* 추가: 스크롤을 허용하는 스타일 속성 */
        }
        
        .userbox {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .userphoto {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        
        .un {
            font-size: 14px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <c:set var="root" value="<%=request.getContextPath() %>" />
    <div class="sidebar">
    <span style="font-size: 15pt; font-weight: bold; color: gray; font-family: Jua">Follow List</span>
    <br>
    <hr style="height: 1px; background-color: black; border: none;">
        <c:forEach var="dto" items="${ftlist}">
            <div class="userbox">
                <!-- 프로필 사진을 표시 -->
                <c:if test="${dto.user_photo != null }">
                        <div class="up">
                            <a href="/user/mypage?user_num=${dto.to_user }"><img src="/photo/${dto.user_photo}" class="userphoto"></a>
                        </div>
                </c:if>
				
				<c:if test="${dto.user_photo == null }">
					<div class="up">
                        <a href="/user/mypage?user_num=${dto.to_user }"><img src="../image/noimg.png" class="userphoto"></a>
                    </div>
				</c:if>

                <!-- 이름을 표시 -->
                <div class="un">
                    <span>${dto.user_name}</span>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>