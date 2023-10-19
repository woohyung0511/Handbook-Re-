<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style type="text/css">
.modal-content {
	overflow-y: initial !important
}

.modal-body {
	height: 900px;
	overflow-y: auto;
}

.comment {
	width: 450px;
	border: 1px solid gray;
	border-radius: 40px;
	background-color: #EEEEEE;
	padding-left: 85px;
}

/* 사용자 프로필  */
.profile {
	width: 60px;
	margin-left: -75px;
	border-radius: 100px;
	margin-right: 20px;
	position: relative;
	top: 10px;
}

/* 좋아요,댓글,날짜 */
.cmlike {
	width: 450px;
	margin-top: 10px;
	display: flex;
	justify-content: space-around;
	align-content: center;
}

/* 사용자 이름  */
b.user_name {
	font-size: 1.4em;
}

/* 사용자 댓글  */
span.content {
	font-size: 1.1em;
}

#commentaddform {
	margin-top: 7px;
	height: 60px;
	display: flex;
	justify-content: space-between;
	align-content: center;
}

#commentprofile {
	width: 60px;
	border: 1px solid gray;
	border-radius: 100px;
}

.input {
	width: 700px;
	border: 1px solid gray;
	border-radius: 40px;
	background-color: #EEEEEE;
}

.mominput {
	width: 700px;
	border: 1px solid gray;
	border-radius: 40px;
	background-color: #EEEEEE;
}

.recontent {
	cursor: pointer;
}

.nolike {
	cursor: pointer;
}

.yeslike {
	cursor: pointer;
}

.ulimg {
	cursor: pointer;
}

.commentul {
	float: right;
	list-style: none;
	display: none;
	font-size: 0.7em;
	height: 70px;
}

li{
	cursor:  pointer;
}
</style>
</head>
<script type="text/javascript">
	$(function() {
		commentoffset = ${commentoffset};

		$('#commentinput').keydown(function() {
			if (event.keyCode === 13) {
				$("#insertbtn").trigger("click");
			};
		});

		$(document).on("keydown", ".input", function() {

			if (event.keyCode === 13) {
				$(this).next().trigger("click");
			};
		});

		$(document).on("click", ".ulimg", function() {

			var comment_num = $(this).attr("comment_num");
			$("#ul" + comment_num).toggle();
		})

		$(document).on("click", ".cminsert", function() {

			var comment_num = $(this).attr("comment_num");
			var comment_content = $("#input" + comment_num).val();
			var post_num = $(this).attr("post_num");
			//alert(comment_num + comment_content + post_num);
			$.ajax({

				type : "post",
				dataType : "text",
				url : "cinsert",
				data : {
					"comment_num" : comment_num,
					"comment_content" : comment_content,
					"post_num" : post_num
				},
				success : function() {
					$("#commentsection").empty();
					$("#addcomment").hide();
					$("#input" + comment_num).val("");
					$("#input" + comment_num).hide();
					commentoffset = 0;
					scroll(commentoffset, "9");
					$("#addcomment").show();
				}
			})

		})

		$("#insertbtn").click(function() {

			var formdata = $("#form").serialize();
			//alert(formdata);
			$.ajax({

				type : "post",
				dataType : "text",
				url : "cinsert",
				data : formdata,
				success : function() {
					$("#commentsection").empty();
					$("#addcomment").hide();
					$("#commentinput").val("");
					commentoffset = 0;
					scroll(commentoffset, "9");
					$("#addcomment").show();
				}
			})
		});

		$(document).on("click", "#addcomment", function() {
			commentoffset = commentoffset + 8;
			scroll(commentoffset, "9");
		})

		$(document).on("click", ".recontent", function() {

			var comment_num = $(this).attr("comment_num");
			//alert(comment_num);
			$("#comment" + comment_num).toggle();
		})

		$(document).on("click", "span.nolike", function() {

			var comment_num = $(this).attr("comment_num");
			//alert(comment_num);
			$.ajax({
				type : "get",
				dataType : "text",
				url : "likeinsert",
				data : {
					"comment_num" : comment_num
				},
				success : function() {
					commentoffset = 0;
					$("#commentsection").empty();
					$("#addcomment").hide();
					$("#input" + comment_num).val("");
					$("#input" + comment_num).hide();
					scroll(commentoffset, "9");
					$("#addcomment").show();
				}
			});

		})

		$(document).on("click", "span.yeslike", function() {

			var comment_num = $(this).attr("comment_num");
			//alert(comment_num);
			$.ajax({
				type : "get",
				dataType : "text",
				url : "likedelete",
				data : {
					"comment_num" : comment_num
				},
				success : function() {
					commentoffset = 0;
					$("#commentsection").empty();
					$("#addcomment").hide();
					$("#input" + comment_num).val("");
					$("#input" + comment_num).hide();
					scroll(commentoffset, "9");
					$("#addcomment").show();
				}
			});

		})
		
		$(document).on("click",".commentdel",function(){
			
			var comment_num=$(this).attr("comment_num");
			$.ajax({
				type:"get",
				dataType:"text",
				url:"cdelete",
				data:{"comment_num":comment_num},
				success:function(){
					commentoffset=0;
					$("#commentsection").empty();
					$("#addcomment").hide();
					$("#input" + comment_num).val("");
					$("#input" + comment_num).hide();
					scroll(commentoffset, "9");
					$("#addcomment").show();
				}
			})
		})
		
		
		$(document).on("click",".commentmod",function(){
			
			var comment_num=$(this).attr("comment_num");
			$("#div"+comment_num).hide();
			$("#commentmod"+comment_num).show();
		})
		
		$(document).on("keydown",".inputmod",function(){
			
			if (event.keyCode === 13) {
				var comment_num=$(this).attr("comment_num");
				var comment_content=$(this).val();
				//alert(comment_num + comment_content);
				$.ajax({
					type:"post",
					dataType:"text",
					url:"commentupdate",
					data:{"comment_num":comment_num,"comment_content":comment_content},
					success:function(){
						commentoffset=0;
						$("#commentsection").empty();
						$("#addcomment").hide();
						$("#input" + comment_num).val("");
						$("#input" + comment_num).hide();
						scroll(commentoffset, "9");
						$("#addcomment").show();
					}
				});
			};
		})
	})

	/* 무한스크롤 함수 */
	function scroll(commentoffset, post_num) {

		$.ajax({
			type : "get",
			dataType : "json",
			url : "scroll",
			data : {
				"commentoffset" : commentoffset,
				"post_num" : "9"
			},
			success : function(res) {

				$.each(res, function(i, item) {

					var s = "";
					var addContent = document.createElement("div");
					s += "<div class='allcomment' style='margin-left:"+item.comment_level*50+"px;'>";
					if (item.comment_level > 0) {
						s += "<div style='position: relative; left: -50px; top: 30px; height: 0;' >";
						s += "<img src='../image/re.png' style='width: 30px;\'>";
						s += "</div>";
					}
					
					if(item.post_user_num ==${sessionScope.user_num} || item.user_num == ${sessionScope.user_num}){
						
						s += '<div style="height: 0; width: 450px; position: relative; left: -30px; top: 30px;">';
						s += '<img src="../image/add.png" class="ulimg" style="width: 20px; float: right;" comment_num="'+item.comment_num+'">';
						s += '<ul class="list-group commentul" id="ul'+item.comment_num+'">';
						s += '<li class="list-group-item list-group-item-success commentmod" comment_num="'+item.comment_num+'">수정</li>';
						s += '<li class="list-group-item list-group-item-danger commentdel" comment_num="'+item.comment_num+'">삭제</li>';
						s += '</ul>';
						s += '<div class="comment" id="commentmod'+item.comment_num+'" style="display: none; width: 447px; position: relative; left: 31px; bottom: 31px;">';
						s += '<img src="/photo/'+item.user_photo+'" class="profile">';
						s += '<b class="user_name">'+item.user_name+'</b>';
						s += '<br>';
						s += '<input type="text" class="inputmod" style="width: 200px;" comment_num="'+item.comment_num+'" value="'+item.comment_content+'">';
						s += '</div>';
						s += '</div>';
					}
					
					s += "<div class='comment' id='div"+item.comment_num+"'>";
					s += "<img src='/photo/"+item.user_photo+"' class='profile'>";
					s += "<b class='user_name'>" + item.user_name + "</b><br>";
					s += "<span class='spancontent'>" + item.comment_content + "</span></div>";
					s += "<div class='cmlike'>";

					if (item.like_check == 0) {
						s += '<span class="glyphicon glyphicon-heart-empty nolike" style="color: red;" comment_num="'+item.comment_num+'">' + item.like_count + '</span>';
					} else {
						s += '<span class="glyphicon glyphicon-heart yeslike" style="color: red;" comment_num="'+item.comment_num+'">' + item.like_count + '</span>';
					}
					
					s += "<span class='recontent' comment_num='"+item.comment_num+"'>답글달기</span>";
					s += "<span class='comment_writeday'>" + item.perTime + "</span></div>";
					s += '<form method="post" class="form-inline" id="comment'+item.comment_num+'" style="display: none;">';
					s += '<input type="hidden" name="comment_num" value="75">';
					s += '<input type="hidden" name="post_num" value="9">';
					s += '<div id="commentaddform">';
					s += '<img src="/photo/${sessionScope.user_photo }" id="commentprofile">';
					s += '<input hidden="hidden" /> ';
					s += '<input type="text" class="input" name="comment_content" placeholder="댓글을 입력하세요" id="input'+item.comment_num+'">';
					s += '<button type="button" class="btn btn-info cminsert" comment_num="'+item.comment_num+'" post_num="9"  style="margin-right: 20px;">답글입력</button>';
					s += '</div>';
					s += '</form></div>';
					console.log(s);
					addContent.innerHTML = s;
					document.querySelector('section1').appendChild(addContent);

					var brcontent = document.createElement("div");
					brcontent.innerHTML = "<br>";
					document.querySelector('section1').appendChild(brcontent);

				})
			}
		});
	}
</script>
<body>
	<!-- Trigger the modal with a button -->
	<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#commentmodal">Open Modal</button>
	<!-- Modal -->
	<div id="commentmodal" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${dto.user_name }의게시물</h4>
				</div>
				<div class="modal-body" style="max-height: 800px;">
					<!-- 타임라인 -->
					
					<br>
					<hr>
					<section1 id="commentsection"> <c:forEach var="dto" items="${list }">
						<div class="allcomment" style="margin-left: ${dto.comment_level*50}px;">
							<c:if test="${dto.comment_level>0 }">
								<div style="position: relative; left: -50px; top: 30px; height: 0;">
									<img src="../image/re.png" style="width: 30px;">
								</div>
							</c:if>
							
							
							<!-- 수정,삭제 숨겨진메뉴 -->
							<c:if test="${dto.post_user_num.equals(sessionScope.user_num) or dto.user_num.equals(sessionScope.user_num) }">
								<div style="height: 0; width: 450px; position: relative; left: -30px; top: 30px;">
									<img src="../image/add.png" class="ulimg" style="width: 20px; float: right;" comment_num="${dto.comment_num }">
									<ul class="commentul" id="ul${dto.comment_num}">
										<li class="commentmod" comment_num="${dto.comment_num }">수정</li>
										<li class="commentdel" comment_num="${dto.comment_num }">삭제</li>
									</ul>
										<div class="comment" id="commentmod${dto.comment_num }" style="display: none; width: 447px; position: relative; left: 31px; bottom: 31px;">
											<img src="/photo/${dto.user_photo }" class="profile">
											<b class="user_name">${dto.user_name }</b>
											<br>
											<input type="text" class="inputmod" style="width: 200px;" comment_num="${dto.comment_num }" value="${dto.comment_content }">
										</div>
								</div>
							</c:if>
							
							
							<div class="comment" id="div${dto.comment_num }">
								<img src="/photo/${dto.user_photo }" class="profile">
								<b class="user_name">${dto.user_name }</b>
								<br>
								<span class="spancontent">${dto.comment_content }</span>
							</div>
							<div class="cmlike">
								<c:if test="${dto.like_check==0 }">
									<span class="glyphicon glyphicon-heart-empty nolike" style="color: red;" comment_num="${dto.comment_num }">${dto.like_count }</span>
								</c:if>
								<c:if test="${dto.like_check!=0 }">
									<span class="glyphicon glyphicon-heart yeslike" style="color: red;" comment_num="${dto.comment_num }">${dto.like_count }</span>
								</c:if>
								<span class="recontent" comment_num="${dto.comment_num }">답글달기</span>
								<span class="comment_writeday">${dto.perTime}</span>
							</div>
							<form method="post" class="form-inline" id="comment${dto.comment_num }" style="display: none;">
								<div id="commentaddform">
									<img src="/photo/${sessionScope.user_photo }" id="commentprofile">
									<input hidden="hidden" />
									<input type="text" class="input" name="comment_content" placeholder="답글을 입력하세요" id="input${dto.comment_num }">
									<button type="button" class="btn btn-info cminsert" comment_num="${dto.comment_num }" post_num="9" style="margin-right: 20px;">답글입력</button>
								</div>
							</form>
						</div>
						<br>
					</c:forEach>
				</section1>
					<button type="button" class="btn btn-success" id="addcomment">댓글 더보기</button>
				</div>
				<div class="modal-footer" style="height: 80px; padding: 0;">
					<form method="post" class="form-inline" id="form">
						<input type="hidden" name="comment_num" value="0">
						<input type="hidden" name="post_num" value="9">
						<div id="commentaddform">
							<img src="/photo/${sessionScope.user_photo }" id="commentprofile">
							<input hidden="hidden" />
							<input type="text" class="mominput" name="comment_content" placeholder="댓글을 입력하세요" id="commentinput">
							<button type="button" id="insertbtn" class="btn btn-info" style="margin-right: 20px;">입력</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>