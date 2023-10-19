<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script type="text/javascript" src="/messagejscss/emoji_jk.js"></script>
<script src="https://kit.fontawesome.com/16085d762f.js"
	crossorigin="anonymous"></script>
<link href="/messagejscss/emoji_jk.css" type="text/css" rel="stylesheet">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap"
	rel="stylesheet">

<style type="text/css">
.messagecontainer {
	width: 100%;
	height: 100%;
}

.messagememberlist {
	width: 350px;
	min-width: 0px;
	height: 100%;
	position: fixed;
	overflow-y: scroll;
	overflow-x: hidden;
}

.messagechatlist {
	height: 100%;
	position: fixed;
	left: 350px;
	overflow-y: hidden;
	overflow-x: hidden;
}

.mmllisttop {
	margin-bottom: 20px;
}

.mmltitle {
	padding: 15px;
	display: inline-flex;
	align-items: center;
	justify-content: space-between;
	font-size: 15pt;
	width: 100%;
}

.mmlbtnbox {
	display: inline-flex;
	margin-bottom: 5px;
}

.mmlbtn {
	width: 35px;
	height: 35px;
	background-color: #F0F2F5;
	border-radius: 100px;
	line-height: 40px;
	text-align: center;
	margin-left: 10px;
	cursor: pointer;
}

.messagesearch {
	margin: 0 auto;
	background-color: #F0F2F5;
	border-radius: 100px;
	width: 95%;
	height: 35px;
	line-height: 35px;
	padding-left: 15px;
}

.messagesearch input {
	height: 90%;
	width: 90%;
	background: none;
	border: none;
	outline: none;
}

.messagememberphoto {
	width: 65px;
	height: 65px;
	overflow: hidden;
	border-radius: 100px;
	text-align: center;
}

.messagememberphoto img {
	height: 100%;
	width: 100%;
	object-fit:cover; /* 상위 div 안에 꽉차게 */
}

/* 채팅했던 멤버 */
.messagmember {
	padding-left: 15px;
	padding: 15px;
	width: 350px;
	position: fixed;
	overflow: auto;
	/*overflow-y: hidden;
	overflow-x: hidden;*/
}

.onemember {
	display: inline-flex;
	width: 98%;
	margin-bottom: 10px;
	cursor: pointer;
	padding: 5px;
}

.messageactive {
	background-color: #DFEFFF;
	border-radius: 5px;
}

.messagememberinfo {
	width: 250px;
	margin-left: 10px;
	margin-top: 10px;
	display: inline-flex;
	flex-direction: column;
}

.membername {
	font-size: 13pt;
	margin-bottom: 5px;
	width: 90%;
	overflow: hidden;
}

.chatdetail {
	width: 95%;
	display: inline-flex;
	justify-content: space-between;
}

.chatdetaildate {
	margin-right: 5px;
}

.chatinfo {
	width: 100%;
	height: 70px;
	background-color: white;
	box-shadow: 5px 2px 3px #F0F2F5;
	display: inline-flex;
	align-items: center;
	font-weight: bold;
	font-size: 12pt;
	position: inherit;
	top: 0;
	margin-top: 80px;
}

.chatinfophoto {
	width: 45px;
	height: 45px;
	overflow: hidden;
	border-radius: 100px;
	margin-left: 15px;
	margin-right: 10px;
	cursor: pointer;
}

.chatinfophoto img {
	height: 45px;
	height: 100%;
	width: 100%;
	object-fit:cover; /* 상위 div 안에 꽉차게 */
}

.chatlist {
	position: fixed;
	margin-top: 70px;
	margin-bottom: 55px;
	overflow-y: scroll;
	overflow-x: hidden;
	display: inline-flex;
	flex-direction: column;
	align-items: center;
}

.messagefooter {
	background: white;
	height: 55px;
	position: inherit;
	bottom: 0;
	display: inline-flex;
	align-items: center;
	padding-left: 10px;
}

.chatinputbox {
	width: 88%;
	height: 35px;
	line-height: 35px;
	background-color: #F0F2F5;
	border-radius: 60px;
	text-align: center;
	margin-left: 10px;
	margin-right: 10px;
}

.chatinputbox input {
	width: 95%;
	background: none;
	border: none;
	outline: none;
}

.chatShow {
	display: inline-flex;
	flex-direction: column;
	width: 98%;
	align-items: center;
}

.messagebubble {
	margin: 10px;
	max-width: 400px;
	overflow: hidden;
	border: none;
}

.messagebubble a{
	text-decoration: none;
}

.messagebubble .bubblecontent{
	padding: 10px 15px 10px 15px;
}

.messagebubble img{
	width: 100%;
	height: 100%;
	object-fit:cover;
	cursor: pointer;
}

.msgright {
	align-self: flex-end;
	display: inline-flex;
	align-items: center;
}

.messageright {
	border-radius: 90px 90px 10px 90px;
}

.messageright .bubblecontent{
	background-color: #3582D3;
	color: white;
}

.messageright .bubblecontent a{
	color: white;
}

.msgleft {
	align-self: flex-start;
	display: inline-flex;
	align-items: center;
}

.messageleft {
	border-radius: 90px 90px 90px 10px;
}

.messageleft .bubblecontent{
	background-color: #F0F2F5;
}

.messageleft .bubblecontent a{
	color: black;
}

.msgdel {
	font-size: 10pt;
	color: gray;
	margin-top: 10%;
	cursor: pointer;
}

.msgtime{
	font-size: 8pt;
}

.msgsubmenu{
	color: gray;
	display: inline-flex;
	flex-direction: column;
	visibility: hidden;
}

.leftreceiverphoto{
	width: 45px;
	height: 45px;
	min-width: 45px;
	min-height: 45px;
	border-radius: 100px;
	overflow: hidden;
}

.leftreceiverphoto img {
	height: 100%;
	width: 100%;
	object-fit:cover; /* 상위 div 안에 꽉차게 */
}

.chatlistinfo {
	display: inline-flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	margin: 60px 0px 60px 0px;
}

.chatlistinfo div {
	width: 60px;
	height: 60px;
	border-radius: 100px;
	overflow: hidden;
}

.chatlistinfo img {
	height: 100%;
	width: 100%;
	object-fit:cover;
	cursor: pointer;
}

.chatlistinfoname {
	font-weight: bold;
	font-size: 14pt;
	margin-top: 10px;
}

.chatlistinfoid {
	font-size: 13pt;
	margin-top: 5px;
	color: lightgray;
}

.chatupload {
	font-size: 18pt;
	display: flex;
	align-items: center;
}

.chatuploadicon {
	cursor: pointer;
	color: #3582D3;
}

span.msgaddname {
	margin-left: 15px;
}

input.msgaddname {
	margin-left: 10px;
	width: 50%;
	outline: none;
	border: none;
	background: none;
}

div.msgsearchuser {
	position: absolute;
	z-index: 10;
	width: 300px;
	height: 500px;
	overflow: auto;
	box-shadow: 0px 0px 10px lightgray;
	background-color: white;
	display: none;
	flex-direction: column;
}

.msgserachuserone {
	margin-left: 15px;
	width: 250px;
	display: inline-flex;
	align-items: center;
	margin-top: 10px;
	cursor: pointer;
	padding: 3px;
	border-radius: 10px;
}

.msgserachuserone:hover {
	background-color: #DFEFFF;
}

.msgserachuserone span {
	margin-left: 5px;
}

.searchuid {
	color: gray;
	font-size: 8pt;
}

.searchuphoto {
	width: 40px;
	height: 40px;
	border: none;
	border-radius: 100px;
	overflow: hidden;
	text-align: center;
}

.searchuphoto img {
	height: 100%;
	width: 100%;
	object-fit:cover;
}

#sendBtn {
	border: none;
	outline: none;
	background: none;
	font-size: 15pt;
	color: #3582D3;
	margin-right: 5px;
}

.messagefilepreview {
	position: inherit;
	background: white;
	box-shadow: 0px 0px 10px lightgray;
	border-bottom: 1px solid lightgray;
	width: 100%;
	height: 100px;
	display: inline-flex;
	align-items: center;
	bottom: 0;
	margin-bottom: 55px;
	z-index: 5p;
	/* display: none; */
}

.messagefilepreview div{
	height: 75px;
	margin: 0 auto;
	margin-left: 15px;
	display: inline-flex;
	align-items: flex-end;
}

.messagefilepreview img{
	height: 75px;
}

.messagefilepreview span{
	cursor: pointer;
}

.recentchat{
	width: 130px;
	overflow: hidden;
}

.recentchat img{
	height: 80px;
}

.mmiheader{
	display: inline-flex;
	justify-content: space-between;
	width: 95%;
}

.memberlistmenu{
	cursor: pointer;
}

.messgroupdel{
	width: 150px;
	height: 60px;
	background-color: white;
	box-shadow: 0px 0px 3px lightgray;
	position: inherit;
	left: 170px;
	margin-top: -130px;
	z-index: 5;
	line-height: 60px;
	padding-left: 15px;
	border-radius: 10px;
}

.messgroupdelicon{
	width: 120px;
	cursor: pointer;
	font-size: 12pt;
	z-index: 10;
}
</style>

<script type="text/javascript">
	$(function() {
		wsOpen();
		listWidthChange();
		memberListOut();
		getChatting('${recentgroup}');
		$(".messagefilepreview").hide();
		$(".ttimsg").hide();
		$(".msgalarmcircle").hide();
		$(".allalarmcircle").css("margin-right","95px");
		
		//상단의 채팅중인 사람 num 변경
		$(".chatinfophoto").attr("memeber_num", "${otherinfo.user_num}");
		//상단의 채팅중인 사람 이름 변경
		$(".chatinfo span").text('${otherinfo.user_name}');
		//상단의 채팅중인 사람 아이디 변경
		$(".chatinfo span").attr("memeber_id", '${otherinfo.user_id}');
		//상단의 채팅중인 사람 이미지 변경
		if ('${otherinfo.user_photo}' == null
				|| '${otherinfo.user_photo}' == '') {
			$(".chatinfophoto img").attr("src", '/image/noimg.png');
		} else {
			$(".chatinfophoto img").attr("src",
					'/photo/' + '${otherinfo.user_photo}');
		}

		$(window).resize(function() {
			//창크기 변화 감지
			listWidthChange();
		});
		
		//이미지 클릭시 해당 유저의 마이페이지로 이동
		$(document).on("click",".chatinfophoto",function(){
			location.href='../user/mypage?user_num='+$(this).attr("memeber_num");
		})
		
		//이미지 클릭시 해당 유저의 마이페이지로 이동2
		$(".chatlistinfo img").click(function(){
			location.href='../user/mypage?user_num='+$(".chatinfophoto").attr("memeber_num");
		})
		
		//채팅 이미지 누르면 새탭에서 원본 나오기
		$(document).on("click",".messagebubble img",function(){
			window.open($(this).attr("src"));
		})
		
		$(document).on("click",".memberlistmenu",function(){
			var group=$(this).parents(".onemember").attr("mess_group");
			//var isdel=confirm("해당 대화를 삭제하겠습니까?");
			
			//삭제 메뉴창 열기
			$(".messgroupdel").each(function(i,ele){
				if($(".messgroupdelicon").eq(i).attr("mess_group")==group){
					$(ele).toggle();
				}else{
					$(ele).hide();
				}
			})
			
			
			
			/*
			if(isdel){
				$.ajax({
					type:"get",
					dataType:"text",
					url:"deletegroup",
					data:{"mess_group":group},
					success:function(){
						location.reload();
					}
				})
			} */
		})
		
		$(document).on("click",".messgroupdelicon",function(){
			var isdel=confirm("해당 대화를 삭제하겠습니까?");
			
			if(isdel){
				$.ajax({
					type:"get",
					dataType:"text",
					url:"deletegroup",
					data:{"mess_group":$(this).attr("mess_group")},
					success:function(){
						location.reload();
					}
				})
			}
		})

		//메신저 검색
		$(".messagesearch input").keyup(
				function() {
					setTimeout(function() {
						//메신저 검색이 입력됐을 때 현재 other_name에 저장된 이름과 같으면 실앵하지 않는다
						if (other_name != ''
								&& other_name == $(".messagesearch input")
										.val()) {
							return;
							consol.log($(this).val());
						} else {
							memberListOut();
						}
					}, 500);
				});

		//왼쪽의 채팅방 목록(멤버 목록)을 클릭하면 오른쪽의 채팅화면이 바뀐다.
		$(document).on("click",".onemember",function(e) {
				if($(e.target).hasClass("memberlistmenu")){
					return
				}
			
				//선택된 채팅방 변경
				$(".onemember").each(function(i, ele) {
					$(ele).removeClass("messageactive");
				})
				$(this).addClass("messageactive");

				var mess_group = $(this).attr("mess_group");
				var user_name = $(this).find(".membername").text();
				var user_photo = $(this).find(".messagememberphoto img").attr("src");
				var member_id = $(this).find(".membername").attr("member_id");
				var member_num = $(this).attr("member_num");

				if ($(this).hasClass("newmsg")) {
					var img = $(this).find("img").attr("src");
					var name = $(this).find(".membername").attr("uname");
					var id = $(this).find(".membername").attr("uid");

					$("#chatShow").html("");
					$(".chatlistinfo img").attr("src", img);
					$(".chatlistinfoname").text(name);
					$(".chatlistinfoid").text(id);

					setUserInfo(img, id, name, member_num);

					//받는 사람 변경
					$("#receivernum").val($(this).attr("member_num"));
					//그룹 변경
					$("#chatgroup").val(mess_group);
				} else {
					//받는 사람 변경
					$("#receivernum").val($(this).attr("member_num"));
					//그룹 변경
					$("#chatgroup").val(mess_group);

					//상단의 채팅중인 사람 이름 변경
					$(".chatinfo span").text(user_name);
					//상단의 채팅중인 사람 아이디 변경
					$(".chatinfo span").attr("memeber_id", member_id);
					//상단의 채팅중인 사람 num 변경
					$(".chatinfophoto").attr("memeber_num", member_num);
					//상단의 채팅중인 사람 이미지 변경
					$(".chatinfophoto img").attr("src", user_photo);
					//우측의 채팅중인 화면 변경(대화내용 변경)
					getChatting(mess_group);
				}
			})

		$(document).on('mouseover', '.msgone', function() {
			$(this).find(".msgsubmenu").css("visibility", "visible");
		})
		$(document).on('mouseout', '.msgone', function() {
			$(this).find(".msgsubmenu").css("visibility", "hidden");
		})

		//채팅 삭제
		$(document).on('click', '.msgdel', function() {
			$.ajax({
				type : "get",
				dataType : "text",
				url : "delete",
				data : {
					"mess_num" : $(this).attr("del")
				},
				success : function() {
					var group = $("#chatgroup").val();
					var scrollPos = $(".chatlist")[0].scrollTop; //삭제 눌렀을 시점의 스크롤 위치

					getChatting(group, scrollPos); //채팅 다시 불러오기(삭제된 거 적용)
				}
			})
		})

		//사진 업로드
		$(".chatuploadicon").click(function() {
			$(".chatupload input").trigger("click");
		})

		//사진 선택 <--여기서부터~!
		$("#msgfileupload").change(function(event) {
			var input=event.target;
			
			//미리보기 띄우기
			if (input.files && input.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					$(".messagefilepreview").show();
					var out="<div><img src='"+e.target.result+"'>";
					out+="<span class='glyphicon glyphicon-remove fileselcancel'></div>"
					$(".messagefilepreview").html(out);
				};
				reader.readAsDataURL(input.files[0]);
			} else {
				out="";
			}
		})
		
		//사진 선택 취소
		$(document).on("click",".fileselcancel",function(){
			$(".messagefilepreview").hide();
			$("#msgfileupload").val(null);
		})
		

		//채팅방 추가(받는 사람 입력창 띄우기)
		$(".msgadd").click(function(){
			if($(".msgsearchuser").css("display")!="none"){
				//이미 검색창이 열려있다면 닫기
				$(".msgsearchuser").css("display", "none");

				var img = $(".messageactive").find("img").attr("src");
				var id = $(".messageactive").find(".membername").attr("member_id");
				var name = $(".messageactive").find(".membername").attr("uname");
				var num = $(".messageactive").attr("member_num");
				setUserInfo(img, id, name, num);
			}else{
				//검색창이 안 열려있다면 띄우기
				s = "<span class='msgaddname'>받는 사람:</span><input type='text' class='msgaddname'>";
				$(".chatinfo").html(s);
				var position = $('.msgaddname').position();
				$('.msgsearchuser').css("left", position.left + 60);
				$('.msgsearchuser').css("top", position.top + 30);
				$('.msgsearchuser').css("display", "inline-flex");
				$("input.msgaddname").focus();
			}
		})

		//->창 외부 클릭시 숨기기
		$('body').click(function(e) {
			var container = $(".msgsearchuser");

			if (container.css("display") != "none") {
				if (!$(e.target).hasClass('msgsearchuser')
						&& !$(e.target).hasClass('msgadd')
						&& !$(e.target).hasClass('msgaddicon')
						&& !$(e.target).hasClass('msgaddname')
						&& !$(e.target).hasClass('msgsearchuser')
						&& !$(e.target).hasClass('msgsearchuserone')) 
				{
					container.css("display", "none");

					var img = $(".messageactive").find("img").attr("src");
					var id = $(".messageactive").find(".membername").attr("member_id");
					var name = $(".messageactive").find(".membername").attr("uname");
					var num = $(".messageactive").attr("member_num");
					setUserInfo(img, id, name, num);
				}
			}
		})

		//->채팅방 추가에서 받는 사람 입력창 이벤트
		$(document).on('keyup','input.msgaddname',function(e) {
			var addName = $(this).val(); //검색한 (추가할)사람 이름
			$.ajax({
				type : "get",
				dataType : "json",
				data : {"user_name" : addName},
				url : "searchuser",
				success : function(res) {
					var users = "";
					$.each(res,function(i, ele) {
						users += "<div class='msgserachuserone'><div class='searchuphoto'>";
						if (ele.user_photo == null) {
							users += "<img src='/image/noimg.png'>";
							} else {
								users += "<img src='/photo/"+ele.user_photo+"'>";
								}
						users += "</div><span class='searchuname'>"+ ele.user_name + "</span>";
						users += "<span class='searchuid'>"+ ele.user_id + "</span>";
						users += "<input type='hidden' value="+ele.user_num+">";
						users += "</div>";
						})
						$('.msgsearchuser').html(users);
					}
				})
			})

		//-->검색한 사람 클릭했을 때 받는 사람에 넣기
		$(document).on("click",".msgserachuserone",function() {
			var name = $(this).find(".searchuname").text();
			var id = $(this).find(".searchuid").text();
			$("input.msgaddname").val(name + "(" + id + ")");
			var img = $(this).find("img").attr("src");
			var name = $(this).find(".searchuname").text();
			var id = $(this).find(".searchuid").text();
			var num = $(this).find("input").val();
			var group=0;
			
			//새그룹 받아오기 << 이미 채팅을 한 사람이라면 그 채팅에 그대로 추가됨!
			$.ajax({
				type : "get",
				dataTyep : "json",
				data : {"other":num},
				url : "newgroup",
				success : function(res) {
					group = res.group; //새그룹 or 기존 그룹
					$("#chatgroup").val(group); //그룹 변경
				
				if (!$(".messagmember").find(".onemember").hasClass("newmsg")) {
					//새로운 채팅을 이미 선택했는지 확인 
					// 1.이미 선택했다면: 교체, 2.선택된 게 없다면 새로 생성(이 if문 안은 2번의 경우)
					$(".messagmember").find(".messageactive").removeClass("messageactive");
	
					var out = "";
					var msgmember = $(".messagmember").html();
	
					out += '<div class="onemember messageactive newmsg" member_num='+num+' mess_group='+group+'>';
					out += '<div class="messagememberphotobox">';
					out += '<div class="messagememberphoto">';
					out += '<img alt="사용자사진(없음)" src="' + img
											+ '">';
					out += '</div>';
					out += '</div>';
					out += '<div class="messagememberinfo">';
					out += '<span class="membername" uname='+name+' uid='+id+'>새메시지 입력</span>';
					out += '<div class="chatdetail">';
					out += '<span class="recentchat"></span>';
					out += '<span class="chatdetaildate"></span>';
					out += '</div></div></div>'
					
					$(".messagmember").html(out + msgmember);
					} else { //1번의 경우(선택된 게 있을 경우 값만 변경)
						$(".newmsg").find("img").attr("src", img);
						$(".newmsg").attr("member_num", num);
						$(".newmsg").find(".membername").attr("uname",name);
						$(".newmsg").find(".membername").attr("uid", id);
					}
				
					$("#chatShow").html("");
					$(".chatlistinfo img").attr("src", img);
					$(".chatlistinfoname").text(name);
					$(".chatlistinfoid").text(id);
					
					setUserInfo(img, id, name, num);
		
					//받는 사람 변경
					$("#receivernum").val(num);
				}
			})
		})
		
		if("${search_name}"!=""){
			setTimeout(function(){
				$(".msgadd").trigger("click");
				$("input.msgaddname").val("${search_name}");
				
				var addName = "${search_name}"; //검색한 (추가할)사람 이름
				$.ajax({
					type : "get",
					dataType : "json",
					data : {"user_name" : addName},
					url : "searchuser",
					success : function(res) {
						var users = "";
						$.each(res,function(i, ele) {
							users += "<div class='msgserachuserone'><div class='searchuphoto'>";
							if (ele.user_photo == null) {
								users += "<img src='/image/noimg.png'>";
								} else {
									users += "<img src='/photo/"+ele.user_photo+"'>";
									}
							users += "</div><span class='searchuname'>"+ ele.user_name + "</span>";
							users += "<span class='searchuid'>"+ ele.user_id + "</span>";
							users += "<input type='hidden' value="+ele.user_num+">";
							users += "</div>";
							})
							$('.msgsearchuser').html(users);
						
							$.each($(".msgserachuserone"),function(i,ele){
								if($(".msgserachuserone input").eq(i).val()=="${search_num}"){
									$(ele).trigger("click");
								}
							})
						}
					})
			},300)
		}

	})

	//상단의 사용자 정보 재출력
	function setUserInfo(img, id, name, num) {
		var info = ""

		info += '<div class="chatinfophoto" memeber_num='+num+'>';
		info += '<img alt="" src="'+img+'">';
		info += '</div>';
		info += '<span member_id="'+id+'">' + name + '</span>';

		$(".chatinfo").html(info);
	}

	//상대방과 해던 채팅 가져오기
	function getChatting(group, scrollPos) {

		if ('${recentgroup}' == 0) {
			return;
		}

		$.ajax({
			type : "get",
			dataType : "json",
			url : "chatting",
			data : {"mess_group" : group},
			success : function(res) {
				var chatContent = "";
				//현재 선택한 대화 상대의 사진 가져오기
				var otherImg = $(".chatinfophoto img").attr("src");
				$.each(res,function(i, ele) {
					if (ele.sender_num == '${user_num}') {
						chatContent += "<div class='msgright msgone'>";
						chatContent += "<div class='msgsubmenu'>";
						chatContent+="<div class='msgright msgtime'>"+ele.mess_time+"</div>";
						chatContent += "<div class='msgdel' del="+ele.mess_num+">삭제</div>";
						chatContent += "</div>";
						chatContent += "<div class='messageright messagebubble'>"+ ele.mess_content+ "</div></div>";
					} else {
						chatContent += "<div class='msgleft msgone'>";
						chatContent += "<div class='leftreceiverphoto'><img src='"+otherImg+"'></div>";
						chatContent += "<div class='messageleft messagebubble'>"+ ele.mess_content+"</div>";
						chatContent += "<div class='msgsubmenu'>";
						chatContent+="<div class='msgleft msgtime'>"+ele.mess_time+"</div>";
						chatContent += "</div></div>";
					}
				})
				
				$(".chatlistinfo img").attr("src", otherImg);
				$(".chatlistinfoname").text($(".chatinfo span").text());
				$(".chatlistinfoid").text($(".chatinfo span").attr("memeber_id"));

				$("#chatShow").html(chatContent);

				if (scrollPos == null) {
					setTimeout(function(){
						$(".chatlist").scrollTop($(".chatlist").prop('scrollHeight'));
					},300)
					//$(".chatlist").scrollTop($(".chatlist")[0].scrollHeight); //스크롤 맨 아래로 내리기	
				} else {
					setTimeout(function(){
						$(".chatlist").scrollTop(scrollPos);
					},300)
				}
			}
		})
	}

	//반응형 웹사이트
	function listWidthChange() {
		var windowWidth = $(window).width();
		var windowHeight = $(window).height();
		var listWidht = ((windowWidth - 350) / windowWidth) * 100;

		var chatlistheight = $(".messagechatlist").css("height");
		chatlistheight = chatlistheight.substring(0, chatlistheight.length - 2);
		var chatHeight = (chatlistheight - 205);

		if (windowWidth < 600) {
			$(".messagememberlist").hide();
			$(".messagechatlist").css("left", "0px");
			$(".messagefooter").css("left", "0px");
			listWidht = 100;
		} else {
			$(".messagememberlist").show();
			$(".messagechatlist").css("left", "350px");
			$(".messagefooter").css("left", "350px");
		}

		$(".messagechatlist").css("width", listWidht + "%");
		$(".messagefooter").css("width", listWidht + "%");
		$(".chatlist").css("width", listWidht + "%");
		$(".chatlist").css("height", chatHeight + "px");
		$(".messagmember").css("height",chatHeight+"px");
	}

	var other_name = ''; //메신저 검색에 입력되는 사용자 이름(저장변수)

	//나와 채팅했던 사용자 목록 출력
	function memberListOut() {

		if ('${recentgroup}' == 0) {
			return;
		}

		other_name = $(".messagesearch input").val();

		$.ajax({
			type : "get",
			dataType : "json",
			url : "memberlist",
			data : {"other_name" : other_name},
			success : function(chatMember) {
				var out = "";
				$.each(chatMember,function(i, chat) {
					if ($("#chatgroup").val() == chat.group) {
						//선택된 채팅방이면 messageactive class를 추가한다.
						out += '<div class="onemember messageactive" mess_group='+chat.group+' member_num='+chat.member_num+'>';
						} else {
							//선택되지 않은 채팅방
							out += '<div class="onemember" mess_group='+chat.group+' member_num='+chat.member_num+'>';
						}
					out += '<div class="messagememberphotobox">';
					out += '<div class="messagememberphoto">';
					if (chat.member_photo == null || chat.member_photo == '') {
						out += '<img alt="사용자사진(없음)" src="/image/noimg.png">';
					} else {
						out += '<img alt="사용자사진" src="/photo/'+chat.member_photo+'">';
					}
					out += '</div>';
					out += '</div>';
					out += '<div class="messagememberinfo">';
					out += '<div class="mmiheader">';
					out += '<span class="membername" member_id='+chat.member_id+' uname='+chat.member_name+'>'
						+ chat.member_name
						+ '</span>';
					out += "<div class='memberlistmenucircle'>"
					out += '<span class="glyphicon glyphicon-option-horizontal memberlistmenu"></span>'
					out += '</div>';
					out += '</div>';
					out += '<div class="chatdetail">';
					out += '<span class="recentchat">'+ chat.content + '</span>';
					out += '<span class="chatdetaildate">'+ chat.writeday + '</span>';
					out += '</div></div></div>'		
					
					out += '<div class="messgroupdel">';
					out += '<div class="messgroupdelicon" mess_group='+chat.group+'>';
					out += '<span class="glyphicon glyphicon-trash"></span>';
					out += '<span>삭제</span></div></div>';
				})
				
				if (out == "") {
					out = "<span>검색결과가 없습니다</sapn>"
				}

				$(".messagmember").html(out);
				//왼쪽의 채팅방 목록(멤버 목록)을 클릭하면 오른쪽의 채팅화면이 바뀐다.
				
				$(".messgroupdel").hide();
			}
		})
	}

	var ws;

	//웹소켓 오픈
	function wsOpen() {
		ws = new WebSocket("ws://" + location.host + "/chating");
		wsEvt();
	}

	function wsEvt() {
		ws.onopen = function(data) {
			//소켓이 열리면 초기화 세팅하기
		}
	
		//메시지 잘 들어왔을 때 실행하는 내용
		ws.onmessage = function(data) {
			var msg = data.data;
			var msgJson=JSON.parse(msg)

			var nowGroup = $("#chatgroup").val(); //현재 선택된 채팅방 그룹 */

			if (msgJson.upload != null && msgJson.upload != '' && '${user_num}' == msgJson.receiver) {

				if (msgJson.group == nowGroup) {
					getChatting(nowGroup);
				}

				memberListOut();//멤버 리스트 다시 불러오기
			}
			
		}

		//채팅 입력창에서 엔터 누르면 채팅 보내짐
		$("#chatting").keyup(function(e) {
			if (e.keyCode == 13) { //enter press
				if ($("#chatting").val() != '') {
					send();
				}
			}
		});
	}

	//메시지 보내면 동작하는 코드
	function send() {
		var mynum = '${sessionScope.user_num}';
		var msg = $("#chatting").val();
		var group = $("#chatgroup").val();
		
		//만약 사진을 선택하지 않았다면
		if(!$("#msgfileupload").val()){
			ws.send("{\"mynum\":\""+mynum+"\",\"upload\":\""+msg+"\",\"receiver\":\""+$("#receivernum").val()
					+"\",\"group\":\""+group+"\",\"type\":\"chat\"}");
		}else{
			//사진부터 업로드...
			var form=new FormData();
			form.append("upload",$("#msgfileupload")[0].files[0]); //선택한 1개만 추가
			
			$.ajax({
				type:"post",
				dataType:"json",
				url:"fileupload",
				processData:false,
				contentType:false,
				data:form,
				success:function(res){
					ws.send("{\"mynum\":\""+mynum+"\",\"upload\":\""+res.upload+"\",\"receiver\":\""+$("#receivernum").val()
						+"\",\"group\":\""+group+"\",\"type\":\"img\"}");
					
					/* ws.send(myid + " : " + res.upload + " : " + $("#receivernum").val() + " : " 
							+ group + " : " + "img"); */
					$(".messagefilepreview").hide();
					$("#msgfileupload").val(null);
				}
			})
			
			//메시지도 적었다면 한 번 더 전송
			if(msg!=""){
				ws.send("{\"mynum\":\""+mynum+"\",\"upload\":\""+msg+"\",\"receiver\":\""+$("#receivernum").val()
						+"\",\"group\":\""+group+"\",\"type\":\"chat\"}");
			}
		}
		
		//알림전송
		$.ajax({
			type:"get",
			dataType:"text",
			data:{"other":$("#receivernum").val(),"group":group},
			url:"../messagealaramadd",
			success:function(){
				
			}
		})

		$('#chatting').val("");

		getChatting(group);

		memberListOut(); //멤버 리스트 다시 불러오기
	}
</script>
</head>
<body>
	<div class="messagecontainer">
		<div class="messagememberlist">
			<div class="mmllisttop">
				<div class="mmltitle">
					<span style="font-size: 20pt"><b>채팅</b></span>
					<div class="mmlbtnbox">
						<!-- <div class="mmlbtn">
							<span class="glyphicon glyphicon-option-horizontal"></span>
						</div> -->
						<div class="mmlbtn msgadd">
							<span class="glyphicon glyphicon-edit msgaddicon"></span>
						</div>
					</div>
				</div>
				<div class="messagesearch">
					<span class="glyphicon glyphicon-search"></span> <input type="text"
						placeholder="Messenger 검색">
				</div>
			</div>
			<div class="messagmember">
			</div>
		</div>

		<div class="messagechatlist">
			<div class="chatinfo">
				<c:if test="${recentgroup!=0 }">
					<div class="chatinfophoto" member_num="${otherInfo.user_num }">
						<c:if test="${otherInfo.user_photo==null }">
							<img alt="" src="/image/noimg.png">
						</c:if>
						<c:if test="${otherInfo.user_photo!=null }">
							<img alt="" src="/photo/${otherInfo.user_photo }">
						</c:if>
					</div>
					<span member_id="${otherInfo.user_id }">${otherInfo.user_name }</span>
				</c:if>
			</div>

			<div class="msgsearchuser"></div>

			<div class="chatlist">
				<div class="chatlistinfo">
					<c:if test="${recentgroup!=0 }">
						<div>
							<img alt="상대방 사진" src="">
						</div>
						<span class="chatlistinfoname"></span>
						<span class="chatlistinfoid"></span>
						<p class="chatlistinfofollow"></p>
					</c:if>
				</div>
				<div id="chatShow" class="chatShow">
					<!-- 채팅 보이는 구간 -->
				</div>
			</div>

			<div class="messagefilepreview"></div>

			<div class="messagefooter">
				<!-- 이모지 시작-->
				<div class="chatemoji">
					<img class="emoji_pickup" id="emoji_pickup_before"
						src="/messagejscss/img/emoji/1f642.png"> <img
						class="emoji_pickup" id="emoji_pickup_after"
						src="/messagejscss/img/emoji/1f600.png">

					<div id="emoji_popup">
						<!-- emoji popup div start -->
						<div id="people">
							<h5>People</h5>
						</div>
						<span class="emoji_list" id="&#x1F601;">&#x1F601;</span> <span
							class="emoji_list" id="&#x1F602;">&#x1F602;</span> <span
							class="emoji_list" id="&#x1F603;">&#x1F603;</span> <span
							class="emoji_list" id="&#x1F604;">&#x1F604;</span> <span
							class="emoji_list" id="&#x1F605;">&#x1F605;</span> <span
							class="emoji_list" id="&#x1F606;">&#x1F606;</span> <span
							class="emoji_list" id="&#x1F609;">&#x1F609;</span> <span
							class="emoji_list" id="&#x1F60A;">&#x1F60A;</span> <span
							class="emoji_list" id="&#x1F60B;">&#x1F60B;</span> <span
							class="emoji_list" id="&#x1F60C;">&#x1F60C;</span> <span
							class="emoji_list" id="&#x1F60D;">&#x1F60D;</span> <span
							class="emoji_list" id="&#x1F60F;">&#x1F60F;</span> <span
							class="emoji_list" id="&#x1F612;">&#x1F612;</span> <span
							class="emoji_list" id="&#x1F613;">&#x1F613;</span> <span
							class="emoji_list" id="&#x1F614;">&#x1F614;</span> <span
							class="emoji_list" id="&#x1F616;">&#x1F616;</span> <span
							class="emoji_list" id="&#x1F618;">&#x1F618;</span> <span
							class="emoji_list" id="&#x1F61A;">&#x1F61A;</span> <span
							class="emoji_list" id="&#x1F61C;">&#x1F61C;</span> <span
							class="emoji_list" id="&#x1F61D;">&#x1F61D;</span> <span
							class="emoji_list" id="&#x1F61E;">&#x1F61E;</span> <span
							class="emoji_list" id="&#x1F620;">&#x1F620;</span> <span
							class="emoji_list" id="&#x1F621;">&#x1F621;</span> <span
							class="emoji_list" id="&#x1F622;">&#x1F622;</span> <span
							class="emoji_list" id="&#x1F623;">&#x1F623;</span> <span
							class="emoji_list" id="&#x1F624;">&#x1F624;</span> <span
							class="emoji_list" id="&#x1F625;">&#x1F625;</span> <span
							class="emoji_list" id="&#x1F628;">&#x1F628;</span> <span
							class="emoji_list" id="&#x1F629;">&#x1F629;</span> <span
							class="emoji_list" id="&#x1F62A;">&#x1F62A;</span> <span
							class="emoji_list" id="&#x1F62B;">&#x1F62B;</span> <span
							class="emoji_list" id="&#x1F62D;">&#x1F62D;</span> <span
							class="emoji_list" id="&#x1F630;">&#x1F630;</span> <span
							class="emoji_list" id="&#x1F631;">&#x1F631;</span> <span
							class="emoji_list" id="&#x1F632;">&#x1F632;</span> <span
							class="emoji_list" id="&#x1F633;">&#x1F633;</span> <span
							class="emoji_list" id="&#x1F635;">&#x1F635;</span> <span
							class="emoji_list" id="&#x1F637;">&#x1F637;</span>
						<!-- emoji popup div end -->
					</div>
				</div>
				<!-- 이모지 끝 -->
				<!-- 사진 올리기 -->
				<div class="chatupload">
					<input type="file" accept="image/jpeg,.png,.gif" id="msgfileupload" 
					style="display: none;"> 
					<i class="fa-regular fa-images chatuploadicon"></i>
				</div>
				<div class="chatinputbox">
					<input type="text" id="chatting" placeholder="채팅 입력"> <input
						type="hidden" id="receivernum" value="${otherinfo.user_num }">
					<input type="hidden" id="chatgroup" value="${recentgroup }">
				</div>
				<button onclick="send()" id="sendBtn">
					<i class="fa-regular fa-paper-plane"></i>
				</button>
			</div>
		</div>
	</div>
</body>
</html>