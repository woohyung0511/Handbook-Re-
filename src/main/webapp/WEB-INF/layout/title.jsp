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
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script src="https://kit.fontawesome.com/d178b85e81.js" crossorigin="anonymous"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">

<style type="text/css">
.titlecontainer {
	width: 100%;
	display: inline-flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: nowrap;
	overflow: hidden;
}

.subtitlemenu {
	font-size: 12pt;
	line-height: 1.5em;
	padding-bottom: 30px;
	padding-top: 30px;
	display: inline-flex;
	flex-direction: column;
	justify-content: center;
	width: 200px;
	margin: 0 auto;
	margin-left: 25px;
}

.titledetail {
	margin-bottom: 10px;
	width: 150px;
	margin-bottom: 20px;
	cursor: pointer;	
}

.titledetail div {
	margin-right: 20px;
	
}

.stitle {
	position: absolute;
	z-index: 5;
	right: 0px;
	margin-right: 20px;
	margin-top: 10px;
}

.titlemenu div a {
	display: inline-flex;
	color: black;
	text-decoration: none;
	align-items: center;
}

.titlemenu {
	flex-direction: column;
	justify-content: center;
	display: inline-flex;
	background-color: white;
	box-shadow: 0px 0px 10px lightgray;
}

.titlecircle {
	width: 40px;
	height: 40px;
	border-radius: 100px;
	background-color: #F0F2F5;
	text-align: center;
	padding-left: 2px;
	padding-bottom: 3px;
	line-height: 45px;
	font-size: 15pt;
	overflow: hidden;
	cursor: pointer;
}

.tti{
	width: 40px;
	height: 40px;
	border-radius: 100px;
	background-color: #F0F2F5;
	text-align: center;
	font-size: 15pt;
	margin-left: 5px;
	overflow: hidden;
}

.subtitlemenu>span{
	font-size: 15pt;
	font-weight: bold;
	margin-bottom: 30px;
}
.btntti{
	border: 0;
	outline: 0;
	background: none;
}

.msgalarmcircle{
	width: 13px;
	height: 13px;
	border: 2px solid white;
	background-color: red;
	border-radius: 100px;
	position: absolute;
	right: 0px;
	margin-right: 115px;
	margin-bottom: 20px;
	visibility: hidden;
}

.allalarmcircle{
	width: 13px;
	height: 13px;
	border: 2px solid white;
	background-color: red;
	border-radius: 100px;
	position: absolute;
	right: 0px;
	margin-right: 70px;
	margin-bottom: 20px;
	visibility: hidden;
}

.msgalarmlist, .allalarmlist{
	width: 290px;
	height: 100%;
	margin: 0 auto;
	display: inline-flex;
	flex-direction: column;
	overflow: auto;
}

.msgalarmone{
	display: inline-flex;
	align-items: center;
	width: 280px;
	padding: 10px;
	margin: 0 auto;
	margin-top: 15px;
	border-radius: 10px;
	cursor: pointer;
}

.allalarmone{
	display: inline-flex;
	align-items: center;
	width: 270px;
	padding: 10px;
	margin: 0 auto;
	margin-top: 15px;
	border-radius: 10px;
	cursor: pointer;
}

.msgalarmone:hover{
	background-color: #F0F2F5;
}

.msgalarmphoto, .allalarmphoto{
	width: 60px;
	height: 60px;
	overflow: hidden;
	border-radius: 100px;
	margin-right: 15px;
}

.msgalarmphoto img, .allalarmphoto img{
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.msgalarmdetail, .allalarmdetail{
	display: inline-flex;
	flex-direction: column;
}

.msgalarcontent, .allalarmcontent{
	display: inline-flex;
	align-items: center;
	justify-content: flex-start;
	color: gray;
	font-size: 10pt;
}

.msgalarmname, .allalarmname{
	font-weight: bold;
	font-size: 12pt;
	margin-bottom: 2px;
}

.msgalarwrite, .allalarmrwrite2{
	margin-right: 10px;
	width: 110px;
	overflow: hidden;
	height: 20px;
}

.allalarmrwrite{
	margin-right: 10px;
	width: 160px;
}

.msgalarmheader, .allalarmheader{
	width: 100%;
	height: 60px;
	box-shadow: 0px 1px 3px lightgray;
	margin-bottom: 3px;
	text-align: center;
	line-height: 60px;
}

.msgalarmheader a{
	color: black;
	font-size: 12pt;
	font-weight: bold;
	text-decoration: none;
}

.ttiuphoto img{
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.readallalarm{
	font-size: 12pt;
	cursor: pointer;
}

</style>

<script type="text/javascript">

	var ws2;
	
	//웹소켓 오픈(메시지 알림)
	function wsOpen2(){
		ws2 = new WebSocket("ws://" + location.host + "/chating");
		wsEvt2();
	}
	
	function wsEvt2(){
		ws2.onopen = function(data) {
			//소켓이 열리면 초기화 세팅하기
			getMsgAlarm();
		}
	
		//메시지 잘 들어왔을 때 실행하는 내용
		ws2.onmessage = function(data){
			getMsgAlarm(); //메시지 개수 확인->알림표시
		}
	}

	$(function() {
		wsOpen2(); //웹소켓 열기
		
		$(".msgalarmshow").hide();
		$(".allalarmshow").hide();
		
		getMsgAlarm();
		
		searchWidhtChange();

		$(window).resize(function() {
			searchWidhtChange();
		})
		
		$(".ttimsg").click(function(){
			$(".msgalarmshow").toggle();
			$(".allalarmshow").hide();
			$(".allmenu").hide();
		})
		
		$(".ttialarm").click(function(){
			$(".allalarmshow").toggle();
			$(".msgalarmshow").hide();
			$(".allmenu").hide();
		})
		
		$(document).on("click",".msgalarmone",function(){
			location.href="../message/main?selgroup="+$(this).attr("group");
		})
		
		$(document).on("click",".readallalarm",function(){
			$.ajax({
				type:"get",
				dataType:"text",
				url:"../allalarmdelete",
				success:function(){
					$(".allalarmcircle").css("visibility","hidden");
					$(".allalarmlist").html("");
				}
			})
		})
		
		$(document).on("click",".allalarmone",function(){
			if($(this).attr("alarm_type")=="post"){
				if($(this).attr("guest_num")=="null"){
					location.href="../user/mypage?user_num=${sessionScope.user_num}&post_num="+$(this).attr("post_num");
				}
				
				else{
					location.href="../user/mypage?user_num=${sessionScope.user_num}&guest_num="+$(this).attr("guest_num");
				}
			}
			
			else if($(this).attr("alarm_type")=="comment"){
				location.href="../user/mypage?user_num=${sessionScope.user_num}&comment_num="+$(this).attr("comment_num");
			}
			
			else if($(this).attr("alarm_type")=="plike"){
				if($(this).attr("guest_num")=="null"){
					location.href="../user/mypage?user_num=${sessionScope.user_num}&post_num="+$(this).attr("post_num");
				}
				
				else{
					location.href="../user/mypage?user_num=${sessionScope.user_num}&guest_num="+$(this).attr("guest_num");
				}
			}
			
			else if($(this).attr("alarm_type")=="clike"){
				location.href="../user/mypage?user_num=${sessionScope.user_num}&comment_num="+$(this).attr("comment_num");
			}
			
		})
		
		$("#deleteuser").click(function(){
			var deletecheck=confirm("정말로 탈퇴하시겠습니까?");
			if(deletecheck)
				location.href="${root }/user/userdelete?user_num=${sessionScope.user_num}";
				
		})
	})

	function searchWidhtChange() {
		var windowWidth = $(window).width();

		if (windowWidth < 1000) {
			$(".searchpost").css("width", (windowWidth / 10));
			$(".searcharea").css("width", (windowWidth / 10) + 100);
			$(".titlelogo").hide();
		} else {
			$(".searchpost").css("width", (windowWidth / 3));
			$(".searcharea").css("width", (windowWidth / 3) + 100);
			$(".titlelogo").show();
		}
	}
	
	function getMsgAlarm(){
		var totalCount=0;
		var alarmCount=0;
		
		$.ajax({
			type:"get",
			dataType:"json",
			url:"../messagealarmget",
			success:function(res){
				totalCount=res.totalCount;
				alarmCount=res.alarmCount;
				
				if(totalCount>0){
					//알람이 있으면
					$(".msgalarmcircle").css("visibility","visible");
					
					var msgalist="";
					
					//메시지 알림 목록
					$.each(res.list,function(i,ele){
						msgalist+='<div class="msgalarmone" group='+ele.mess_group+'>';
						msgalist+='<div class="msgalarmphoto">';
						if(ele.sender_photo==null){
							msgalist+='<img alt="" src="/image/noimg.png">';
						}else{
							msgalist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
						}
						msgalist+='</div>';
						msgalist+='<div class="msgalarmdetail">';
						msgalist+='<span class="msgalarmname">'+ele.sender_name+'</span>';
						msgalist+='<div class="msgalarcontent">';
						msgalist+='<span class="msgalarwrite">'+ele.mess_content+'</span>';
						msgalist+='<span class="msgalartime">'+ele.mess_time+'</span>';
						msgalist+='</div>';
						msgalist+='</div>';
						msgalist+='</div>';
					})
					
					$(".msgalarmlist").html(msgalist);
				}
				
				if(alarmCount>0){
					//알람이 있으면
					$(".allalarmcircle").css("visibility","visible");
					
					var alarmlist="";
					
					//메시지 알림 목록
					$.each(res.alarmList,function(i,ele){
						//댓글 알림일 경우
						if(ele.type=="post"){
							alarmlist+='<div class="allalarmone" alarm_type="post" post_num='+ele.post_num+' guest_num='+ele.guest_num+'>';
							alarmlist+='<div class="allalarmphoto">';
							if(ele.sender_photo==null){
								alarmlist+='<img alt="" src="/image/noimg.png">';
							}else{
								alarmlist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
							}
							alarmlist+='</div>';
							alarmlist+='<div class="allalarmdetail">';
							alarmlist+='<span class="allalarmname">'+ele.sender_name+'</span>';
							alarmlist+='<div class="allalarmcontent">';
							alarmlist+='<span class="allalarmrwrite2">'+ele.comment_content+'</span>';
							alarmlist+='<span class="allalarmtime">'+ele.time+'</span>';
							alarmlist+='</div>';
							alarmlist+='</div>';
							alarmlist+='</div>';	
						}
						
						//답글 알림일 경우
						else if(ele.type=="comment"){
							alarmlist+='<div class="allalarmone" alarm_type="comment" comment_num='+ele.comment_num+'>';
							alarmlist+='<div class="allalarmphoto">';
							if(ele.sender_photo==null){
								alarmlist+='<img alt="" src="/image/noimg.png">';
							}else{
								alarmlist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
							}
							alarmlist+='</div>';
							alarmlist+='<div class="allalarmdetail">';
							alarmlist+='<span class="allalarmname">'+ele.sender_name+'</span>';
							alarmlist+='<div class="allalarmcontent">';
							alarmlist+='<span class="allalarmrwrite2">'+ele.comment_content+'</span>';
							alarmlist+='<span class="allalarmtime">'+ele.time+'</span>';
							alarmlist+='</div>';
							alarmlist+='</div>';
							alarmlist+='</div>';	
						}
						
						//팔로우 알림일 경우
						else if(ele.type=="follow"){
							alarmlist+='<div class="allalarmone" alarm_type="follow">';
							alarmlist+='<div class="allalarmphoto">';
							if(ele.sender_photo==null){
								alarmlist+='<img alt="" src="/image/noimg.png">';
							}else{
								alarmlist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
							}
							alarmlist+='</div>';
							alarmlist+='<div class="allalarmdetail">';
							alarmlist+='<span class="allalarmname">'+ele.sender_name+'</span>';
							alarmlist+='<div class="allalarmcontent">';
							alarmlist+='<span class="allalarmrwrite">회원님을 팔로우했습니다.</span>';
							alarmlist+='</div>';
							alarmlist+='</div>';
							alarmlist+='</div>';	
						}
						
						//게시글 좋아요 알림일 경우
						else if(ele.type=="plike"){
							alarmlist+='<div class="allalarmone" alarm_type="plike" post_num='+ele.post_num+' guest_num='+ele.guest_num+'>';
							alarmlist+='<div class="allalarmphoto">';
							if(ele.sender_photo==null){
								alarmlist+='<img alt="" src="/image/noimg.png">';
							}else{
								alarmlist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
							}
							alarmlist+='</div>';
							alarmlist+='<div class="allalarmdetail">';
							alarmlist+='<span class="allalarmname">'+ele.sender_name+'</span>';
							alarmlist+='<div class="allalarmcontent">';
							alarmlist+='<span class="allalarmrwrite">회원님의 게시글에 좋아요를 눌렀습니다.</span>';
							alarmlist+='</div>';
							alarmlist+='</div>';
							alarmlist+='</div>';	
						}
						
						//댓글 좋아요 알림일 경우
						else if(ele.type=="clike"){
							alarmlist+='<div class="allalarmone" alarm_type="clike" comment_num='+ele.comment_num
							+'>';
							alarmlist+='<div class="allalarmphoto">';
							if(ele.sender_photo==null){
								alarmlist+='<img alt="" src="/image/noimg.png">';
							}else{
								alarmlist+='<img alt="" src="/photo/'+ele.sender_photo+'">';
							}
							alarmlist+='</div>';
							alarmlist+='<div class="allalarmdetail">';
							alarmlist+='<span class="allalarmname">'+ele.sender_name+'</span>';
							alarmlist+='<div class="allalarmcontent">';
							alarmlist+='<span class="allalarmrwrite">회원님의 댓글에 좋아요를 눌렀습니다.</span>';
							alarmlist+='</div>';
							alarmlist+='</div>';
							alarmlist+='</div>';	
						}
						
						else if(ele.type="pass"){
							alarmlist+='<div class="allalarmone" style="background-color:#F0F2F5">';
							alarmlist+='<div style="text-align:center; width:100%; font-size:12pt;"><b>임시 비밀번호를 바꿔주세요!</b></div>'
							alarmlist+='</div>';	
						}
					})
					
					$(".allalarmlist").html(alarmlist);
				}
			}
		})
	}
</script>
</head>
<body>



<div class = "titlecontainer">

   <div style="width: 280px;" class="titlelogo"><a href = "${root }/"><img src="../image/handbooklogo.png" style = "height: 80px; "></a></div>
    <c:if test="${sessionScope.loginok != null }">
       <div class = "searcharea" style = "width:550px;  margin: 10px;">
         
               <div style = "width: 100%;background-color: white; display: inline-flex; align-items: center;">
               <select class = "form-control searchcolumn" style ="width:150px;" name = "searchcolumn">
               <option value = "user_name" ${searchcolumn=='user_name'?'selected':'' }>작성자</option>
               <option value = "post_content" ${searchcolumn=='post_content'?'selected':'' }>내용</option>
               </select>
               &nbsp;&nbsp;&nbsp;
               <div style="background-color: #F0F2F5; border-radius: 60px; display: inline-flex; align-items: center; padding-left: 2%">
                  <span class = "glyphicon glyphicon-search" style = "font-size: 16pt;"></span>
                  <input type = "text" name = "searchword" class="searchpost"
                  style = "width:500px; border: none; background: none; outline: none; font-size: 15pt; padding: 10px;" placeholder="Handbook 검색">
               </div>
               </div>                         
       
   </div> 

	<div style="display: inline-flex; overflow: hidden; align-items: center; justify-content: center; width: 280px;">
		<c:if test="${sessionScope.loginok!=null }">
    		<div class="titlecircle tti"><button type ="button" onclick="location.href='/login/logoutprocess'" class = "btntti"><img alt="" src="../image/logout.png" style="width: 23px; margin-bottom: 5px;"></button></div>
		</c:if>
		
		<div class="titlecircle tti"><span class = "glyphicon glyphicon-th titlemenubar" style="font-size: 15pt; color: black;"></span></div>
		<div class="titlecircle tti ttimsg"><span style="font-size: 15pt; color: black;"><i class="fa-regular fa-comment-dots"></i></span></div>
		<!-- 메시지 알림 개수 표시 시작 -->
		<div class="msgalarmcircle"></div>
		<!-- 메시지 알림 개수 표시 끝 -->
		
		<div class="titlecircle tti ttialarm"><span style="font-size: 15pt; color: black;"><i class="fa-solid fa-bell"></i></span></div>
		<!-- 메시지 알림 개수 표시 시작 -->
		<div class="allalarmcircle"></div>
		<!-- 메시지 알림 개수 표시 끝 -->
		
		<c:if test="${sessionScope.user_photo==null }">
		<div class="tti ttiuphoto"><a href="/user/mypage?user_num=${sessionScope.user_num }"><img src="../image/noimg.png" alt=""></a></div>
		</c:if>
		
		<c:if test="${sessionScope.user_photo!=null }">
		<div class="tti ttiuphoto"><a href="/user/mypage?user_num=${sessionScope.user_num }"><img src="../photo/${sessionScope.user_photo }" alt=""></a></div>
		</c:if>
	</div>
	 </c:if>

</div>
<div class = "stitle">
 	<div class = "titlemenu allmenu" style = "height:300px; width: 200px; border-radius: 10px;"> 
            <div class = "subtitlemenu">
               <span style="margin-bottom: 5px;">메뉴</span>
               
               <div class = "titledetail"><a data-toggle="modal" data-target="#contentwrite"><div class="titlecircle"><span class = "glyphicon glyphicon-check"></span></div><span>게시물 작성</span></a></div>
               <div class = "titledetail"><a href = "${root }/following/recommendlist?from_user=${sessionScope.user_num}"><div class="titlecircle"><span class = "glyphicon glyphicon-search"></span></div><span>친구 찾기</span></a></div>
               <div class = "titledetail"><a href = "${root }/post/bookmarktimeline"><div class="titlecircle"><span class = "glyphicon glyphicon-star"></span></div><span>즐겨 찾기</span></a></div>
               <div class = "titledetail" id="deleteuser"><a><div class="titlecircle"><i class="fa-solid fa-user-xmark"></i></div><span>회원탈퇴</span></a></div>
            </div>
            
	</div> 
</div>

<div class = "stitle">
 	<div class = "titlemenu msgalarmshow" style = "height:300px; width: 300px; border-radius: 10px;"> 
            <div class="msgalarmheader">
            	<a href="../message/main">메신저 보기</a>
            </div>
            <div class = "msgalarmlist">
            </div>
	</div> 
</div>

<div class = "stitle">
 	<div class = "titlemenu allalarmshow" style = "height:300px; width: 300px; border-radius: 10px;"> 
            <div class="allalarmheader">
            	<span class="readallalarm"><b>모두 비우기</b></span>
            </div>
            <div class = "allalarmlist">
            </div>
	</div> 
</div>

<script type="text/javascript">
   $(".allmenu").hide();
   $(".titlemenubar").click(function(){
      $(".allmenu").toggle();
      $(".msgalarmshow").hide();
      $(".allalarmshow").hide();
   });
   
   
   $(".searchpost").keyup(function(e){
      if(e.keyCode == 13){
         location.href="../post/timeline?searchcolumn="+$(".searchcolumn").val()+"&searchword="+$(".searchpost").val();
         
      }
      
   });
</script>
</body>