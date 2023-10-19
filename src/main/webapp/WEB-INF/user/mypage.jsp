<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="https://kit.fontawesome.com/2663817d27.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.3.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.css"/>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        //주소 찾기 API
        function findAddr() {
            new daum.Postcode({
                oncomplete: function (data) {

                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
                    // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var roadAddr = data.roadAddress; // 도로명 주소 변수
                    var jibunAddr = data.jibunAddress; // 지번 주소 변수
                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    /*  document.getElementById('member_post').value = data.zonecode; */
                    if (roadAddr !== '') {
                        document.getElementById("member_addr").value = roadAddr;
                    } else if (jibunAddr !== '') {
                        document.getElementById("member_addr").value = jibunAddr;
                    }
                }
            }).open();
        }


        /* 댓글 무한스크롤(post) */
        function scroll(commentoffset, post_num) {

            $.ajax({
                type: "get",
                dataType: "json",
                url: "scrollcomment",
                data: {
                    "commentoffset": commentoffset,
                    "post_num": post_num
                },
                success: function (res) {

                    $.each(res, function (i, item) {

                    	var s = "";
                        var addContent = document.createElement("div");
                        s += "<div class='allcomment' style='margin-left:"+item.comment_level*70+"px;'>";
                        
                        if(item.post_user_num =="${sessionScope.user_num}" || item.user_num == "${sessionScope.user_num}"){
                           
                           s += '<div style="height: 0; width: 450px; position: relative; left: -30px; top: 30px;">';
                            s += '<img src="../image/add.png" class="ulimg" id="ulimg'+item.comment_num+'" style="width: 20px; float: right;" comment_num="'+item.comment_num+'">';
                            s += '<ul class="list-group commentul" style="height:0; margin-top:10px;" id="ul'+item.comment_num+'">';
                            if(item.user_num == "${sessionScope.user_num}")
                               s += '<li class="list-group-item commentmod" comment_num="'+item.comment_num+'">수정</li>';
                            s += '<li class="list-group-item commentdel" comment_num="'+item.comment_num+'">삭제</li>';
                            s += '</ul>';
                            s += '<div class="comment" id="commentmod'+item.comment_num+'" style="display:flex; flex-wrap:wrap; visibility: hidden; position:relative; left: 30px; bottom: 30px;">';
                            s += '<span class="glyphicon glyphicon-remove modclose" comment_num="'+item.comment_num+'" style="position: relative; left:350px;"></span>';
                            if(item.user_photo != null)
                            	s += '<div><img src="/photo/'+item.user_photo+'" class="modprofile"></div>';
                            else
                            	s += '<div><img src="/image/noimg.png" class="modprofile"></div>';
                            	
                            s += '<div><b class="user_name" style="margin-left:-14px;">'+item.user_name+'</b>';
                            s += '<br>';
                           s += '<input type="text" class="inputmod form-control" id="cmmodinput'+item.comment_num+'" style="width: 200px; height:60%; padding:0; margin-left:-14px;" comment_num="'+item.comment_num+'" value="'+item.comment_content+'">';
                           s += '</div></div>';
                           s += '</div>';
                        }
                        
                        s += "<div class='comment' style='display:flex; flex-wrap:wrap;' visibility: visible; id='div"+item.comment_num+"'>";
                        s += '<div><a href="${root}/user/mypage?user_num='+item.user_num+'">';
                        if(item.user_photo != null)
                        	s += '<img src="/photo/'+item.user_photo+'" class="profile">';
                        else
                        	s += '<img src="/image/noimg.png" class="profile">';
                        s += '</a></div>';
                        s += "<div><b class='user_name'>" + item.user_name + "</b><br>";
                        s += "<span class='spancontent'>" + item.comment_content + "</span></div></div>";
                        s += "<div class='cmlike'>";

                        if (item.like_check == 0) {
                           s += '<span class="glyphicon glyphicon-heart-empty nolike" style="color: red;" comment_num="'+item.comment_num+'"><span style="margin-left:2px; font-size:1.25em;">' + item.like_count + '</span></span>';
                        } else {
                           s += '<span class="glyphicon glyphicon-heart yeslike" style="color: red;" comment_num="'+item.comment_num+'"><span style="margin-left:2px; font-size:1.25em;">' + item.like_count + '</span></span>';
                        }
                        
                        s += "<span class='recontent' comment_num='"+item.comment_num+"'><b style='font-size:0.9em'>답글달기</b></span>";
                        s += "<span class='comment_writeday' style='font-size:0.9em;'>" + item.perTime + "</span></div>";
                        s += '<form method="post" class="form-inline" id="comment'+item.comment_num+'" style="display: none;">';
                        s += '<div class="recommentaddform">';
                        s += "<div style='width: 50px; height: 50px;'></div>"; 
                        if(${sessionScope.user_photo != null})
                       		s += '<img src="/photo/${sessionScope.user_photo }" class="recommentprofile">';
                       	else	
                       		s += '<img src="/image/noimg.png" class="recommentprofile">';
                        s += '<input hidden="hidden" /> ';
                        s += '<input type="text" class="input" name="comment_content" placeholder="댓글을 입력하세요" id="input'+item.comment_num+'">';
                        s += '<button type="button" class="cminsert" comment_num="'+item.comment_num+'" post_num="'+item.post_num+'" style="margin-left: -40px;"></button>';
                        s += '</div>';
                        s += '</form></div>';

                        addContent.innerHTML = s;
                        document.querySelector('section1').appendChild(addContent);

                        var brcontent = document.createElement("div");
                        brcontent.innerHTML = "<br>";
                        document.querySelector('section1').appendChild(brcontent);

                    })
                }
            });
        }

        /* 댓글 무한스크롤(guest) */
        function guestscroll(commentoffset, guest_num) {

            $.ajax({
                type: "get",
                dataType: "json",
                url: "scrollguestcomment",
                data: {
                    "commentoffset": commentoffset,
                    "guest_num": guest_num
                },
                success: function (res) {

                    $.each(res, function (i, item) {

                    	var s = "";
                        var addContent = document.createElement("div");
                        s += "<div class='allcomment' style='margin-left:"+item.comment_level*70+"px;'>";
                        
                        if(item.post_user_num =="${sessionScope.user_num}" || item.user_num == "${sessionScope.user_num}"){
                           
                           s += '<div style="height: 0; width: 450px; position: relative; left: -30px; top: 30px;">';
                            s += '<img src="../image/add.png" class="ulimg" id="ulimg'+item.comment_num+'" style="width: 20px; float: right;" comment_num="'+item.comment_num+'">';
                            s += '<ul class="list-group commentul" style="height:0; margin-top:10px;" id="ul'+item.comment_num+'">';
                            if(item.user_num == "${sessionScope.user_num}")
                               s += '<li class="list-group-item commentmod" comment_num="'+item.comment_num+'">수정</li>';
                            s += '<li class="list-group-item commentdel" comment_num="'+item.comment_num+'">삭제</li>';
                            s += '</ul>';
                            s += '<div class="comment" id="commentmod'+item.comment_num+'" style="display:flex; flex-wrap:wrap; visibility: hidden; position:relative; left: 30px; bottom: 30px;">';
                            s += '<span class="glyphicon glyphicon-remove modclose" comment_num="'+item.comment_num+'" style="position: relative; left:350px;"></span>';
                            if(item.user_photo != null)
                            	s += '<div><img src="/photo/'+item.user_photo+'" class="modprofile"></div>';
                            else
                            	s += '<div><img src="/image/noimg.png" class="modprofile"></div>';
                            	
                            s += '<div><b class="user_name" style="margin-left:-14px;">'+item.user_name+'</b>';
                            s += '<br>';
                           s += '<input type="text" class="inputmod form-control" id="cmmodinput'+item.comment_num+'" style="width: 200px; height:60%; padding:0; margin-left:-14px;" comment_num="'+item.comment_num+'" value="'+item.comment_content+'">';
                           s += '</div></div>';
                           s += '</div>';
                        }
                        
                        s += "<div class='comment' style='display:flex; flex-wrap:wrap;' visibility: visible; id='div"+item.comment_num+"'>";
                        s += '<div><a href="${root}/user/mypage?user_num='+item.user_num+'">';
                        if(item.user_photo != null)
                        	s += '<img src="/photo/'+item.user_photo+'" class="profile">';
                        else
                        	s += '<img src="/image/noimg.png" class="profile">';
                        s += '</a></div>';
                        s += "<div><b class='user_name'>" + item.user_name + "</b><br>";
                        s += "<span class='spancontent'>" + item.comment_content + "</span></div></div>";
                        s += "<div class='cmlike'>";

                        if (item.like_check == 0) {
                           s += '<span class="glyphicon glyphicon-heart-empty nolike" style="color: red;" comment_num="'+item.comment_num+'"><span style="margin-left:2px; font-size:1.25em;">' + item.like_count + '</span></span>';
                        } else {
                           s += '<span class="glyphicon glyphicon-heart yeslike" style="color: red;" comment_num="'+item.comment_num+'"><span style="margin-left:2px; font-size:1.25em;">' + item.like_count + '</span></span>';
                        }
                        
                        s += "<span class='recontent' comment_num='"+item.comment_num+"'><b style='font-size:0.9em'>답글달기</b></span>";
                        s += "<span class='comment_writeday' style='font-size:0.9em;'>" + item.perTime + "</span></div>";
                        s += '<form method="post" class="form-inline" id="comment'+item.comment_num+'" style="display: none;">';
                        s += '<div class="recommentaddform">';
                        s += "<div style='width: 50px; height: 50px;'></div>"; 
                        if(${sessionScope.user_photo != null})
                       		s += '<img src="/photo/${sessionScope.user_photo }" class="recommentprofile">';
                       	else	
                       		s += '<img src="/image/noimg.png" class="recommentprofile">';
                        s += '<input hidden="hidden" /> ';
                        s += '<input type="text" class="input" name="comment_content" placeholder="댓글을 입력하세요" id="input'+item.comment_num+'">';
                        s += '<button type="button" class="cminsert" comment_num="'+item.comment_num+'" guest_num="'+item.guest_num+'" style="margin-left: -40px;"></button>';
                        s += '</div>';
                        s += '</form></div>';

                        addContent.innerHTML = s;
                        document.querySelector('section1').appendChild(addContent);

                        var brcontent = document.createElement("div");
                        brcontent.innerHTML = "<br>";
                        document.querySelector('section1').appendChild(brcontent);

                    })
                }
            });
        }


        //댓글갯수 불러오기
        function commentCount(post_num) {
            $.ajax({
                type: "get",
                dataType: "json",
                url: "postcommentcount",
                data: {"post_num": post_num},
                success: function (res) {

                    if (res > 8)
                        $("#addcomment").show();
                    else
                        $("#addcomment").hide();

                }
            });
        }

        //댓글갯수 불러오기
        function commentGuestCount(guest_num) {
            $.ajax({
                type: "get",
                dataType: "json",
                url: "guestcommentcount",
                data: {"guest_num": guest_num},
                success: function (res) {

                    if (res > 8)
                        $("#addcomment").show();
                    else
                        $("#addcomment").hide();

                }
            });
        }
        
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


        $(function () {
        	wsOpen();

            offset =${offset};
            commentoffset =${commentoffset};
            modalScrollPosition = 0;
            
          	//메시지 보내기 누르면 메시지창으로 이동
        	$(".btnmessage").click(function(){
        		location.href="../message/main?search_name=${dto.user_name}&search_num=${dto.user_num}";
        	})
        	
            //스크롤 이벤트
            $(window).scroll(function () {
                var left_side = $(".left").height();
                var scrollValue = $(document).scrollTop();

                if (left_side < scrollValue + 450) {
                    $(".left").css("top", scrollValue - 1200);
                } else {
                    $(".left").css("top", 0);
                }
            });
          	
          	//예지 추가: 팔로워 목록(나를 팔로우한 사람)
          	$(".followerListBtn").click(function(){
          		location.href='../following/followerlist?to_user=${dto.user_num}';
          	})
          	
          	//프사트리거
        	$(".userphotochangeimg").click(function(){
        		$("#newphoto").trigger("click");
        	})
        	
        	//예지 추가 끝

            //강제 호출
            $("#btnnewcover").click(function () {

                $("#newcover").trigger("click");
            });

            //커버 사진만 변경
            $("#newcover").change(function () {

                var num = $(this).attr("num");

                var form = new FormData();
                form.append("cover", $("#newcover")[0].files[0]); //선택한 1개 추가
                form.append("user_num", num);

                $.ajax({

                    type: "post",
                    dataType: "text",
                    url: "coverupdate",
                    processData: false,
                    contentType: false,
                    data: form,
                    success: function () {

                        location.reload();
                    }
                })
            });

            //강제 호출
            $("#btnnewcover2").click(function () {

                $("#newcover2").trigger("click");
            });

            //프로필 편집 시 커버 미리보기하기
            $("#newcover2").change(function () {

                if ($(this)[0].files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $("#showcover").attr("src", e.target.result);
                    }
                    reader.readAsDataURL($(this)[0].files[0]);
                }
            });

            //강제 호출
            $("#btnnewphoto").click(function () {

                $("#newphoto").trigger("click");
            });

            //프로필 사진만 변경
            $("#newphoto").change(function () {

                var num = $(this).attr("num");

                var form = new FormData();
                form.append("photo", $("#newphoto")[0].files[0]);
                form.append("user_num", num);

                $.ajax({

                    type: "post",
                    dataType: "text",
                    url: "photoupdate",
                    processData: false,
                    contentType: false,
                    data: form,
                    success: function () {

                        location.reload();
                    }
                });
            })

            //강제 호출
            $("#btnnewphoto2").click(function () {

                $("#newphoto2").trigger("click");
            });

            //프로필 편집 시 사진 미리보기하기
            $("#newphoto2").change(function () {

                if ($(this)[0].files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $("#showphoto").attr("src", e.target.result);
                    }
                    reader.readAsDataURL($(this)[0].files[0]);
                }
            });

            //프로필 편집 미리보기 후 수정
            $("#btnupdate").click(function () {

                var num = $(this).attr("num");
                var addr = $("#member_addr").val() + "," + $("#member_addr2").val();
                var email = $("#uemail").val();
                var hp = $("#uhp1").val() + "-" + $("#uhp2").val() + "-" + $("#uhp3").val();
                var data = "user_num=" + num + "&user_addr=" + addr + "&user_email=" + email + "&user_hp=" + hp;

                var form = new FormData();

                form.append("photo", $("#newphoto2")[0].files[0]);
                form.append("cover", $("#newcover2")[0].files[0]);
                form.append("user_num", num);

                $.ajax({

                    type: "post",
                    dataType: "text",
                    url: "photoupdate",
                    processData: false,
                    contentType: false,
                    data: form,
                    success: function () {

                        location.reload();
                    }
                });

                $.ajax({

                    type: "post",
                    dataType: "text",
                    url: "coverupdate",
                    processData: false,
                    contentType: false,
                    data: form,
                    success: function () {

                        location.reload();
                    }
                });

                $.ajax({

                    type: "post",
                    dataType: "text",
                    url: "updateinfo",
                    data: data,
                    success: function () {

                        location.reload();
                    }

                });
            })

            //강제 호출
            $("#btncontentphoto").click(function () {

                $("#contentphoto").trigger("click");
            });

            //게시글,방명록 작성(다중 업로드)
            $("#btnwrite").click(function () {

                var owner_num = $(this).attr("num");
                var write_num = "${loginnum}";
                var guest_content = $("#post_content").val();
                var guest_access = $("#post_access").val();
                var post_access = $("#post_access").val();
                var post_content = $("#post_content").val();
                var files = $("#contentphoto")[0].files;
                var filecheck=$("#contentphoto").val();
                
                var form = new FormData();
                


                for (var i = 0; i < files.length; i++) {
                    form.append("photo", files[i]);
                }

                if (write_num == owner_num) {

                    form.append("post_access", post_access);
                    form.append("post_content", post_content);
                    form.append("user_num", owner_num);

                    if(post_content == "" && filecheck == "")
                    	alert("사진 또는 내용을 입력해주세요");
                    else{
                    	$.ajax({

                            type: "post",
                            dataType: "text",
                            processData: false,
                            contentType: false,
                            data: form,
                            url: "insertpost",
                            success: function () {

                                location.reload();
                            }
                        });
                    }
                    
                } else {

                    form.append("guest_content", guest_content);
                    form.append("write_num", write_num);
                    form.append("owner_num", owner_num);

                    if(guest_content == "" && filecheck == "")
                    	alert("사진 또는 내용을 입력해주세요");
                    else{
                    	$.ajax({

                            type: "post",
                            dataType: "text",
                            processData: false,
                            contentType: false,
                            data: form,
                            url: "insertguestbook",
                            success: function () {

                                location.reload();
                            }
                        });
                    }
                  
                }
            })

            //작성 시 사진 여러장 미리보기
            $("#contentphoto").change(function () {
                ////array로
                var fileArr = Array.from(this.files);

                var s = "";
                var videoCount = 0;

                $.each(fileArr, function (i, ele) {
                    var file = ele;
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        if ((e.target.result).includes("video/mp4")) {
                            s += "<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='" + e.target.result + "'>";
                            videoCount = videoCount + 1;
                        } else {
                            s += "<img style='width: 95%; max-height:350px; object-fit:cover;' src='" + e.target.result + "'>";
                        }

                        $("#show").html(s);

                        if (s.includes("video/mp4") && s.includes("image/")) {
                            alert("동영상과 사진은 함께 올릴 수 없습니다.");
                            $("#contentphoto").val(null);
                            $("#show").html("");
                            $("#show").hide();
                        } else if (videoCount >= 2) {
                            alert("동영상은 한 개만 올릴 수 있습니다.");
                            $("#contentphoto").val(null);
                            $("#show").html("");
                            $("#show").hide();
                        }
                    };
                    reader.readAsDataURL(file);
                })

                $("#show").html(s);
                $("#show").show();
            });

            //수정 시 사진 여러장 미리보기
            $("#btnmodcontentphoto").click(function () {
                $("#update_file").click();
            });
            $(document).ready(function () {

                $("#update_file").change(function () {
                    ////array로
                    var fileArr = Array.from(this.files);

                    var s = "";
                    var videoCount = 0;

                    $.each(fileArr, function (i, ele) {
                        var file = ele;
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            if ((e.target.result).includes("video/mp4")) {
                                s += "<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='" + e.target.result + "'>";
                                videoCount = videoCount + 1;
                            } else {
                                s += "<img style='width: 95%; max-height:350px; object-fit:cover;' src='" + e.target.result + "'>";
                            }
                            $("#showmodimg").html(s);

                            if (s.includes("video/mp4") && s.includes("image/")) {
                                alert("동영상과 사진은 함께 올릴 수 없습니다.");
                                $("#update_file").val(null);
                                $("#showmodimg").html("");
                                $("#showmodimg").hide();
                            } else if (videoCount >= 2) {
                                alert("동영상은 한 개만 올릴 수 있습니다.");
                                $("#update_file").val(null);
                                $("#showmodimg").html("");
                                $("#showmodimg").hide();
                            }
                        };
                        reader.readAsDataURL(file);
                    })

                    $("#showmodimg").html(s);
                    $("#showmodimg").show();
                });

                //수정 시 사진,동영상 지우기
                $("#remove_photo_btn").click(function () {
                    $("#update_file").val("");
                    $("#showmodimg").html("");
                    $("#update_file").val(null);
                    $("#update_file").attr("photodel", "true");
                    $("#showmodimg").hide();
                });

                //업로드 시 사진,동영상 지우기
                $("#remove_contentphoto_btn").click(function () {
                    $("#contentphoto").val("");
                    $("#show").html("");
                    $("#contentphoto").val(null);
                    $("#show").hide();
                });
            });

            //사진 넘기면서 보기
            $(document).ready(function () {

                $(".slider").each(function () {

                    var itemId = this.id;
                    var slider_num = itemId.split("-")[1];

                    $("#" + itemId).slick({

                        prevArrow: '<img id="prev-' + itemId + '" src="../image/left.png" class="prev" >',
                        nextArrow: '<img id="next-' + itemId + '" src="../image/right.png" class="next">',
                        autoplay: false, // 자동 재생 여부
                        autoplaySpeed: 0, // 자동 재생 속도 (단위: ms)
                        dots: false, // 점 네비게이션 표시 여부
                        arrows: true, // 화살표 네비게이션 표시 여부
                        infinite: false, // 무한 슬라이드 여부
                        slidesToShow: 1, // 한 화면에 보여줄 슬라이드 수
                        slidesToScroll: 1 // 한 번에 스크롤할 슬라이드 수
                    });

                    //마지막,처음 화살표 삭제
                    $("#" + itemId).on('afterChange', function (event, slick, currentSlide) {
                        if (currentSlide == 0) {
                            $('#prev-' + itemId).css("visibility", "hidden");
                        } else {
                            $('#prev-' + itemId).css("visibility", "visible");
                        }
                        if (currentSlide == slick.slideCount - 1) {
                            $('#next-' + itemId).css("visibility", "hidden");
                        } else {
                            $('#next-' + itemId).css("visibility", "visible");
                        }
                    });
                })
            });

            //게시물,방명록 수정 값 불러오기
            $(".modpost").click(function () {
                updatenum = $(this).attr("post_num");
                updateusernum = $(this).attr("user_num");
                type = $(this).attr("type");

                if (type == 'post') {
                    $.ajax({
                        type: "get",
                        dataType: "json",
                        url: "updateform",
                        data: {"post_num": updatenum},
                        success: function (res) {
                            var s = "";
                            const modalaccess = document.getElementById("modalaccess");
                            s += ' <select class="form-control" name="update_access" id="update_access" required="required">'
                                + '<option value="all">전체공개</option>'
                                + '<option value="follower">팔로워 공개</option>'
                                + ' <option value="onlyme">나만보기</option>'
                                + '</select>';

                            $("#update_access").val(res.post_access);
                            $("#update_content").val(res.post_content);

                            // 사진 미리보기
                            var files = (res.post_file).split(',');

                            var filename = "";

                            $.each(files, function (i, ele) {
                                if (ele.includes(".mp4")) {
                                    filename += "<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='/post_file/" + ele + "'>";
                                } else {
                                    filename += "<img style='width: 95%; max-height:350px; object-fit:cover;'";
                                    filename += "src='/post_file/" + ele + "'>";
                                }

                                if (ele == "no") {
                                    filename = "";
                                    $("#showmodimg").hide();
                                }
                            })

                            $("#showmodimg").html(filename);

                            modalaccess.innerHTML = s;
                        }
                    });
                } else {
                    $.ajax({
                        type: "get",
                        dataType: "json",
                        url: "updateguestform",
                        data: {"guest_num": updatenum},
                        success: function (res) {
                            var s = "";
                            const modalaccess = document.getElementById("modalaccess");
                            s += '<span style="border-radius: 5px; padding: 4px; background-color: #F0F2F5;"><b><i class="fa-solid fa-user-group">';
                            s += '</i>팔로워 공개</b></span>';

                            $("#update_content").val(res.guest_content);

                            // 사진 미리보기
                            var files = (res.guest_file).split(',');

                            var filename = "";

                            $.each(files, function (i, ele) {
                                if (ele.includes(".mp4")) {
                                    filename += "<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='/guest_file/" + ele + "'>";
                                } else {
                                    filename += "<img style='width: 95%; max-height:350px; object-fit:cover;'";
                                    filename += "src='/guest_file/" + ele + "'>";
                                }

                                if (ele == "no") {
                                    filename = "";
                                    $("#showmodimg").hide();
                                }
                            })

                            $("#showmodimg").html(filename);

                            $("#btnupdate2").attr("num", updateusernum);
                            $("#btnupdate2").attr("post_type", type);

                            modalaccess.innerHTML = s;
                        }
                    });
                }
            });

            //게시물 수정
            $("#btnupdate2").click(function () {

                var update_access = $("#update_access").val();
                var update_content = $("#update_content").val();
                var write_num = "${loginnum}";
                var owner_num = $(this).attr("num");
                var post_type = $(this).attr("post_type");

                var form = new FormData();

                var files = $("#update_file")[0].files;

                for (var i = 0; i < files.length; i++) {
                    form.append("photo", files[i]);
                }

                if (write_num == owner_num && post_type == 'guest') {


                    form.append("guest_num", updatenum);
                    form.append("guest_content", update_content);
                    form.append("photodel", $("#update_file").attr("photodel"));

                    $.ajax({
                        type: "post",
                        dataType: "text",
                        url: "updateguestbook",
                        processData: false,
                        contentType: false,
                        data: form,
                        success: function () {
                            location.reload();
                        }
                    });

                } else {
                    form.append("post_num", updatenum);
                    form.append("post_access", update_access);
                    form.append("post_content", update_content);
                    form.append("photodel", $("#update_file").attr("photodel"));

                    $.ajax({
                        type: "post",
                        dataType: "text",
                        url: "updatepost",
                        processData: false,
                        contentType: false,
                        data: form,
                        success: function () {
                            location.reload();
                        }
                    });
                }
            })

            //게시물 삭제
            $(".delpost").click(function () {

                var post_num = $(this).attr("post_num");
                var guest_num = $(this).attr("post_num");
                var write_num = "${loginnum}";
                var owner_num = $(this).attr("num");
                var type = $(this).attr("type");

                if (write_num == owner_num && type == 'post') {

                    $.ajax({

                        type: "get",
                        dataType: "text",
                        data: {"post_num": post_num},
                        url: "deletepost",
                        success: function () {

                            location.reload();
                        }
                    });
                } else if (write_num == owner_num && type == 'guest') {

                    $.ajax({

                        type: "get",
                        dataType: "text",
                        data: {"guest_num": guest_num},
                        url: "deleteguestbook",
                        success: function () {

                            location.reload();
                        }
                    });

                } else {

                    $.ajax({

                        type: "get",
                        dataType: "text",
                        data: {"guest_num": guest_num},
                        url: "deleteguestbook",
                        success: function () {

                            location.reload();
                        }
                    });
                }
            })

            //방명록,게시글 좋아요
            $(".img_like").click(function () {

                var type = $(this).attr("type");
                var post_num = $(this).attr("post_num");
                var user_num = "${loginnum}";


                if (type == "post") {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "likeinsert",
                        data: {"post_num": post_num, "user_num": user_num},
                        success: function () {
                        	//게시글 좋아요 알림
                       	 	ws.send('{"type":"plike","sender_num":"${sessionScope.user_num}","post_num":"'+post_num+'","guest_num":"null"}');
                        }
                    })

                } else {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "guestlikeinsert",
                        data: {"guest_num": post_num, "user_num": user_num},
                        success: function () {
                        	//방명록 좋아요 알림
                       		ws.send('{"type":"plike","sender_num":"${sessionScope.user_num}","guest_num":"'+post_num+'","post_num":"null"}');
                        }
                    })
                }
            })

            //좋아요 토글
            $(document).on("click", ".liketoggle", function () {

                var likeshow1_num = $(this).attr("likeshow1_num");
                var likehide1_num = $(this).attr("likehide1_num");

                $("#" + likeshow1_num).toggle();
                $("#" + likehide1_num).toggle();

            });

            //좋아요 취소
            $(".img_dlike").click(function () {

                var type = $(this).attr("type");
                var post_num = $(this).attr("post_num");
                var user_num = "${loginnum}";

                if (type == "post") {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "likedelete",
                        data: {"post_num": post_num, "user_num": user_num},
                        success: function () {

                        }
                    })

                } else {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "guestlikedelete",
                        data: {"guest_num": post_num, "user_num": user_num},
                        success: function () {

                        }
                    })
                }
            })

            //좋아요 취소 토글
            $(document).on("click", ".liketoggle2", function () {

                var likeshow2_num = $(this).attr("likeshow2_num");
                var likehide2_num = $(this).attr("likehide2_num");

                $("#" + likeshow2_num).toggle();
                $("#" + likehide2_num).toggle();

            });

            //팔로우 하기
            $("#btnfollow").click(function () {

                var from_user = $(this).attr("from_user");
                var to_user = $(this).attr("to_user");

                $.ajax({

                    type: "get",
                    dataType: "text",
                    url: "insertfollowing",
                    data: {"from_user": from_user, "to_user": to_user},
                    success: function () {
                    	ws.send('{"type":"follow","receiver_num":"'+to_user+'","sender_num":"${sessionScope.user_num}"}');
                        location.reload();
                    }
                });
            })

            //팔로우 취소
            $("#btnunfollow").click(function () {

                var to_user = $(this).attr("to_user");

                $.ajax({

                    type: "get",
                    dataType: "text",
                    url: "unfollowing",
                    data: {"to_user": to_user},
                    success: function () {

                        location.reload();
                    }
                });
            })

            //이미지 박스 hide&show
            $("#btncontentphoto").click(function () {

                $("#showimg").show();
                $("#showtext").show();
            })

            //댓글 창 호출
            $(document).on("click", ".img_comment", function () {

                var post_num = $(this).attr("post_num");
                var user_name = $(this).attr("user_name");
                $(".commentmodal-body").scrollTop(0);

                type = $(this).attr("type");

                $("#inputhidden-post_num").val("");
                $("#inputhidden-guest_num").val("");
                $(".commenth4").text(user_name + "님의 게시물");


                $("#insertcommentbtn").attr("writetype", type);
                if (type == "post") {
                    $("#inputhidden-post_num").val(post_num);
                } else
                    $("#inputhidden-guest_num").val(post_num);


                $("#commentsection").empty();
                $("#timesection").empty();

                if (type == "post") {
                    scroll(0, post_num);
                    commentCount(post_num);
                    $.ajax({
                        type: "get",
                        dataType: "json",
                        url: "getmypostdata",
                        data: {"post_num": post_num},
                        success: function (res) {
                            $.each(res, function (i, dto) {

                                var s = '';
                                var root = "${root}";

                                if (dto.post_file != 'no') {
                                    s += '<div class="content">' +
                                        '<div class="divmain">' +
                                        '<div class="top">' +
                                        '<div class="top-user">';

                                    if (dto.type === 'post') {
                                        s += '<a href="' + root + '/user/mypage?user_num=' + dto.user_num + '"><img alt="" src="/photo/' + dto.dto.user_photo + '" style="width:40px; height: 40px; border-radius: 20px; margin: 10px;"></a>';
                                    }

                                    s += '<div class="top-writeday">' +
                                        '<span><b><a href="' + root + '/user/mypage?user_num=' + dto.user_num + '" style="color: black;">' + dto.user_name + '</a><br></b> ' + dto.post_time + '<b>';

                                    if (dto.post_access === 'follower') {
                                        s += '<i class="fa-solid fa-user-group"></i>';
                                    }

                                    if (dto.post_access === 'all') {
                                        s += '<i class="fa-solid fa-earth-americas"></i>';
                                    }

                                    if (dto.post_access === 'onlyme') {
                                        s += '<i class="fa-solid fa-lock"></i>';
                                    }

                                    s += '</b></span>' +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="center">' +
                                        '<div class="center-up">' + dto.post_content + '</div>' +
                                        '<div class="slider center-down" id="dto-' + dto.post_num + '">';

                                    if (dto.post_file.includes('.mp4')) {
                                        s += '<div class="fileimg">';

                                        if (dto.post_file !== 'no' && dto.type === 'post') {
                                            s += '<video src="/post_file/' + dto.post_file + '" controls="controls" muted="muted" style="width:100%;"></video>';
                                        }

                                        s += '</div>';
                                    } else {
                                        if (dto.post_file !== 'no' && dto.type === 'post') {
                                            var postFiles = dto.post_file.split(',');

                                            for (var i = 0; i < postFiles.length; i++) {
                                                s += '<div class="fileimg">' +
                                                    '<a href="/post_file/' + postFiles[i] + '" target="_new" style="text-decoration: none; outline: none;">' +
                                                    '<img src="/post_file/' + postFiles[i] + '" style="width: 60%;height: 100%; margin: 0 auto;">' +
                                                    '</a>' +
                                                    '</div>';
                                            }
                                        }
                                    }

                                    s += '</div>' +
                                        '</div>' +
                                        '</div>';
                                } else {

                                    s += '<div class="content">' +
                                        '<div class="divmain">' +
                                        '<div class="top">' +
                                        '<div class="top-user">';

                                    if (dto.type === 'post') {
                                        s += '<a href="' + root + '/user/mypage?user_num=' + dto.user_num + '"><img alt="" src="/photo/' + dto.dto.user_photo + '" style="width:40px; height: 40px; border-radius: 20px; margin: 10px;"></a>';
                                    }

                                    s += '<div class="top-writeday">' +
                                        '<span><b><a href="' + root + '/user/mypage?user_num=' + dto.user_num + '" style="color: black;">' + dto.user_name + '</a><br></b> ' + dto.post_time + '<b>';

                                    if (dto.post_access === 'follower') {
                                        s += '<i class="fa-solid fa-user-group"></i>';
                                    }

                                    if (dto.post_access === 'all') {
                                        s += '<i class="fa-solid fa-earth-americas"></i>';
                                    }

                                    if (dto.post_access === 'onlyme') {
                                        s += '<i class="fa-solid fa-lock"></i>';
                                    }

                                    s += '</b></span>' +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="center">' +
                                        '<div class="center-up">' + dto.post_content + '</div>' +
                                        '<div class="slider center-down" id="dto-' + dto.post_num + '">';

                                    s += '</div>' +
                                        '</div>' +
                                        '</div>';
                                }

                                var addTimeline = document.createElement("div");
                                addTimeline.innerHTML = s;
                                document.querySelector('sectiontime').appendChild(addTimeline);
                                return false;
                            })
                        }
                    });
                } else {
                    guestscroll(0, post_num);
                    commentGuestCount(post_num);
                    $.ajax({
                        type: "get",
                        dataType: "json",
                        url: "getmypostdata",
                        data: {"guest_num": post_num},
                        success: function (res) {
                            $.each(res, function (i, dto) {

                                var s = '';
                                var root = "${root}";

                                if (dto.post_file != 'no') {
                                    s += '<div class="content">' +
                                        '<div class="divmain">' +
                                        '<div class="top">' +
                                        '<div class="top-user">';

                                    if (dto.type === 'guest') {
                                        s += '<a href="' + root + '/user/mypage?user_num=' + dto.user_num + '"><img alt="" src="' + root + '/photo/' + dto.dto.user_photo + '" style="width:40px; height: 40px; border-radius: 20px; margin: 10px;"></a>';
                                    }

                                    s += '<div class="top-writeday">' +
                                        '<span><b><a href="' + root + '/user/mypage?user_num=' + dto.dto.user_num + '" style="color: black;">' + dto.dto.user_name + '</a>';

                                    if (dto.type === 'guest') {
                                        s += '<i class="fa-solid fa-caret-right"></i>';
                                    }

                                    s += '<a href="' + root + '/user/mypage?user_num="${dto.user_num}" style="color: black;"> ${dto.user_name} </a><br></b> ' + dto.post_time + '<b>';

                                    if (dto.post_access === 'follower') {
                                        s += '<i class="fa-solid fa-user-group"></i>';
                                    }

                                    if (dto.post_access === 'all') {
                                        s += '<i class="fa-solid fa-earth-americas"></i>';
                                    }

                                    if (dto.post_access === 'onlyme') {
                                        s += '<i class="fa-solid fa-lock"></i>';
                                    }

                                    s += '</b></span>' +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="center">' +
                                        '<div class="center-up">' + dto.post_content + '</div>' +
                                        '<div class="slider center-down" id="dto-' + dto.post_num + '">';

                                    if (dto.post_file.includes('.mp4')) {
                                        s += '<div class="fileimg">';

                                        if (dto.post_file !== 'no' && dto.type === 'guest') {
                                            s += '<video src="/guest_file/' + dto.post_file + '" controls="controls" muted="muted" style="width:100%;"></video>';
                                        }

                                        s += '</div>';
                                    } else {

                                        if (dto.post_file !== 'no' && dto.type === 'guest') {
                                            var guestFiles = dto.post_file.split(',');

                                            for (var j = 0; j < guestFiles.length; j++) {
                                                s += '<div class="fileimg">' +
                                                    '<a href="/post_file/' + guestFiles[j] + '" target="_new" style="text-decoration: none; outline: none;">' +
                                                    '<img src="/guest_file/' + guestFiles[j] + '" style="width: 60%;height: 100%; margin: 0 auto;">' +
                                                    '</a>' +
                                                    '</div>';
                                            }
                                        }
                                    }

                                    s += '</div>' +
                                        '</div>' +
                                        '</div>';
                                } else {
                                    s += '<div class="content">' +
                                        '<div class="divmain">' +
                                        '<div class="top">' +
                                        '<div class="top-user">';

                                    if (dto.type === 'guest') {
                                        s += '<a href="' + root + '/user/mypage?user_num=' + dto.user_num + '"><img alt="" src="' + root + '/photo/' + dto.dto.user_photo + '" style="width:40px; height: 40px; border-radius: 20px; margin: 10px;"></a>';
                                    }

                                    s += '<div class="top-writeday">' +
                                        '<span><b><a href="' + root + '/user/mypage?user_num=' + dto.dto.user_num + '" style="color: black;">' + dto.dto.user_name + '</a>';

                                    if (dto.type === 'guest') {
                                        s += '<i class="fa-solid fa-caret-right"></i>';
                                    }

                                    s += '<a href="' + root + '/user/mypage?user_num="${dto.user_num}" style="color: black;"> ${dto.user_name} </a><br></b> ' + dto.post_time + '<b>';

                                    if (dto.post_access === 'follower') {
                                        s += '<i class="fa-solid fa-user-group"></i>';
                                    }

                                    if (dto.post_access === 'all') {
                                        s += '<i class="fa-solid fa-earth-americas"></i>';
                                    }

                                    if (dto.post_access === 'onlyme') {
                                        s += '<i class="fa-solid fa-lock"></i>';
                                    }

                                    s += '</b></span>' +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="center">' +
                                        '<div class="center-up">' + dto.post_content + '</div>' +
                                        '<div class="slider center-down" id="dto-' + dto.post_num + '">';


                                    s += '</div>' +
                                        '</div>' +
                                        '</div>';
                                }
                                var addTimeline = document.createElement("div");
                                addTimeline.innerHTML = s;
                                document.querySelector('sectiontime').appendChild(addTimeline);
                                return false;
                            })
                        }
                    });
                }


                $(".btncommentmodal").trigger("click");

            })
            
            //예지---
            
          //마이페이지 넘어갔을 때 post_num이 넘어온 경우
        	if("${post_num}"!=""){
        		$.each($(".img_comment"),function(i,ele){
        			if($(ele).attr("post_num")=="${post_num}" && $(ele).attr("type")=="post"){
        				 $(ele).trigger("click");
        			}
        		})
        	}
        	
        	//마이페이지 넘어갔을 때 guest_num이 넘어온 경우
        	if("${guest_num}"!=""){
        		$.each($(".img_comment"),function(i,ele){
        			if($(ele).attr("post_num")=="${guest_num}" && $(ele).attr("type")=="guest"){
        				$(ele).trigger("click");
        			}
        		})
        	}
            
            
            ///예지끝---

            //댓글 입력
            $("#insertcommentbtn").click(function () {

                //var formdata = $("#form").serialize();
                var post_num = $("#inputhidden-post_num").val();
                var guest_num = $("#inputhidden-guest_num").val();
                var comment_content = $("#commentinput").val();
                modalScrollPosition = $(".commentmodal-body").scrollTop();


                if (type == "post") {
                    $.ajax({

                        type: "post",
                        dataType: "text",
                        url: "cinsert",
                        data: {"post_num": post_num, "comment_num": "0", "comment_content": comment_content},
                        success: function () {
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#commentinput").val("");
                            commentoffset = 0;
                            scroll(commentoffset, post_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentCount(post_num);
                          	//웹소켓에 댓글 알림 보내기
                            ws.send('{"type":"post","sender_num":"${sessionScope.user_num}","post_num":"'+post_num+'","guest_num":"null","comment_content":"'+comment_content+'"}');
                        }
                    })
                } else {

                    $.ajax({

                        type: "post",
                        dataType: "text",
                        url: "cinsert",
                        data: {"guest_num": guest_num, "comment_num": "0", "comment_content": comment_content},
                        success: function () {
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#commentinput").val("");
                            commentoffset = 0;
                            guestscroll(commentoffset, guest_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentGuestCount(guest_num);
                          	//웹소켓에 댓글 알림 보내기
                            ws.send('{"type":"post","sender_num":"${sessionScope.user_num}","guest_num":"'+guest_num+'","post_num":"null","comment_content":"'+comment_content+'"}');
                        }
                    })
                }

            });

            $(document).on("click", "#addcomment", function () {
                var post_num = $("#inputhidden-post_num").val();
                var guest_num = $("#inputhidden-guest_num").val();
                modalScrollPosition = $(".commentmodal-body").scrollTop();
                commentoffset = commentoffset + 8;
                if (type == "post")
                    scroll(commentoffset, post_num);
                else
                    guestscroll(commentoffset, guest_num);
            })

            $('#commentinput').keydown(function () {
                if (event.keyCode === 13) {
                    $("#insertcommentbtn").trigger("click");
                }
                ;
            });

            $(document).on("keydown", ".input", function () {

                if (event.keyCode === 13) {
                    $(this).next().trigger("click");
                }
                ;
            });

            $(document).on("click", ".ulimg", function () {

                var comment_num = $(this).attr("comment_num");
                $("#ul" + comment_num).toggle();
            })

            $(document).on("click", ".cminsert", function () {

                var comment_num = $(this).attr("comment_num");
                var comment_content = $("#input" + comment_num).val();
                var post_num = $(this).attr("post_num");
                var guest_num = $(this).attr("guest_num");
                modalScrollPosition = $(".commentmodal-body").scrollTop();

                if (type == "post") {

                    $.ajax({

                        type: "post",
                        dataType: "text",
                        url: "cinsert",
                        data: {
                            "comment_num": comment_num,
                            "comment_content": comment_content,
                            "post_num": post_num
                        },
                        success: function () {
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            commentoffset = 0;
                            scroll(commentoffset, post_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentCount(post_num);
                            
                          	//답글 알람
                          	ws.send('{"type":"comment","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'","comment_content":"'+comment_content+'"}');
                        }
                    })
                } else {

                    $.ajax({

                        type: "post",
                        dataType: "text",
                        url: "cinsert",
                        data: {
                            "comment_num": comment_num,
                            "comment_content": comment_content,
                            "guest_num": guest_num
                        },
                        success: function () {
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            commentoffset = 0;
                            guestscroll(commentoffset, guest_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentGuestCount(guest_num);
                            
                          	//답글 알람
                            ws.send('{"type":"comment","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'","comment_content":"'+comment_content+'"}');
                        }
                    })
                }


            })

            $(document).on("click", ".recontent", function () {

                var comment_num = $(this).attr("comment_num");

                $("#comment" + comment_num).toggle();
            })

            //댓글 좋아요
            $(document).on("click", "span.nolike", function () {

                var comment_num = $(this).attr("comment_num");
                var post_num = $("#inputhidden-post_num").val();
                var guest_num = $("#inputhidden-guest_num").val();
                modalScrollPosition = $(".commentmodal-body").scrollTop();

                if (type == "post") {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "commentlikeinsert",
                        data: {
                            "comment_num": comment_num
                        },
                        success: function () {
                            commentoffset = 0;
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            scroll(commentoffset, post_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentCount(post_num);
                            
                          	//댓글 좋아요 알림
                      	 	ws.send('{"type":"clike","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'"}');
                        }
                    });
                } else {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "commentlikeinsert",
                        data: {
                            "comment_num": comment_num
                        },
                        success: function () {
                            commentoffset = 0;
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            guestscroll(commentoffset, guest_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentGuestCount(guest_num);
                            
                         	//댓글 좋아요 알림
                      	 	ws.send('{"type":"clike","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'"}');
                        }
                    });
                }


            })

            //댓글 좋아요 취소
            $(document).on("click", "span.yeslike", function () {

                var comment_num = $(this).attr("comment_num");
                var post_num = $("#inputhidden-post_num").val();
                var guest_num = $("#inputhidden-guest_num").val();
                modalScrollPosition = $(".commentmodal-body").scrollTop();

                if (type == "post") {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "commentlikedelete",
                        data: {
                            "comment_num": comment_num
                        },
                        success: function () {
                            commentoffset = 0;
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            scroll(commentoffset, post_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentCount(post_num);
                        }
                    });

                } else {

                    $.ajax({
                        type: "get",
                        dataType: "text",
                        url: "commentlikedelete",
                        data: {
                            "comment_num": comment_num
                        },
                        success: function () {
                            commentoffset = 0;
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();
                            guestscroll(commentoffset, guest_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentGuestCount(guest_num);
                        }
                    });
                }


            })

            $(document).on("click", ".commentdel", function () {

                var comment_num = $(this).attr("comment_num");
                var post_num = $("#inputhidden-post_num").val();
                var guest_num = $("#inputhidden-guest_num").val();
                modalScrollPosition = $(".commentmodal-body").scrollTop();

                $.ajax({
                    type: "get",
                    dataType: "text",
                    url: "cdelete",
                    data: {"comment_num": comment_num},
                    success: function () {
                        commentoffset = 0;
                        $("#commentsection").empty();
                        $("#addcomment").hide();
                        $("#input" + comment_num).val("");
                        $("#input" + comment_num).hide();
                        if (type == "post") {
                            scroll(commentoffset, post_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentCount(post_num);
                        } else {

                            guestscroll(commentoffset, guest_num);
                            setTimeout(function() {
                                $(".commentmodal-body").scrollTop(modalScrollPosition);
                              },400);
                            commentGuestCount(guest_num);
                        }
                    }
                })
            })

            $(document).on("click", ".commentmod", function () {

                var comment_num = $(this).attr("comment_num");
                var div = $("#div" + comment_num).css("visibility");
                var divmod = $("#commentmod" + comment_num).css("visibility");

                if (div == "visible")
                    $("#div" + comment_num).css("visibility", "hidden");
                else
                    $("#div" + comment_num).css("visibility", "visible");

                if (divmod == "hidden")
                    $("#commentmod" + comment_num).css("visibility", "visible");
                else
                    $("#commentmod" + comment_num).css("visibility", "hidden");
                $("#ul" + comment_num).toggle();

            })

            $(document).on("click", ".modclose", function () {

                var comment_num = $(this).attr("comment_num");
                var div = $("#div" + comment_num).css("visibility");
                var divmod = $("#commentmod" + comment_num).css("visibility");
                if (div == "visible")
                    $("#div" + comment_num).css("visibility", "hidden");
                else
                    $("#div" + comment_num).css("visibility", "visible");

                if (divmod == "hidden")
                    $("#commentmod" + comment_num).css("visibility", "visible");
                else
                    $("#commentmod" + comment_num).css("visibility", "hidden");

            })

            $(document).on("keydown", ".inputmod", function () {

                if (event.keyCode === 13) {
                    var comment_num = $(this).attr("comment_num");
                    var post_num = $("#inputhidden-post_num").val();
                    var guest_num = $("#inputhidden-guest_num").val();
                    modalScrollPosition = $(".commentmodal-body").scrollTop();
                    var comment_content = $(this).val();

                    $.ajax({
                        type: "post",
                        dataType: "text",
                        url: "commentupdate",
                        data: {"comment_num": comment_num, "comment_content": comment_content},
                        success: function () {
                            commentoffset = 0;
                            $("#commentsection").empty();
                            $("#addcomment").hide();
                            $("#input" + comment_num).val("");
                            $("#input" + comment_num).hide();

                            if (type == "post") {
                                scroll(0, post_num);
                                commentCount(post_num);
                                setTimeout(function() {
                                    $(".commentmodal-body").scrollTop(modalScrollPosition);
                                  },400);
                            } else {
                                guestscroll(0, guest_num);
                                setTimeout(function() {
                                    $(".commentmodal-body").scrollTop(modalScrollPosition);
                                  },400);
                                commentGuestCount(guest_num);
                            }
                        }
                    });
                }
                ;
            })


            //처음 화면 로딩됐을 때 영상 위치 확인
            $(".fileimg video").each(function (i, ele) {
                videoStatus($(ele));
            })

            //스크롤 할 때마다 영상 위치 확인
            $(window).scroll(function () {
                $(".fileimg video").each(function (i, ele) {
                    if (videoStatus($(ele))) {
                        return;
                    }
                })
            })

            //영상 화면에 보일 시 자동재생
            function videoStatus(video) {
                var viewHeight = $(window).height();
                var scrollTop = $(window).scrollTop();
                var y = video.offset().top;
                var elementHeight = video.height();

                if (y < (viewHeight + scrollTop) && y > (scrollTop - elementHeight)) {
                    if (video.attr("onwindow") != "true") {
                        video.get(0).play();
                        video.attr("onwindow", "true");
                    }

                    return true;
                } else if (y < (viewHeight + scrollTop) && video.attr("onwindow") != "true") {
                    if (video.attr("onwindow") != "true") {
                        video.get(0).play();
                        video.attr("onwindow", "true");
                    }

                    return true;
                } else {
                    video.get(0).pause();
                    video.attr("onwindow", "false");

                    return false;
                }
            }

        })
    </script>

    <style type="text/css">

        html {
            background-color: #F0F2F5;
        }

        .cover {
            width: 100%;
            height: 300px;
            border-radius: 10px 10px;
        }

        .main-profile {
            width: 100%;
            height: 120px;
            background-color: white;
        }

        .menu {
            width: 100%;
            height: 50px;
            background-color: white;

        }

        .menu a {
            margin: 0 10px;
        }

        .mypage-main {
            margin: 0 auto;
        }

        .intro {
            width: 98%;
            height: 250px;
            background-color: white;
            border-radius: 10px 10px;
            margin: 10px;
        }

        .intro-info {
            line-height: 45px;
            margin-left: 1%;
        }

        .galary {
            width: 98%;
            height: 550px;
            background-color: white;
            border-radius: 10px 10px;
            margin: 10px;
        }

        .friend {
            width: 98%;
            height: 680px;
            background-color: white;
            border-radius: 10px 10px;
            margin: 10px;

        }

        .write {
            width: 99%;
            height: 100px;
            background-color: white;
            border-radius: 10px 10px;
            margin: 10px;
        }

        .content {
            width: 99%;
            height: 100%;
            background-color: white;
            border-radius: 10px 10px;
            margin: 10px;
        }

        .left {
            width: 31%;
            float: left;
            position: relative;
        }

        .right {
            width: 69%;
            float: right;
        }

        #btnnewcover {
            cursor: pointer;
            color: white;
            background-color: black;
            padding: 6px 16px;
            border-radius: 5px;
            position: relative;
            left: 85%;
            bottom: 20%;
        }

        .btnprofile {
            font-weight: bold;
            padding: 10px;
            background-color: #F0F2F5;
            padding: 8px;
        }

        #btnupdate {
            width: 570px;
            background-color: lightblue;
            color: blue;
            font-weight: 700;
        }

        #btnwrite {
            width: 570px;
            background-color: #3578E5;
            color: white;
            font-weight: 700;
        }

        .top-user {
            display: flex;
            align-items: center;
        }

        .top-writeday {
            display: flex;
            flex-direction: column;
        }

        .center-up {
            margin-left: 10px;
        }

        .bottom {
            margin: 2%;
        }

        .galary-photo {
            width: 160px;
            height: 160px;
            border-radius: 10px;
            border: 1px solid gray;
        }

        .galary-video {
            width: 160px;
            height: 160px;
            border-radius: 10px;
            border: 1px solid gray;

        }

        .galary-photoall {
            display: flex;
            flex-wrap: wrap;
            margin-left: 2%;
            margin-top: 3%;
        }

        .bottom-up {
            display: flex;
        }

        .like {
            width: 50%;
        }

        .div-comment {
            width: 50%;
        }

        .friend-photoall {
            display: flex;
            flex-wrap: wrap;
        }

        .friend-photo {
            width: 160px;
            height: 160px;
            border-radius: 10px;
            border: 1px solid gray;
        }

        .prev {
            top: 300px;
            position: relative;
            z-index: 1;
            border: none;
            width: 100px;
            height: 100px;
            cursor: pointer;
            visibility: hidden;
        }

        .next {
            float: right;
            bottom: 300px;
            position: relative;
            border: none;
            width: 100px;
            height: 100px;
            cursor: pointer;
        }

        .btnfollow {
            color: white;
            background-color: #3578E5;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            padding: 8px;
        }

        .btnunfollow {
            color: white;
            background-color: #3578E5;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            padding: 8px;
        }

        .btnmessage {
            color: black;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            padding: 8px;
            background-color: #F0F2F5;
        }

        .hp {
            display: flex;
            align-items: center;
            width: 250px;
            margin-bottom: 2%;
        }

        .email {
            width: 250px;
        }

        textarea::placeholder {
            font-size: 1.2em;
        }

        .dropdown {
            height: 0px;
        }

        .galary-photo.galary-photo-1, .galary-video.galary-photo-1 {
            margin-right: 5px; /* 첫 번째 이미지의 우측 간격 설정 */
            margin-bottom: 5px; /* 첫 번째 이미지의 하단 간격 설정 */
        }

        .galary-photo.galary-photo-2, .galary-video.galary-photo-2 {
            margin-right: 5px; /* 두 번째 이미지의 우측 간격 설정 */
            margin-bottom: 5px; /* 두 번째 이미지의 하단 간격 설정 */
        }


       /* comment */
.commentmodal-content {
	overflow-y: initial !important;
}

.commentmodal-body {
	height: 740px;
	overflow-y: auto;
}

.comment {
	width: 400px;
	border-radius: 20px;
	padding: 10px;
	margin-bottom: 10px;
	background-color: #f6f6f6;
	margin-left: 50px;
}

.profile {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	margin-right: 5px;
	margin-left: -55px;
}

.modprofile {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	margin-right: 5px;
	margin-left: -69px;
}

/* 좋아요,댓글,날짜 */
.cmlike {
	width: 450px;
	margin-top: 10px;
	display: flex;
	justify-content: space-around;
}

/* 사용자 이름  */
b.user_name {
	font-size: 12px;
	font-weight: bold;
}

/* 사용자 댓글  */
span.content {
	font-size: 10px;
}

#commentaddform {
	margin-top: 10px;
	height: 60px;
	display: flex;
	justify-content: space-between;
	align-content: center;
}

.recommentaddform {
	margin-top: 7px;
	width: 450px;
	height: 60px;
	display: flex;
	justify-content: space-between;
	align-content: center;
}

.insertcommentimg {
	background: url('/image/submit.png') no-repeat center;
	background-size: cover;
	width: 50px;
	border: none;
	cursor: pointer;
}

#commentprofile {
	width: 45px;
	height: 45px;
	border-radius: 50%;
	margin-left: 20px;
	margin-top: 7px;
}

.recommentprofile {
	width: 30px;
	height: 30px;
	border-radius: 50%;
}

.input {
	flex: 1;
	height: 40px;
	border: none;
	outline: none;
	border-radius: 20px;
	padding: 5px 10px;
	background-color: #f6f6f6;
	margin-right: 3px;
}

.mominput {
	width: 700px;
	border: none;
	outline: none;
	border-radius: 40px;
	background-color: #f6f6f6;
}

.recontent, .nolike, .yeslike {
	color: #777;
	cursor: pointer;
}

.cminsert {
	background: url(/image/submit.png) no-repeat center;
	background-size: cover;
	width: 25px;
	height: 35px;
	border: none;
	cursor: pointer;
	margin-top: 2px;
}

.commentul {
	position: absolute;
	top: 20px;
	right: 0;
	list-style: none;
	display: none;
	font-size: 0.7em;
	width: 70px;
	padding: 0;
	margin: 0;
	border: none;
}

.commentul:before {
	content: "";
	position: absolute;
	top: -15px;
	right: -1px;
	border-top: 10px solid transparent;
	border-right: 10px solid transparent;
	border-bottom: 10px solid #e6f0fb;
	border-left: 16px solid transparent;
}

.commentul li {
	border: none;
	background-color: #e6f0fb;
	cursor: pointer;
	padding: 8px 12px;
	transition: background-color 0.3s, color 0.3s;
	text-align: center;
}

.commentul li:not(:last-child) {
	margin-bottom: -1px;
}

.commentul li:hover {
	background-color: #cfe0fa;
	color: #3355a0;
}

.ulimg {
	cursor: pointer;
}

.commentmod, .commentdel {
	padding: 5px;
	font-size: 12px;
	color: #555;
}

.commentmod:hover, .commentdel:hover {
	color: #333;
}

.comment .allcomment {
	margin-left: 50px;
}

.comment .comment {
	margin-left: 50px;
}

.modclose {
	cursor: pointer;
}

    </style>
</head>
<body>
<c:set var="root" value="<%=request.getContextPath() %>"/>

<!-- 프로필 수정 -->
<div class="container">
    <!-- Modal -->
    <div class="modal fade" id="infoupdate" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-weight: 600; text-align: center;">프로필 수정</h4>
                </div>

                <div class="modal-body">
                    <div class="title-photo">
                        <span style="font-weight: 700; margin-right: 450px; font-size: 12pt;">프로필 사진</span>
                        <span style="color:lightblue; cursor: pointer;"><a id="btnnewphoto2">수정</a></span>
                        <input type="file" id="newphoto2" name="newphoto2" style="display: none;">

                        <div class="modal-photo">
                            <c:if test="${sessionScope.loginok!=null &&  dto.user_photo!=null}">
                                <img src="${root }/photo/${dto.user_photo}" id="showphoto" style="width: 180px; height: 180px; border-radius: 90px; margin: 3% 34%;
                         border:3px solid gray;">
                            </c:if>

                            <c:if test="${sessionScope.loginok!=null &&  dto.user_photo==null}">
                                <img src="${root }/image/profile.png" id="showphoto" style="width: 180px; height: 180px; border-radius: 90px; margin: 3% 34%;">
                            </c:if>

                        </div>
                    </div>

                    <div class="title-cover">
                        <span style="font-weight: 700; margin-right: 465px; font-size: 12pt;">커버 사진</span>
                        <span style="color:lightblue; cursor: pointer;"><a id="btnnewcover2">수정</a></span>
                        <input type="file" id="newcover2" name="newcover2" style="display: none;">

                        <div class="modal-cover">
                            <c:if test="${sessionScope.loginok!=null &&  dto.user_cover!=null}">
                                <img src="${root }/cover/${dto.user_cover}" id="showcover" style="width: 400px; height: 150px; border-radius: 10px; margin: 3% 16%;">
                            </c:if>

                            <c:if test="${sessionScope.loginok!=null &&  dto.user_cover==null}">
                                <img src="${root }/image/cover.png" id="showcover" style="width: 400px; height: 150px; border-radius: 10px; margin: 3% 16%;">
                            </c:if>
                        </div>
                    </div>


                    <span style="font-weight: 700; font-size: 12pt;">회원님을 소개할 항목을 구성해주세요</span>

                    <div class="modal-intro" style="margin-top: 2%;">
                        <span><b>주소</b></span>
                        <div class="addr">
                            <input id="member_addr" style="width: 250px; margin-bottom: 1%;" name="addr1" type="text" placeholder="주소" readonly required="required"
                                   value="${dto.user_addr.split(',')[0]}">&nbsp;&nbsp;
                            <button type="button" onclick="findAddr()" style="border: none; border-radius: 5px; width: 55px; padding: 4px; font-weight: bold;">검색</button>
                            <br>


                            <input type="text" id="member_addr2" name="addr2" style="width: 250px; margin-bottom: 2%;" placeholder="상세주소" value="${dto.user_addr.split(',')[1]}">
                        </div>

                        <span><b>전화번호</b></span>
                        <div class="hp">
                            <select class="form-control" id="uhp1" name="uhp1" size="1">
                                <option value="010" class="hp1">010</option>
                                <option value="011" class="hp2">011</option>
                                <option value="016" class="hp3">016</option>
                                <option value="070" class="hp4">070</option>
                            </select>&nbsp;-&nbsp;

                            <input type="text" id="uhp2" class="form-control" value="${dto.user_hp.split('-')[1]}">&nbsp;-&nbsp;
                            <input type="text" id="uhp3" class="form-control" value="${dto.user_hp.split('-')[2]}"><br>
                        </div>

                        <span><b>이메일</b></span>
                        <div class="email">
                            <input type="text" id="uemail" class="form-control" value="${dto.user_email }"><br>
                        </div>
                        <span><b>비밀번호</b></span>
                        <div class="password">
                            <button type="button" class="btn btn-primary" onclick="location.href='/user/moveupdatepassword'">비밀번호 수정</button>
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" id="btnupdate" num="${dto.user_num }">정보 수정</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 게시글 수정 -->
<div class="modal fade" id="updatepost" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title" style="font-weight: 700; text-align: center;">게시물 수정</h4>
            </div>

            <div class="modal-body">
                <div style="margin-bottom: 2%; display: flex; align-items: center;">
                    <c:if test="${sessionScope.user_num==dto.user_num }">
                        <img alt="" src="${root }/photo/${dto.user_photo}" style="width: 40px; height: 40px; border-radius: 20px;">
                        <div style="margin-left: 2%;">
                            <span style="font-size: 11pt;"><b>${dto.user_name }</b></span><br>

                            <div id="modalaccess"></div>

                        </div>
                    </c:if>

                    <c:if test="${sessionScope.user_num!=dto.user_num }">
                        <img alt="" src="${root }/photo/${sessionScope.user_photo}" style="width: 40px; height: 40px; border-radius: 20px;">
                        <div style="margin-left: 2%;">
                            <span style="font-size: 11pt;"><b>${sessionScope.name }</b></span><br>

                            <div id="modalaccess"></div>

                        </div>
                    </c:if>
                </div>
                <textarea id="update_content" placeholder="무슨 생각을 하고 계신가요?" style="width: 100%; height:100%; border: none; outline: none;  resize: none;"></textarea>

                <div id="showmodimg" style="border-radius: 10px;"></div>
                <br>


                <input type="file" name="update_file" class="form-control" required="required" multiple="multiple" id="update_file" style="display: none;">

                <button type="button" id="btnmodcontentphoto">사진/동영상 선택</button>
                <button type="button" id="remove_photo_btn" style="outline: none;">사진 모두 지우기</button>
            </div>

            <div class="modal-footer" style="text-align: center;">
                <button type="button" class="btn btn-default" data-dismiss="modal" id="btnupdate2" style="background-color: #3578E5; width: 30%; color: white;">수정</button>
                <button type="button" class="btn btn-default" data-dismiss="modal" style="width: 30%;">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- 게시글 작성 -->
<div class="container">
    <!-- Modal -->
    <div class="modal fade" id="contentwrite" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-weight: 700; text-align: center;">게시물 만들기</h4>
                </div>

                <div class="modal-body">
                    <c:if test="${sessionScope.user_num==dto.user_num }">
                        <div style="margin-bottom: 2%; display: flex; align-items: center;">

                            <img src="${root }/photo/${dto.user_photo}" style="width: 40px; height: 40px; border-radius: 20px;">

                            <div style="margin-left: 2%;">
                                <span style="font-size: 11pt;"><b>${dto.user_name }</b></span><br>

                                <select class="form-control" name="post_access" id="post_access" style="background-color: #F0F2F5;">
                                    <option value="all">전체공개</option>
                                    <option value="follower">팔로워 공개</option>
                                    <option value="onlyme">나만보기</option>
                                </select>

                            </div>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.user_num!=dto.user_num }">
                        <div style="margin-bottom: 2%; display: flex; align-items: center;">

                            <img src="${root }/photo/${sessionScope.user_photo}" style="width: 40px; height: 40px; border-radius: 20px;">

                            <div style="margin-left: 2%;">
                                <span style="font-size: 11pt;"><b>${sessionScope.name }</b></span><br>

                                <span style="border-radius: 5px; padding: 4px; background-color: #F0F2F5;"><b><i class="fa-solid fa-user-group"></i>팔로워 공개</b></span>

                            </div>
                        </div>
                    </c:if>

                    <div style="height: 150px;">
                        <textarea id="post_content" placeholder="무슨 생각을 하고 계신가요?" style="width: 100%; height:100%; border: none; outline: none;  resize: none;"></textarea>
                    </div>
                    <div class="show" id="show" style="position: relative;">
                        <img id="showimg" style="display:none; width: 500px; height: 150px; border: 1px solid gray; border-radius: 10px;"><br>
                        <video id="showvideo" style="display: none; width: 500px; height: 150px; border: 1px solid gray; border-radius: 10px;" controls="controls"></video>
                        <p id="showtext" style="display:none; position: absolute; top: 65px; left: 190px; font-weight: bold;">사진/동영상 추가</p>
                    </div>

                    <input type="file" multiple="multiple" id="contentphoto" name="contentphoto" style="display: none;">
                    <button type="button" id="btncontentphoto" style="margin-top: 1%;">사진/동영상 선택</button>
                    <button type="button" id="remove_contentphoto_btn" style="outline: none;">사진 모두 지우기</button>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" id="btnwrite" num="${dto.user_num }">게시</button>
                </div>

            </div>

        </div>
    </div>

</div>

<!-- 댓글 -->
<button type="button" class="btn btn-info btn-lg btncommentmodal hide" data-toggle="modal" data-target="#commentmodal"></button>
<!-- comment -->
<div id="commentmodal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content commentmodal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title commenth4"></h4>
            </div>
            <div class="modal-body commentmodal-body" style="max-height: 800px;">
                <!-- 타임라인 -->
                <sectiontime id="timesection"></sectiontime>
                <br>
                <hr>
                <section1 id="commentsection">
                    <!-- 댓글 나올 부분 -->
                </section1>
                <button type="button" class="btn btn-success" id="addcomment">댓글 더보기</button>
            </div>
            <div class="modal-footer" style="height: 80px; padding: 0;">
                <form method="post" class="form-inline" id="form">
                    <input type="hidden" name="comment_num" value="0">
                    <input type="hidden" name="post_num" id="inputhidden-post_num">
                    <input type="hidden" name="guest_num" id="inputhidden-guest_num">
                    <div id="commentaddform">
                        <c:if test="${sessionScope.user_photo != null }">
									<img src="/photo/${sessionScope.user_photo }" id="commentprofile">
								</c:if>
								<c:if test="${sessionScope.user_photo == null }">
									<img src="/image/noimg.png" id="commentprofile">
								</c:if>
                        <input hidden="hidden"/>
                        <input type="text" class="mominput" name="comment_content" placeholder="댓글을 입력하세요" id="commentinput">
                        <button type="button" id="insertcommentbtn" class="insertcommentimg"
									style="margin-right: 20px;"></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="mypage">

    <div class="cover">

	<div style="width: 100%; height: 100%; overflow: hidden;">
        <c:if test="${sessionScope.loginok!=null && dto.user_cover!=null }">
            <img src="${root }/cover/${dto.user_cover }" style="width: 100%; height: 100%; object-fit:cover;">
        </c:if>

        <c:if test="${sessionScope.loginok!=null && dto.user_cover==null }">
            <img src="${root }/image/cover.png" style="width: 100%; height: 100%; object-fit:cover;">
        </c:if>
	</div>
        <input type="file" id="newcover" style="display: none;" num="${dto.user_num }">

        <!-- 수정 시 호출 -->
        <c:if test="${sessionScope.user_num==dto.user_num }">
            <button type="button" id="btnnewcover">
                <i class="fa-solid fa-camera fa-xl - 1.5em - 24px"></i>&nbsp;&nbsp;커버 사진 추가
            </button>
        </c:if>
    </div>

    <div class="main-profile">
        <div class="dropdown">

            <input type="file" id="newphoto" style="display: none;" num="${dto.user_num }">

            <c:if test="${sessionScope.loginok!=null && dto.user_photo!=null }">
            	<div data-toggle="dropdown" style="position: relative; left: 250px; bottom: 80px; width: 180px; height: 180px; 
            	display: inline-flex; overflow: hidden; border: 3px solid gray; border-radius: 100px">
                <img alt="" src="${root }/photo/${dto.user_photo}"
                     style="width: 100%; height: 100%; object-fit:cover; cursor: pointer;">
                </div>
            </c:if>

            <c:if test="${sessionScope.loginok!=null && dto.user_photo==null }">
            	<div data-toggle="dropdown" style="position: relative; left: 250px; bottom: 80px; width: 180px; height: 180px; 
            	display: inline-flex; overflow: hidden; border-radius: 100px">
                <img alt="" src="${root }/image/profile.png"
                     style="width: 100%; height: 100%; object-fit:cover; cursor: pointer;">
                </div>
            </c:if>
            
            <c:if test="${sessionScope.user_num==dto.user_num }">
            	<div style="display: inline-flex; position: relative; left: 195px; bottom: 80px;">
            	<img alt="" src="${root }/image/camera.png" style="width: 50px; height: 50px; cursor: pointer;" class="userphotochangeimg">
                </div>
            </c:if>
            <c:if test="${sessionScope.user_num!=dto.user_num }">
            	<div style="display: inline-flex; position: relative; left: 195px; bottom: 80px; 
            	visibility: hidden;">
            	<img alt="" src="${root }/image/camera.png" style="width: 50px; height: 50px; cursor: pointer;" class="userphotochangeimg">
                </div>
            </c:if>

			<div style="display: inline-flex; flex-direction:column; position: relative; left: 200px; bottom: 120px;">
            <span style="font-size: 22pt; font-weight: bold;">${dto.user_name }</span>
            <span style="font-size: 13pt; font-weight: bold; color:#65676b;">
                     <a href="${root }/following/followlist?from_user=${dto.user_num}" style="color: #65676b;">친구 ${tf_count}명 </a>
                     </span>
            </div>


            <ul class="dropdown-menu" style="position: absolute; left: 200px; top: 100px;">
            	<c:if test="${dto.user_photo==null }">
            		<li><a href="${root }/image/noimg.png" target="_new" style="text-decoration: none; outline: none;">프로필
                    사진 보기</a></li>
            	</c:if>
            	<c:if test="${dto.user_photo!=null }">
                	<li><a href="${root }/photo/${dto.user_photo}" target="_new" style="text-decoration: none; outline: none;">프로필
                    사진 보기</a></li>
                </c:if>
                <c:if test="${sessionScope.user_num==dto.user_num }">
                    <li><a href="#" id="btnnewphoto">프로필 사진 업데이트</a></li>
                </c:if>
            </ul>
        </div>

        <div style="float:right; margin-right: 3%; margin-top: 2%;">
            <c:if test="${sessionScope.user_num!=dto.user_num && checkfollowing !=1 }">
                <c:if test="${checkfollower ==1 }">
                    <button type="button" class="btnfollow" id="btnfollow" from_user="${sessionScope.user_num }" to_user="${dto.user_num }">
                        <i class="fa-solid fa-user-group"></i>&nbsp;맞팔로우 하기
                    </button>
                </c:if>

                <c:if test="${checkfollower !=1 }">
                    <button type="button" class="btnfollow" id="btnfollow" from_user="${sessionScope.user_num }" to_user="${dto.user_num }">
                        <i class="fa-solid fa-user-group"></i>&nbsp;팔로우 하기
                    </button>
                </c:if>
            </c:if>

            <c:if test="${sessionScope.user_num!=dto.user_num && checkfollowing ==1 }">
                <c:if test="${checkfollower ==1 }">
                    <button type="button" class="btnunfollow" id="btnunfollow" to_user="${dto.user_num }">
                        <i class="fa-solid fa-user-group"></i>&nbsp;맞팔로우 취소
                    </button>
                </c:if>

                <c:if test="${checkfollower !=1 }">
                    <button type="button" class="btnunfollow" id="btnunfollow" to_user="${dto.user_num }">
                        <i class="fa-solid fa-user-group"></i>&nbsp;팔로우 취소
                    </button>
                </c:if>
            </c:if>

			<c:if test="${sessionScope.user_num!=dto.user_num }">
            <button type="button" class="btnmessage"><i class="fa-solid fa-comment"></i>&nbsp;메시지 보내기</button>
			</c:if>

            <c:if test="${sessionScope.user_num==dto.user_num }">
                <button type="button" class="btnprofile" data-toggle="modal" data-target="#infoupdate" style="border-radius: 5px; border: none;">
                    <i class="fa-solid fa-pencil fa-xl - 1.5em - 24px"></i>&nbsp;&nbsp;프로필 편집
                </button>
            </c:if>
        </div>
    </div>

    <div class="menu">
        <hr style="border: 1px solid lightgray; margin:0px;">
        <div style="font-weight: bold; font-size: 15pt; display: inline-flex; align-items: center; height: 100%;">
            <a href="/user/mypage?user_num=${dto.user_num }" style="color: black;"><span>게시글</span></a>
            <!-- <a href="/user/info" style="color: black;"><span>정보</span></a> -->
            <a href="${root }/following/followlist?from_user=${dto.user_num}" style="color: black;"><span>친구</span></a>
        </div>
    </div>

    <div class="mypage-main">
        <div class="left">
            <div class="intro">
                <span><b style="font-size: 16pt;">소개</b></span>
                <div class="intro-info">
                    <span>&nbsp;<i class="fa-solid fa-house fa-2x - 2em"></i>&nbsp;&nbsp;&nbsp;&nbsp;<b>${dto.user_addr.replaceAll(',', ' ') }</b>&nbsp;&nbsp;</span><br>
                    <span>&nbsp;&nbsp;<i class="fa-solid fa-location-dot  fa-2x - 2em"></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>${dto.user_addr.substring(0, 2)}</b>&nbsp;&nbsp;출신</span><br>
                    <span class="followerListBtn" style="cursor: pointer;"><i class="fa-solid fa-wifi fa-2x - 2em"></i>&nbsp;&nbsp;&nbsp;&nbsp;<b>${followercount }</b>&nbsp;&nbsp;명이 팔로우함</span><br>
                    <span>&nbsp;<i class="fa-solid fa-envelope fa-2x - 2em"></i>&nbsp;&nbsp;&nbsp;&nbsp;<b>${dto.user_email }</b>&nbsp;&nbsp;</span><br>
                    <span>&nbsp;&nbsp;<i class="fa-solid fa-mobile-screen-button fa-2x - 2em"></i>&nbsp;&nbsp;&nbsp;&nbsp;<b>${dto.user_hp}</b>&nbsp;&nbsp;</span>
                </div>
            </div>

            <div class="galary">
                <b style="font-size: 16pt;">사진/동영상</b>
                <div class="galary-photoall">
                    <c:set var="counter" value="0"/>
                    <c:forEach var="pdto" items="${postlist}" varStatus="i">
                        <c:if test="${counter < 9 && pdto.post_file != 'no'}">
                            <c:if test="${!fn:contains(pdto.post_file, '.mp4')}">
                                <c:forEach var="file" items="${fn:split(pdto.post_file, ',')}" varStatus="j">
                                    <c:if test="${j.count <= 9 - counter}">
                                    <div style="overflow: hidden;" class="galary-photo galary-photo-${j.count}">
                                        <a href="${root}/post_file/${file}" target="_new" style="text-decoration: none; outline: none;">
                                            <img src="${root}/post_file/${file}" style="object-fit:cover; width: 100%; height: 100%">
                                        </a>
                                    </div>
                                        <c:set var="counter" value="${counter + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <c:if test="${fn:contains(pdto.post_file, '.mp4')}">
                                <c:forEach var="file" items="${fn:split(pdto.post_file, ',')}" varStatus="j">
                                    <c:if test="${j.count <= 9 - counter}">
                                    <div style="overflow: hidden;" class="galary-video galary-video-${j.count}">
                                        <video src="/post_file/${file}" controls="controls" 
                                        muted="muted" style="width: 100%; height: 100%; obejct-fit: cover;"></video>
                                        <c:set var="counter" value="${counter + 1}"/>
                                    </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:if>

                        <c:if test="${counter >= 9}">
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <div class="friend">
                <b style="font-size: 16pt;">친구</b><br>
                <span style="font-size: 12pt;">친구</span> <b>${followcount }</b>명
                <div class="friend-photoall">
                    <c:forEach var="fdto" items="${tflist }" varStatus="i">
                        <div style="margin: 1% 1% 0.25% 1%;">
                            <div>
                            	<div class="friend-photo" style="overflow: hidden;">
	                                <c:if test="${ fdto.user_photo!=null }">
	                                    <a href="${root }/user/mypage?user_num=${fdto.user_num}"><img src="${root }/photo/${fdto.user_photo}" 
	                                    style="width: 100%; height: 100%; object-fit:cover;"></a>
	                                </c:if>
	                                <c:if test="${fdto.user_photo==null }">
	                                    <a href="${root }/user/mypage?user_num=${fdto.user_num}"><img src="${root }/image/noprofile.png" 
	                                    style="width: 100%; height: 100%; object-fit:cover;"></a>
	                                </c:if>
                                </div>
                                <div>
                                    <span><b>${fdto.user_name }</b></span><br>
                                    <c:if test="${fdto.tf_count>0 }">
                                        <span>함께 아는 친구 ${fdto.tf_count }명</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="right">
            <div class="write" style="display: inline-flex; align-items: center;">
                <div class="searcharea">
                    <div style="width: 800px; display: inline-flex; align-items: center; margin-left: 20px; overflow: hidden;">
                        <c:if test="${sessionScope.user_num!=dto.user_num }">
                        	<div style="width: 40px; height: 40px; border-radius: 100px;">
                            	<img alt="" src="${root }/photo/${sessionScope.user_photo}" style="object-fit: cover; height: 100%; width: 100%;">
                            </div>
                            &nbsp;&nbsp;&nbsp;
                        </c:if>

                        <c:if test="${sessionScope.user_num==dto.user_num }">
                        	<div style="width: 40px; height: 40px; border-radius: 100px; overflow: hidden;">
                            	<img alt="" src="${root }/photo/${dto.user_photo}" style="object-fit: cover; height: 100%; width: 100%;">
                            </div>
                            &nbsp;&nbsp;&nbsp;
                        </c:if>

                        <c:if test="${sessionScope.user_num==dto.user_num }">
                            <div style="background-color: #F0F2F5; border-radius: 60px; padding-left: 2%">
                                <input type="button" data-toggle="modal" data-target="#contentwrite" name="contentwirte"
                                       style="width:700px; border: none; text-align:left; background: none; outline: none; font-size: 15pt; padding: 10px;" value="무슨 생각을 하고 계신가요?">
                            </div>
                        </c:if>

                        <c:if test="${sessionScope.user_num!=dto.user_num }">
                            <div style="background-color: #F0F2F5; border-radius: 60px; padding-left: 2%">
                                <input type="button" data-toggle="modal" data-target="#contentwrite" name="contentwirte"
                                       style="width:700px; border: none; text-align:left; background: none; outline: none; font-size: 15pt; padding: 10px;" value="${dto.user_name } 님에게 글을 남겨보세요...">
                            </div>
                        </c:if>

                    </div>
                </div>
            </div>

            <c:forEach var="adto" items="${alllist }">
                <div class="content">
                    <div class="divmain">
                        <div class="top">
                            <div class="top-user">
                                <c:if test="${adto.type=='post' }">
                                <div style="width: 40px; height: 40px; border-radius: 100px; margin: 10px; overflow: hidden;">
                                    <a href="${root }/user/mypage?user_num=${dto.user_num}">
                                    	<c:if test="${dto.user_photo!=null }">
                                    		<img alt="" src="${root }/photo/${dto.user_photo}" style="object-fit: cover; height: 100%; width: 100%;">
                                    	</c:if>
                                    	
                                    	<c:if test="${dto.user_photo==null }">
                                    		<img alt="" src="${root }/image/noimg.png" style="object-fit: cover; height: 100%; width: 100%;">
                                    	</c:if>
                                    </a>
                                </div>
                                </c:if>

                                <c:if test="${adto.type=='guest' }">
                                <div style="width: 40px; height: 40px; border-radius: 100px; margin: 10px; overflow: hidden;">
                                	<c:if test="${adto.dto.user_photo!=null }">
                                    	<a href="${root }/user/mypage?user_num=${adto.dto.user_num}"><img alt="" src="${root }/photo/${adto.dto.user_photo}" style="object-fit: cover; height: 100%; width: 100%;"></a>
                                    </c:if>
                                    
                                    <c:if test="${adto.dto.user_photo==null }">
                                    	<a href="${root }/user/mypage?user_num=${adto.dto.user_num}"><img alt="" src="${root }/image/noimg.png" style="object-fit: cover; height: 100%; width: 100%;"></a>
                                    </c:if>
                                </div>    
                                </c:if>
                                <div class="top-writeday">
                                       <span><b><a href="${root }/user/mypage?user_num=${adto.dto.user_num}" style="color: black;">${adto.dto.user_name }</a><c:if test="${adto.type=='guest' }"><i class="fa-solid fa-caret-right"></i></c:if>
                                       <a href="${root }/user/mypage?user_num=${dto.user_num}" style="color: black;">${dto.user_name }</a><br></b>
                                       ${adto.post_time }
                                       <b>
                                       <c:if test="${adto.post_access =='follower'}">
                                           <i class="fa-solid fa-user-group"></i>
                                       </c:if>

                                       <c:if test="${adto.post_access =='all'}">
                                           <i class="fa-solid fa-earth-americas"></i>
                                       </c:if>

                                       <c:if test="${adto.post_access =='onlyme'}">
                                           <i class="fa-solid fa-lock"></i>
                                       </c:if>

                                       </b></span>

                                </div>
                                <c:if test="${sessionScope.user_num==dto.user_num}">
                                    <div class="dropdown" style="margin-left: 70%;">
                                        <i class="fa-solid fa-ellipsis fa-2x - 2em" data-toggle="dropdown" style=" cursor: pointer;"></i>
                                        <ul class="dropdown-menu dropdown-menu-right" style="position: absolute; top:20px;">
                                            <li><a href="#" class="delpost" post_num=${adto.post_num } num=${dto.user_num } type=${adto.type }>게시글 삭제</a></li>
                                            <c:if test="${adto.type!='guest' }">
                                                <li><a href="#" class="modpost" data-toggle="modal" data-target="#updatepost" post_num=${adto.post_num } type=${adto.type } user_num=${adto.user_num }>게시글 수정</a></li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </c:if>

                                <c:if test="${sessionScope.user_num==adto.user_num && adto.type=='guest'}">
                                    <div class="dropdown" style="margin-left: 70%;">
                                        <i class="fa-solid fa-ellipsis fa-2x - 2em" data-toggle="dropdown" style=" cursor: pointer;"></i>
                                        <ul class="dropdown-menu dropdown-menu-right">
                                            <li><a href="#" class="delpost" post_num=${adto.post_num } num=${dto.user_num } type=${adto.type }>게시글 삭제</a></li>
                                            <li><a href="#" class="modpost" id="updatepost" data-toggle="modal" data-target="#updatepost" post_num=${adto.post_num } type=${adto.type } user_num=${adto.user_num }>게시글 수정</a></li>
                                        </ul>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="center">
                            <div class="center-up">${adto.post_content }</div>
                            <div class="slider center-down" id="dto-${adto.post_num}">


                                <c:if test="${fn:contains(adto.post_file, '.mp4')}">
                                    <div class="fileimg" style="text-align: center;">
                                        <c:if test="${adto.post_file!='no' && adto.type=='post'}">
                                            <video src="/post_file/${adto.post_file }" controls="controls" muted="muted" 
                                            style='width: 60%;height: 100%; margin: 0 auto;'></video>
                                        </c:if>
                                        <c:if test="${adto.post_file!='no' && adto.type=='guest'}">
                                            <video src="/guest_file/${adto.post_file }" controls="controls" muted="muted" 
                                            style='width: 60%;height: 100%; margin: 0 auto;'></video>
                                        </c:if>
                                    </div>
                                </c:if>

                                <c:if test="${!fn:contains(adto.post_file, '.mp4')}">
                                    <c:if test="${adto.post_file!='no' && adto.type=='post'}">
                                        <c:forTokens items="${adto.post_file }" delims="," var="file">
                                            <div class="fileimg">
                                                <a href="/post_file/${file }" target="_new" style="text-decoration: none; outline: none;">
                                                    <img src="/post_file/${file }" style="width: 60%;height: 100%; margin: 0 auto;">
                                                </a>
                                            </div>
                                        </c:forTokens>
                                    </c:if>

                                    <c:if test="${adto.post_file!='no' && adto.type=='guest'}">
                                        <c:forTokens items="${adto.post_file }" delims="," var="file">
                                            <div class="fileimg">
                                                <a href="/post_file/${file }" target="_new" style="text-decoration: none; outline: none;">
                                                    <img src="/guest_file/${file }" style="width: 60%;height: 100%; margin: 0 auto;">
                                                </a>
                                            </div>
                                        </c:forTokens>
                                    </c:if>
                                </c:if>


                            </div>
                        </div>

                        <div class="bottom">
                            <hr style="border: 1px solid #ced0d4; margin-bottom: 1%;">

                            <div class="bottom-up">
                                <div class="like" style="margin-bottom: 1%;">
                                    <c:if test="${adto.likecheck ==0 }">
                                       <span class="bottom-left2 liketoggle" likehide1_num="likehide1${adto.post_num}"
                                             likeshow1_num="likeshow1${adto.post_num}" post_num="${adto.post_num }">

                                       <span class="like" id="likehide1${adto.post_num}" likehide1_num="likehide1" ${adto.post_num}" likeshow1_num="likeshow1${adto.post_num}"
                                       post_num="${adto.post_num }">

                                       <span style="cursor: pointer;"> <i class="img_like fa-regular fa-thumbs-up fa-2x - 2em" post_num="${adto.post_num }" type="${adto.type }"></i></span>

                                          <c:if test="${adto.like_count==0 }">
                                              &nbsp;좋아요
                                          </c:if>

                                          <c:if test="${adto.like_count !=0 }">
                                              &nbsp;좋아요 ${adto.like_count}명
                                          </c:if>
                                       </span>

                                        <span class="dlike" id="likeshow1${adto.post_num}" user_num="${sessionScope.user_num}" post_num="${adto.post_num }" style="display: none;">
                                       <span> <i class="img_dlike fa-solid fa-thumbs-up fa-2x - 2em" style="cursor: pointer; color: #3578E5;" post_num="${adto.post_num }" type="${adto.type }"></i></span>
                                       <c:if test="${adto.like_count==0 }">
                                           &nbsp;좋아요 회원님
                                       </c:if>

                                       <c:if test="${adto.like_count !=0 }">
                                           &nbsp;좋아요 회원님 외${adto.like_count}명
                                       </c:if>
                                    </span>
                                        </span>
                                    </c:if>

                                    <c:if test="${adto.likecheck !=0 }">
                                 <span class="bottom-left2 liketoggle2" style="cursor: pointer" likehide2_num="likehide2${adto.post_num}" likeshow2_num="likeshow2${adto.post_num}"
                                       user_num="${sessionScope.user_num}" post_num="${adto.post_num }">

                                    <span id="likehide2${adto.post_num}" class="dlike" user_num="${sessionScope.user_num}" likehide1_num="likehide1${adto.post_num}"
                                          likeshow1_num="likeshow1${adto.post_num}" post_num="${adto.post_num }">
                                       <span> <i class="img_dlike fa-solid fa-thumbs-up fa-2x - 2em" style="color: #3578E5; cursor: pointer;" post_num="${adto.post_num }" type="${adto.type }"></i></span>
                                       <c:if test="${adto.like_count!= 1}">
                                           &nbsp;좋아요 회원님 외 ${adto.like_count-1}명
                                       </c:if>
                                       <c:if test="${adto.like_count ==1 }">
                                           &nbsp;좋아요 회원님
                                       </c:if>
                                    </span>



                                 <span user_num="${sessionScope.user_num}" id="likeshow2${adto.post_num}" class="like" post_num="${adto.post_num }" style="display: none;"> <span>
                                 <i class="img_like fa-regular fa-thumbs-up fa-2x - 2em" post_num="${adto.post_num }" type="${adto.type }"></i>
                                 <c:if test="${adto.like_count== 1}">
                                     &nbsp;좋아요
                                 </c:if>
                                 <c:if test="${adto.like_count!= 1}">
                                     &nbsp;좋아요 ${adto.like_count -1 } 명
                                 </c:if>
                                    </span>
                                 </span>


                                 </span>
                                    </c:if>
                                </div>

                                <div class="div-comment">

                                    <i class="img_comment fa-regular fa-comment fa-2x - 2em" style="cursor: pointer;" user_name="${adto.user_name }" post_num="${adto.post_num }" type="${adto.type }"></i>&nbsp;댓글 ${adto.comment_count }
                                </div>
                            </div>

                        </div>

                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</div>


</body>
</html>