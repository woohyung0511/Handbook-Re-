<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script src="https://kit.fontawesome.com/d178b85e81.js" crossorigin="anonymous"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">
<style type="text/css">
.menu{
   font-size: 25pt;
   margin-top: 25px;
} 
.menulist{
   font-size: 20pt;
   margin-left: 30px;
   margin-top:5px;
   padding: 5px;
}
.menulist:hover {
   background-color: #F0F3F7;
   transition: width 0.3s;
   transform: scale(1.05);
   width:46%;
   box-shadow: 0px 0px 5px rgba(0,0,0,0.3);
   border-radius: 10px;
}
.menub{
   font-size: 12pt;
   color: black;
   margin-left: 10px;
}
</style>
</head>
<body>
	<c:set var = "root" value = "<%=request.getContextPath() %>"/>
	<div class = "menu">
		<div class ="menuprofile" style="margin-top: 10px; padding: 5px;">

		<c:if test="${sessionScope.loginok!=null }">
		
			<c:if test="${sessionScope.user_photo==null }">
			<a href="/user/mypage?user_num=${sessionScope.user_num }" style="margin-left: 30px; "><img alt = "" src = "${root }/image/noimg.png" width="35" height="35" class = "img-circle"></a>
			<span style="font-size: 12pt; margin-left: 3px;">${sessionScope.name}</span>
			</c:if>
			
			<c:if test="${sessionScope.user_photo!=null }">
			<a href="/user/mypage?user_num=${sessionScope.user_num }" style="margin-left: 30px; "><img alt = "" src = "${root }/photo/${sessionScope.user_photo}" width="35" height="35" class = "img-circle"></a>
			<span style="font-size: 12pt; margin-left: 3px;">${sessionScope.name}</span>
			</c:if>
		</c:if>
		</div>
		
		
		
		
      	<c:if test="${sessionScope.loginok!=null }"> <!-- 로그아웃 상태에서 메뉴 부분을 숨기기 위한 조건문 추가 -->
        <div class="menulist">
            <a href="${root}/following/recommendlist?from_user=${sessionScope.user_num}" style="text-decoration-line: none;"><i class="fa-solid fa-user-plus"></i><span class="menub"><span>팔로잉</span><span style="margin-left: 3px;">추천</span></span></a>
        </div>
        
        <div class="menulist">
            <a href="${root}/following/followlist?from_user=${sessionScope.user_num}" style="text-decoration-line: none;"><i class="fa-solid fa-user-group"></i><span class="menub"><span>팔로잉</span><span style="margin-left: 3px;">목록</span></span></a>
        </div>
       
        <div class="menulist">
            <a href="${root }/post/bookmarktimeline" style="text-decoration-line: none;"><i class="fa-solid fa-star" style="color: #ffd43b;"></i><span class="menub">&nbsp;즐겨찾기</span></a>
        </div>
      	
        <div class="menulist">
            <a href="#" data-toggle="modal" data-target="#contentwrite" style="text-decoration-line: none;"><i class="fa-solid fa-pen-to-square" style="color: black;"></i><span class="menub">게시글 작성</span></a>
        </div>
        </c:if>
        
    </div>
	
</body>
</html>