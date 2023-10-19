<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<script src="https://code.jquery.com/jquery-3.6.3.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap"
	rel="stylesheet">
<style type="text/css">
body {
	font-size: 1.3em;
	font-family: 'Jua';
	padding-right: 0 !important;
}

div.layout div {
	
}

div.layout div.title {
	position: fixed;
	width: 100%;
	height: 80px;
	background-color: white;
	z-index: 1;
}

/* div.layout div.menu {
	position: fixed;
	margin-top: 80px;
	width: 200px;
	height: 100%;
	background-color: pink;
} */

div.layout div.main {
	max-width: 100%;
	min-width: 400px;
	height: 100%;
	margin: 0 auto;
	padding-top: 80px;
}

/* div.layout div.sideinfo {
	position: fixed;
	right: 0px;
	margin-top: 80px;
	width: 200px;
	height: 100%;
	background-color: lightgray;
} */
</style>

<!-- 사이드 변경해주는 스크립트 필요없어서 삭제함 -->

</head>
<body>
	<div class="layout">
		<div class="title">
			<tiles:insertAttribute name="title" />
		</div>
		<%-- <div class="menu">
			<tiles:insertAttribute name="menu" />
		</div>
		<div class="sideinfo">
			<tiles:insertAttribute name="sideinfo" />
		</div> --%>
		<div class="main">
			<tiles:insertAttribute name="main" />
		</div>
	</div>
	
	
	<!-- Modal -->
		<div class="modal fade" id="contentwrite" role="dialog">
			<div class="modal-dialog">

				<!-- Modal content-->
				<form method="post" enctype="multipart/form-data" id="postInsert">

					<input type="hidden" name="user_num" id="user_num" value="${sessionScope.user_num }">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title">게시글 만들기</h4>
						</div>
						<div class="modal-body">
							<div class="form-group" style="width: 500px;">
								<img alt="" src="${root }/photo/${user_photo}"
									style="width: 40px; height: 40px; border-radius: 20px;">
								<span>${login_name}</span>
							</div>
							<br> <select class="form-control" name="post_access" style="width: 150px;"
								id="post_access">
								<option value="all">전체공개</option>
								<option value="follower">팔로워 공개</option>
								<option value="onlyme">나만보기</option>
							</select>
							<div class="form-group" style="width: 500px;">
								<input type="file" name="post_file" class="form-control" multiple="multiple" id="post_file">
							</div>
							<div class="form-group">
								<textarea style="width: 550px; height: 150px;" name="post_content" class="form-control"
									required="required" id="post_content" placeholder="내용을 입력해주세요"></textarea>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal" id="insertbtn">게시</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					</div>
				</form>

			</div>
		</div>
</body>

<script type="text/javascript">
$("#insertbtn").click(function() {

	var post_access = $("#post_access").val();
	var post_content = $("#post_content").val();
	var user_num = $("#user_num").val();
	//var data="num="+updatenum+"&name="+updatename+"&hp="+updatehp+"&email="+updateemail+"&addr="+updateaddr;
	//var data=$("#postInsert").serialize();

	var form = new FormData();
	form.append("photo", $("#post_file")[0].files[0]);
	form.append("post_access", post_access);
	form.append("post_content", post_content);
	form.append("user_num", user_num);
	console.dir(form);

	$.ajax({

		type : "post",
		dataType : "text",
		processData : false,
		contentType : false,
		data : form,
		url : "../post/insert",
		success : function() {
			location.reload();
		}
	});
});
</script>
</html>