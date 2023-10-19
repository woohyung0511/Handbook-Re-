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
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script src="https://kit.fontawesome.com/d178b85e81.js" crossorigin="anonymous"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">
<style type="text/css">
.recommendlist{
	border: 1px solid gray; 
	display: flex; 
	justify-content: center; 
	width: 900px; 
	flex-direction: column; 
	margin-top: 30px;
	margin: 0 auto;
}
.followsearchbox{
	width:150px; 
	height:30px; 
	border: none; 
	background: none; 
	outline: none; 
	font-size: 13pt;
	padding: 10px;"
}

.userbox {
	width: 400px;
	height: 200px;
	border: 1px solid gray;
	border-radius: 5px;
	margin-right: 10px;
	margin-bottom: 10px;
	display: inline-flex;
	align-items: center;
	justify-content: space-between;
}
.up{
	border: none;
	border-radius: 100px;
	margin-left: 15px;
	margin-right: 10px;
	width: 90px;
	height: 80px;
	overflow: hidden;
	text-align: center;
	background-size: cover
}

.userphoto {
	border-radius: 100px;
	float: left;
	width : 80px;
	height: 80px;
}

.btndiv {
	width: 180px;
	display: inline-flex;
	justify-content: flex-end;
	margin-right: 15px;
}

.addbtn{
	margin-right: 15px;
}
.section{
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
	width: 820px;
	margin: 0 auto;
}

.upunbox{
	display: inline-flex;
	align-items: center;
	width: 270px;
}
</style>
</head>
<script type="text/javascript">
	$(function(){
		wsOpen();
		
		offset=${offset};
			$(document).on("click",".addbtn",function(){
				
				var user_num=$(this).attr("user_num");
				const btn=document.getElementById('btn'+user_num);
				var text=$(this).text();
				$(this).innerText='안녕';
				 if(text=="팔로워추가"){
					$.ajax({
						type:"get",
						dataType:"text",
						url:"insertfollowing",
						data:{"from_user":"${sessionScope.user_num}", "to_user":user_num},
						success:function(){
							btn.innerText="팔로워취소";
							ws.send('{"type":"follow","receiver_num":"'+user_num+'","sender_num":"${sessionScope.user_num}"}');
						}
					}); 
				}else{
					
					$.ajax({
						type:"get",
						dataType:"text",
						url:"deletefollowing",
						data:{"to_user":user_num},
						success:function(){
							btn.innerText="팔로워추가";
						}
					}) 
				} 
				
			});
			
			
			window.onscroll = function(e) {

			      if((window.innerHeight + window.scrollY) >= document.body.scrollHeight) {

			    	  offset=offset+8;
			    	  $.ajax({
			    		 type:"get",
			    		 dataType:"json",
			    		 url:"recommendlistscroll",
			    		 data:{"offset":offset,"from_user":${sessionScope.user_num}},
			    		 success:function(res){
			    			 $.each(res,function(i,item){
			    				 setTimeout(function(){
			    					
			    		        		var s = "";

			    		        		s+='<div class="upunbox">';
			    		        		
			    		        		if(item.user_photo != null){
			    		        			s += '<div class="up">';
		    		    					s += '<img src="/photo/'+item.user_photo+'" class="userphoto">';
		    		    					s += '</div>';
			    		        			
			    		        		}else{
			    		        			s += '<div class="up">';
		    		    					s += '<a href="/user/mypage?user_num='+item.user_num+'"><img src="../image/noimg.png" class="userphoto"></a>';
		    		    					s += '</div>';		
			    		        		}
			    		    			s += '<div class="un">';
			    		    			s += '<div style="display: inline-flex; flex-direction: column; ">';
			    		    			s += '<span style="font-size:13px; font-weight: bold;">'+item.user_name+'</span>';
			    		    			if(item.tf_count>0){
			    		    				s += '<span class="tf" style="font-size: 8px;">함께아는친구:'+item.tf_count+'</span>';
			    		    			}
			    		    			s += '</div>';
			    		    			s += '</div>';
			    		    			s+='</div>';
			    		    			
			    		    			s += '<div class="btndiv">';
			    		    			if(item.to_user != null){
			    		    				s += '<button type="button" class="btn btn-outline-primary btn-lg addbtn" id="btn'+item.user_num+'" user_num = "'+item.to_user+'">팔로워추가</button>';
			    		    			}else{
			    		    				s += '<button type="button" class="btn btn-outline-primary btn-lg addbtn" id="btn'+item.user_num+'" user_num = "'+item.user_num+'">팔로워추가</button>';
			    		    			}
			    		    			s += '</div>';	

			    		    					
			    		             	console.log(s);
			    		             	var addContent = document.createElement("div");
			    		                addContent.classList.add("userbox");
			    		                addContent.innerHTML = s;
			    		                document.querySelector('section').appendChild(addContent);
			    		              	
			    		         }, 1000)  
			    			 });
			    		 }
			    	  });
			    	  
			       
			      }
			    }
				$(".followsearchbox").keyup(function(e){
				if(e.keyCode == 13){
					location.href = "recommendlist?from_user="+${sessionScope.user_num}+"&searchword="+$(".followsearchbox").val(); //sessionScope.user_num 로그인한 사람
				}
			});
		});
	
	var ws;

	//웹소켓 오픈(메시지 알림)
	function wsOpen() {
		ws = new WebSocket("ws://" + location.host + "/chating");
		wsEvt();
	}

	function wsEvt() {
		ws.onopen = function(data) {
		}
	
		//메시지 잘 들어왔을 때 실행하는 내용
		ws.onmessage = function(data) {
		}
	}
	
</script>

<body>
	<div class = "recommendlist">
	
		<div style="display: inline-flex; align-items: center; justify-content: space-between; margin-top: 20px;">
		
			<span style="margin-left: 35px; margin-bottom: 20px; font-size: 20pt; font-weight: bold;">팔로잉 추천</span>
			
			<div style="margin-right: 60px; background-color: #F0F2F5; border-radius: 60px; display: inline-flex; padding-left: 2%">
			
				<span class="glyphicon glyphicon-search" style="font-size: 16pt;"></span>
				
				<input type = "text" name = "searchword" class="followsearchbox" placeholder="검색">
			
			</div>
		</div>
		<section class="section">
			<c:forEach var="dto" items="${list }">
				<div class="userbox">
					<div class="upunbox">
						<c:if test="${dto.user_photo!=null}">
							<div class="up">
								<a href="/user/mypage?user_num=${dto.user_num }"><img src="/photo/${dto.user_photo }" class="userphoto"></a>
							</div>
						</c:if>
	
						<c:if test="${dto.user_photo==null}">
							<div class="up">
								<a href="/user/mypage?user_num=${dto.user_num }"><img src="../image/noimg.png" class="userphoto"></a>
							</div>
						</c:if>
						<div class="un">
							<div style="display: inline-flex; flex-direction: column; ">
							<span style="font-size:13px; font-weight: bold;">${dto.user_name }</span>
							<c:if test="${dto.tf_count>0 }">
								<span class="tf" style="font-size: 8px;">함께아는친구: ${dto.tf_count }</span>
							</c:if>
							</div>
						</div>
					</div>
						
					<div class="btndiv">
							<button type="button" class="btn btn-outline-primary btn-lg addbtn" id="btn${dto.user_num }"
								user_num="${dto.user_num }">팔로워추가</button>
					</div>
				</div>

			</c:forEach>
		</section>
	</div>
</body>
</html>