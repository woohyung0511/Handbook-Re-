<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
<link
	href="https://fonts.googleapis.com/css2?family=Jua&family=Stylish&family=Sunflower&display=swap"
	rel="stylesheet">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.css" />
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery.slick/1.6.0/slick.min.js"></script>

<script src="https://kit.fontawesome.com/2663817d27.js" crossorigin="anonymous"></script>


<script type="text/javascript">
   $(function() {
	   wsOpen();
	   
      offset = ${offset};
      commentoffset = ${commentoffset};
      modalScrollPosition = 0;
      
      $("#showmodimg_insert").hide();

      $("#insertbtn").click(function() {

         var post_access = $("#post_access").val();
         var post_content = $("#post_content").val();
         var user_num = $("#user_num").val();
         var file=$("#post_file").val();
         var files = $("#post_file")[0].files;

         //var data="num="+updatenum+"&name="+updatename+"&hp="+updatehp+"&email="+updateemail+"&addr="+updateaddr;
         //var data=$("#postInsert").serialize();

         /*        var form = new FormData();
               form.append("photo", $("#post_file")[0].files[0]);  */

         var form = new FormData();

         for (var i = 0; i < files.length; i++) {
            form.append("photo", files[i]);
         }

         form.append("post_access", post_access);
         form.append("post_content", post_content);
         form.append("user_num", user_num);
         
         if(post_content == "" && file == "")
        	 alert("사진 또는 내용을 입력해주세요");
         else{
        	 $.ajax({

                 type : "post",
                 dataType : "text",
                 processData : false,
                 contentType : false,
                 data : form,
                 url : "insertpost",
                 success : function() {
                    location.reload();
                 }
              });
         }
         
      });

     /* $(document).on("click", ".postmenu", function() {
         var user_num = $(this).attr("user_num");
         var post_num = $(this).attr("post_num");
		
         $("#" + post_num).toggle();

      }); */
    
      
      $(document).on('click', '.postmenu', function() {
    	    var i = $('.postmenu').index(this);
    	    var user_num = $(this).attr("user_num");
    	    var post_num = $(this).attr("post_num");
    	    
    	    $.each($(".postsubmenu"), function(k, elt) {
    	        if (i == k) {
    	            $(elt).toggle();
    	        } else {
    	            $(elt).hide();
    	        }
    	    });
    	});

      
      
      
      

      $(document).on("click", ".posthide", function() {
         var divpost_num = $(this).attr("divpost_num");
         var divspost_num = $(this).attr("divspost_num")

         $("#" + divpost_num).hide();

         $("#" + divspost_num).show();

      });

      $(document).on("click", ".showbtn", function() {
         var divpost_num = $(this).attr("divpost_num");
         var divspost_num = $(this).attr("divspost_num")

         $("#" + divpost_num).show();

         $("#" + divspost_num).hide();

      });

      $(document).on("click", ".liketoggle", function() {

         var likeshow1_num = $(this).attr("likeshow1_num");
         var likehide1_num = $(this).attr("likehide1_num");

         $("#" + likeshow1_num).toggle();
         $("#" + likehide1_num).toggle();

      });
      
      
      $(document).on("click", ".follow", function() {

          var followpost_num = $(this).attr("followpost_num");
          var unfollowpost_num= $(this).attr("unfollowpost_num");
          $("#" + followpost_num).toggle();
          $("#" + unfollowpost_num).toggle();

       });
      
      $(document).on("click", ".unfollow", function() {

          var followpost_num = $(this).attr("followpost_num");
          var unfollowpost_num= $(this).attr("unfollowpost_num");

          $("#" + followpost_num).toggle();
          $("#" + unfollowpost_num).toggle();

       });
      
      
      

      $(document).on("click", ".liketoggle2", function() {

         var likeshow2_num = $(this).attr("likeshow2_num");
         var likehide2_num = $(this).attr("likehide2_num");

         /*       
               $(".likeshow2").toggle();
               $(".likehide2").toggle(); */

         $("#" + likeshow2_num).toggle();
         $("#" + likehide2_num).toggle();

      });

      $(document).on("click", ".userimg", function() {
         var num = $(this).attr("user_num");

         location.href = "/user/mypage?user_num=" + num;

      });

      $(document).on("click", "#postdelete", function() {
         delnum = $(this).attr("post_num");

         $.ajax({
            type : "get",
            dataType : "text",
            url : "delete",
            data : {
               "post_num" : delnum
            },
            success : function() {
               location.reload();
            }
         })
      })

      //수정버튼 클릭 시 모달에 데이터 넣기
      $(document).on("click", "#postupdate", function() {
         updatenum = $(this).attr("post_num");

         $.ajax({
            type : "get",
            dataType : "json",
            url : "updateform",
            data : {
               "post_num" : updatenum
            },
            success : function(res) {
               $("#update_access").val(res.post_access);
               $("#update_content").val(res.post_content);
               
               var files=(res.post_file).split(',');
               
               var filename="";
               
               $.each(files,function(i,ele){
            	   if(ele.includes(".mp4")){
            		   filename+="<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='/post_file/"+ele+"'>";
            	   }else{
            		   filename+="<img style='width: 95%; max-height:350px; object-fit:cover;'";
                	   filename+="src='/post_file/"+ele+"'>";   
            	   }
            	   
            	   if(ele=="no"){
            		   filename="";
            		   $("#showmodimg").hide();
            	   }
               })
               
               $("#showmodimg").html(filename);
            }
         })
      })

      $(document)
            .on(
                  "click",
                  "#updatetbtn",
                  function() {

                  
                     var update_access=$("#update_access").val();
                     var update_content=$("#update_content").val();
                     
                     var form = new FormData();

                     var files=$("#update_file")[0].files;
                     
                     for (var i = 0; i < files.length; i++) {
                          form.append("photo", files[i]);
                      }
                     form.append("post_num",updatenum);
                     form.append("post_access",update_access);
                     form.append("post_content",update_content);
                     form.append("photodel",$("#update_file").attr("photodel"));
                     
                     $.ajax({
                        type: "post",
                        dataType: "text",
                        url: "update",
                        processData: false,
                        contentType: false,
                        data: form,
                        success: function(){
                           location.reload();
                        }
                     });
                  });

      $(document).on("click", ".like", function() {
         var post_num = $(this).attr("post_num");
         var user_num = $(this).attr("user_num");

         $.ajax({
            type : "get",
            dataType : "text",
            url : "likeinsert",
            data : {
               "post_num" : post_num,
               "user_num" : user_num
            },
            success : function() {
            	//게시글 좋아요 알림
           	 	ws.send('{"type":"plike","sender_num":"${sessionScope.user_num}","post_num":"'+post_num+'","guest_num":"null"}');
            }
         })
      })

      $(document).on("click", ".dlike", function() {
         var post_num = $(this).attr("post_num");
         var user_num = $(this).attr("user_num");

         $.ajax({
            type : "get",
            dataType : "text",
            url : "likedelete",
            data : {
               "post_num" : post_num,
               "user_num" : user_num
            },
            success : function() {
            }
         })
      });
      

      $(document).on("click", ".follow", function() {

         var from_user = $(this).attr("from_user");
         var to_user = $(this).attr("to_user");

         $.ajax({
            type : "get",
            dataType : "text",
            url : "followinginsert",
            data : {
               "from_user" : from_user,
               "to_user" : to_user
            },
            success : function() {
            	ws.send('{"type":"follow","receiver_num":"'+to_user+'","sender_num":"${sessionScope.user_num}"}');
            }
         })
      })

      $(document).on("click", ".unfollow", function() {
         var to_user = $(this).attr("to_user");
         $.ajax({
            type : "get",
            dataType : "text",
            url : "followingdelete",
            data : {
               "to_user" : to_user
            },
            success : function() {

            }
         })
      })

      //사진 넘기면서 보기
   $(document).ready(function() {
      $(".sliders").each(function() {
         var itemId = this.id;
         var slider_num = itemId.split("-")[1];
         initializeSlider(itemId);
      });
   });
      
      $("#btncontentphoto").click(function(){
    	  $("#post_file").trigger("click");
    });

      $("#post_file").change(function(){
      		////array로
			var fileArr = Array.from(this.files);
			
			var s="";
			var videoCount=0;
			
			$.each(fileArr,function(i,ele){
				var file = ele;
				var reader = new FileReader();
				reader.onload = function(e) {
					if((e.target.result).includes("video/mp4")){
						s+="<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='"+e.target.result+"'>";
						videoCount=videoCount+1;
					}else{
						s+="<img style='width: 95%; max-height:350px; object-fit:cover;' src='"+e.target.result+"'>";	
					}
					
					$("#showmodimg_insert").html(s);
					
					if(s.includes("video/mp4")&&s.includes("image/")){
						alert("동영상과 사진은 함께 올릴 수 없습니다.");
						$("#post_file").val(null);
						$("#showmodimg_insert").html("");
						$("#showmodimg_insert").hide();
					}else if(videoCount>=2){
						alert("동영상은 한 개만 올릴 수 있습니다.");
						$("#post_file").val(null);
						$("#showmodimg_insert").html("");
						$("#showmodimg_insert").hide();
					}
				};
				reader.readAsDataURL(file);
			})
			
			$("#showmodimg_insert").html(s);
			$("#showmodimg_insert").show();
      });
  
  
  $("#btncontentphoto").click(function(){
         //$("#showimg").show();
      });
  
  

      
  
  
  
  //강제 호출
/*   $("#btnmodcontentphoto").click(function(){
     
     $("#update_file").trigger("click");
  });
   */
/*   //게시물 수정 시 사진 미리보기
  $("#update_file").change(function(){
     
      if($(this)[0].files[0]){
       var reader=new FileReader();
       reader.onload=function(e){
        $("#showmodimg").attr("src",e.target.result);
        $("#showtext").hide();
       }
       reader.readAsDataURL($(this)[0].files[0]);
      }
  });
   */

   
  $(document).ready(function() {
		$("#btnmodcontentphoto").click(function() {
			$("#update_file").click();
		});
		
		$("#update_file").change(function() {
			////array로
			var fileArr = Array.from(this.files);
			
			var s="";
			var videoCount=0;
			
			$.each(fileArr,function(i,ele){
				var file = ele;
				var reader = new FileReader();
				reader.onload = function(e) {
					if((e.target.result).includes("video/mp4")){
						s+="<video style='width: 95%; max-height:350px; object-fit:cover;' controls=\"controls\" src='"+e.target.result+"'>";
						videoCount=videoCount+1;
					}else{
						s+="<img style='width: 95%; max-height:350px; object-fit:cover;' src='"+e.target.result+"'>";	
					}
					$("#showmodimg").html(s);
					
					if(s.includes("video/mp4")&&s.includes("image/")){
						alert("동영상과 사진은 함께 올릴 수 없습니다.");
						$("#update_file").val(null);
						$("#showmodimg").html("");
						$("#showmodimg").hide();
					}else if(videoCount>=2){
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
		
		$("#remove_photo_btn").click(function() {
			$("#update_file").val("");
			$("#showmodimg").html("");
			$("#update_file").val(null);
			$("#update_file").attr("photodel","true");
			$("#showmodimg").hide();
			//$("#showmodimg").attr("src", "");
		});
		
		$("#remove_contentphoto_btn").click(function() {
			$("#post_file").val("");
			$("#showmodimg_insert").html("");
			$("#post_file").val(null);
			$("#showmodimg_insert").hide();
			//$("#showmodimg").attr("src", "");
		});
	});


      
   window.onscroll = function(e) {
       if((window.innerHeight + window.scrollY) >= document.body.scrollHeight) {
          offset=offset+10;
          $.ajax({
            type:"get",
            dataType:"json",
            url:"scroll",
            data:{"offset":offset},
            success:function(res){
               
               $.each(res,function(i,dto){
                  
                  setTimeout(function(){
                     var s='';

                     if (dto.post_file != 'no') {

                        s += "<div class='shows' id='divs" + dto.post_num + "'>";
                        s += "<div class='showtext'>게시물을 숨겼습니다. 다시보려면 게시물을 눌러주세요.</div>";
                        s += "<button type='button' class='showbtn' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물보기</button></div>";
                        
                        s+='<div class="divmain" id="div'+dto.post_num+'">';
                        s+='<div class="top">';
                        s+='<div class="top-left">';
                        s+='<div style="float: left;" class="userimgdiv">';
                        if(dto.user_photo==null){
                            
                            s+='<img src="/image/noimg.png" class="userimg" user_num="'+dto.user_num+'">';
                         }                         
                                if(dto.user_photo!=null){
                                s+='<img src="${root }/photo/'+dto.user_photo+'" class="userimg" user_num="'+dto.user_num+'">';
                                }
                        s+='</div>';
                        s+='<span style="float: left; padding: 3%; margin-right: 5px;">';
                        s+='<div>';
                        s += "<b>" + dto.user_name;
                        
                        if (dto.post_access == 'follower') {
                            s += "<i class='fa-solid fa-user-group'></i>";
                          }
                          if (dto.post_access == 'all') {
                            s += "<i class='fa-solid fa-earth-americas'></i>";
                          }
                          if (dto.post_access == 'onlyme') {
                            s += "<i class='fa-solid fa-lock'></i>";
                          }
                        
                        s+='</b></div>';
                        s+='<div>'+dto.post_time+'</div></span></div>';
                        s+='<span class="top-right">';
                        
                        if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing != 1){
                           s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'>팔로우</span> ";
                            s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' style='display:none;' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' >팔로우 </span> ";
                        }
                        
                        if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing == 1) {
                            s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'>팔로우 </span> ";
                            s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' style='display:none;'>팔로우</span> ";
                        }
                        
                        s+='<span class="postmenu dropdown" post_num="'+dto.post_num +'"';
                        s+='user_num="${sessionScope.user_num }" dtouser_num="'+dto.user_num+'">';
                        s+='<i class="fa-solid fa-ellipsis"></i>';
                        
                        if (dto.checklogin == 1) {
                            s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height: 1.5em; display: none;'>";
                            s += "<li id='postupdate' class='postdetail' data-toggle='modal' data-target='#updatepost' post_num='" + dto.post_num + "' user_num='" + dto.user_num + "'>게시물 수정</li>";
                            s += "<li id='postdelete' class='postdetail' user_num='" + dto.user_num + "' post_num='" + dto.post_num + "'>게시물 삭제</li></ul>";
                        }
                        
                        if (dto.checklogin != 1) {
                            s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 20px; line-height:1.5em;display:none;'>";
                            s += "<li class='postdetail posthide' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물 숨김</li></ul>";
                        
                        }
                        
                        s += "</span></span></div>";
                        
                        s+='<div class="center">';
                        s+='<div class="center-up">'+dto.post_content+'<br><br></div>';
                        s+='<div class="center-down sliders" id="dto-'+dto.post_num+'">';
                                       
                        if((dto.post_file).includes('.mp4')){
                           s+='<div class="fileimg">';
                           s+='<video src="/post_file/'+dto.post_file+'" controls="controls" muted="muted"></video>';
                           s+='</div>';
                        }else{
                           var files = dto.post_file.split(',');
                           
                           for(var i = 0; i < files.length; i++){
                              var file = files[i].trim();
                              s+='<div class="fileimg">';
                              s+='<a href="/post_file/'+file+'" target="_new" style="text-decoration: none; outline: none;">';
                              s+='<img src="/post_file/'+file+'"></a></div>';
                           }
                        }
                              
                        s+="</div></div>";
                        
                        s+='<div class="bottom">';
                        s+='<hr style="border: 1px solid #ced0d4; margin-bottom: 1%;">';
                        s+='<div class="bottom-up">';
                        
                        if (dto.likecheck == 0){
                           s += "<span class='bottom-left liketoggle' style='cursor:pointer' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                            s += "<span class='like' id='likehide1" + dto.post_num + "' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                            s += "<span style='font-size: 1.2em; top: 3px; color: gray;'><i class='fa-regular fa-thumbs-up'></i></span>";
                        
                            if (dto.like_count == 0) {
                              s += "&nbsp;좋아요 " + dto.like_count;
                            }
                            if (dto.like_count != 0) {
                              s += "&nbsp;좋아요 " + dto.like_count + "명";
                            }
                            s += "</span>";
                            s += "<span class='dlike' id='likeshow1" + dto.post_num + "' user_num='${sessionScope.user_num}'";
                            s += 'post_num="' + dto.post_num + '" style="display: none;">';
                            s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                            s += '<i class="fa-solid fa-thumbs-up"></i>';
                            s += '</span>';
                            if (dto.like_count == 0) {
                              s += ' &nbsp;좋아요 회원님 ';
                            }
                        
                            if (dto.like_count != 0) {
                              s += '&nbsp;좋아요 회원님 외' + dto.like_count + '명';
                            }
                        
                            s += '</span></span>'
                        }
                        
                        if (dto.likecheck != 0) {
                        
                            s += '<span class="bottom-left liketoggle2" style="cursor: pointer" ';
                            s += 'likehide2_num="likehide2' + dto.post_num + '" likeshow2_num="likeshow2' + dto.post_num + '" ';
                            s += 'user_num="${sessionScope.user_num}" post_num="' + dto.post_num + '">';
                            s += '<span id="likehide2' + dto.post_num + '" class="dlike" user_num="${sessionScope.user_num}" ';
                            s += 'likehide1_num="likehide1' + dto.post_num + '" likeshow1_num="likeshow1' + dto.post_num + '" ';
                            s += 'post_num="' + dto.post_num + '">';
                            s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                            s += '<i class="fa-solid fa-thumbs-up"></i>';
                            s += '</span>';
                        
                        
                            if (dto.like_count != 1) {
                              s += '&nbsp;좋아요 회원님 외 ' + (dto.like_count - 1) + '명';
                            }
                            if (dto.like_count == 1) {
                              s += '&nbsp;좋아요 회원님 ';
                            }
                            s += '</span>';
                            s += '<span user_num="${sessionScope.user_num}" id="likeshow2' + dto.post_num + '" class="like"';
                            s += 'post_num="' + dto.post_num + '" style="display: none;">';
                            s += '<span style="font-size: 1.2em; top: 3px; color: gray;">';
                            s += '<i class="fa-regular fa-thumbs-up"></i>';
                            if (dto.like_count == 1) {
                              s += '&nbsp;좋아요 ' + (dto.like_count - 1) + '명';
                            }
                            if(dto.like_count !=1){
                            	s += '&nbsp;좋아요 '+ (dto.like_count - 1)+'명';
                            }
                            s += '</span></span></span>';
                        
                        
                          }
                        s += '<span class="bottom-right commentspan" style="cursor: pointer;" user_name="' + dto.user_name + '"';
                        s += 'post_num="' + dto.post_num + '">';
                        s += '<span style="font-size: 1.3em; color: gray;">';
                        s += '<i class="fa-regular fa-comment"></i>';
                        s += '</span>';
                        s += '&nbsp;댓글 ' + dto.comment_count;
                        s += '</span></div></div></div><br><br>';
                        
                     }else{
                        //파일이 없을 경우
                        s += "<div class='shows' id='divs" + dto.post_num + "'>";
                         s += "<div class='showtext'>게시물을 숨겼습니다. 다시보려면 게시물을 눌러주세요.</div>";
                         s += "<button type='button' class='showbtn' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물보기</button></div>";

                         s+='<div class="divmain2" id="div'+dto.post_num+'">';
                         s+='<div class="top2">';
                         s+='<div class="top-left2">';
                         s+='<span style="float: left;" class="userimgdiv">';
                         if(dto.user_photo==null){
                             
                             s+='<img src="/image/noimg.png" class="userimg" user_num="'+dto.user_num+'"></span>';
                          }                         
                                 if(dto.user_photo!=null){
                                 s+='<img src="${root }/photo/'+dto.user_photo+'" class="userimg" user_num="'+dto.user_num+'"></span>';
                                 }
                         s+='<span style="float: left; padding: 3%; margin-right: 5px;">';
                         s+='<div>';
                         s+='<b>'+dto.user_name;
                         
                         if (dto.post_access == 'follower') {
                             s += "<i class='fa-solid fa-user-group'></i>";
                          }
                         if (dto.post_access == 'all') {
                             s += "<i class='fa-solid fa-earth-americas'></i>";
                          }
                         if (dto.post_access == 'onlyme') {
                             s += "<i class='fa-solid fa-lock'></i>";
                          }
                         
                         s+='</b></div>';

                         s+='<div>'+dto.post_time+'</div></span></div>';
                         s+='<span class="top-right2">';
                         
                         if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing != 1) {
                             s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'>팔로우</span> ";
                             s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' style='display:none;' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'>팔로우 </span> ";
                           }
                         
                         if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing == 1) {
                             s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "'from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'>팔로우 </span> ";
                             s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' style='display:none;'>팔로우 </span> ";
                           }
                         
                         s += "<span class='postmenu dropdown' post_num='" + dto.post_num + "' user_num='${sessionScope.user_num}' dtouser_num='" + dto.user_num + "'>";

                         s += "<i class='fa-solid fa-ellipsis'></i>";

                         if (dto.checklogin == 1) {
                           s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height: 1.5em; display: none;'>";
                           s += "<li id='postupdate' class='postdetail' data-toggle='modal' data-target='#updatepost' post_num='" + dto.post_num + "' user_num='" + dto.user_num + "'>게시물 수정</li>";
                           s += "<li id='postdelete' class='postdetail' user_num='" + dto.user_num + "' post_num='" + dto.post_num + "'>게시물 삭제</li></ul>";
                         }
                         if (dto.checklogin != 1) {
                           s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 20px; line-height:1.5em;display:none;'>";
                           s += "<li class='postdetail posthide' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물 숨김</li></ul>";

                         }
                                        
                         s += "</span></span></div>";

                         s+='<div class="center2">';
                         s+='<div class="center-up2">'+dto.post_content+'</div></div>';

                         s+='<div class="bottom2">';
                         s+='<hr style="border: 1px solid #ced0d4; margin-bottom: 1%;">';
                         s+='<div class="bottom-up2">';

                         if (dto.likecheck == 0) {
                             s += "<span class='bottom-left2 liketoggle' style='cursor:pointer' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                             s += "<span class='like' id='likehide1" + dto.post_num + "' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                             s += "<span style='font-size: 1.2em; top: 3px; color: gray;'><i class='fa-regular fa-thumbs-up'></i></span>";

                             if (dto.like_count == 0) {
                               s += "&nbsp;좋아요 " + dto.like_count;
                             }
                             if (dto.like_count != 0) {
                               s += "&nbsp;좋아요 " + dto.like_count + "명";
                             }
                             s += "</span>";
                             s += "<span class='dlike' id='likeshow1" + dto.post_num + "' user_num='${sessionScope.user_num}'";                                   s += 'post_num="' + dto.post_num + '" style="display: none;">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                             s += '<i class="fa-solid fa-thumbs-up"></i>';
                             s += '</span>';
                             if (dto.like_count == 0) {
                               s += ' &nbsp;좋아요 회원님 ';
                             }

                             if (dto.like_count != 0) {
                               s += '&nbsp;좋아요 회원님 외' + dto.like_count + '명';
                             }

                             s += '</span></span>'

                           }


                           if (dto.likecheck != 0) {

                             s += '<span class="bottom-left2 liketoggle2" style="cursor: pointer" ';
                             s += 'likehide2_num="likehide2' + dto.post_num + '" likeshow2_num="likeshow2' + dto.post_num + '" ';
                             s += 'user_num="${sessionScope.user_num}" post_num="' + dto.post_num + '">';
                             s += '<span id="likehide2' + dto.post_num + '" class="dlike" user_num="${sessionScope.user_num}" ';
                             s += 'likehide1_num="likehide1' + dto.post_num + '" likeshow1_num="likeshow1' + dto.post_num + '" ';
                             s += 'post_num="' + dto.post_num + '">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                             s += '<i class="fa-solid fa-thumbs-up"></i>';
                             s += '</span>';


                             if (dto.like_count != 1) {
                               s += '&nbsp;좋아요 회원님 외 ' + (dto.like_count - 1) + '명';
                             }
                             if (dto.like_count == 1) {
                               s += '&nbsp;좋아요 회원님 ';
                             }
                             s += '</span>';
                             s += '<span user_num="${sessionScope.user_num}" id="likeshow2' + dto.post_num + '" class="like"';
                             s += 'post_num="' + dto.post_num + '" style="display: none;">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: gray;">';
                             s += '<i class="fa-regular fa-thumbs-up"></i>';
                             if (dto.like_count == 1) {
                               s += '&nbsp;좋아요 0 ';
                               }
                             if(dto.like_count !=1){
                               s += '&nbsp;좋아요 ' + (dto.like_count - 1) + '명';
                             }
                             s += '</span></span></span>';


                           }

                           s += '<span class="bottom-right2 commentspan" style="cursor: pointer;" user_name="' + dto.user_name + '"';
                           s += 'post_num="' + dto.post_num + '">';
                           s += '<span style="font-size: 1.3em; color: gray;">';
                           s += '<i class="fa-regular fa-comment"></i>';
                           s += '</span>';
                           s += '&nbsp;댓글 ' + dto.comment_count;
                           s += '</span></div></div></div><br><br>';

                     }
                  
                     var addTimeline = document.createElement("div");
                      addTimeline.innerHTML =s;

                      document.querySelector('section').appendChild(addTimeline);
	                      if (!dto.post_file.includes('.mp4'))
	                        	initializeSlider("dto-"+dto.post_num);
                  }, 200) 
               })
            }
          });
          
        
       }
     } 
 
      /* comment */
      $('#commentinput').keydown(function() {
         if (event.keyCode === 13) {
            $("#insertcommentbtn").trigger("click");
         };
      });

      $(document).on("keydown", ".input", function() {

         if (event.keyCode === 13) {
            $(this).next().trigger("click");
         };
      });

      $(document).on("click", ".ulimg", function() {

    	  var i=$(".ulimg").index(this);

          $.each($(".commentul"),function(k,elt){
             if(i==k){
                $(elt).toggle();
             }else{
                $(elt).hide();
             }
         })
      })

      $(document).on("click", ".cminsert", function() {

         var comment_num = $(this).attr("comment_num");
         var comment_content = $("#input" + comment_num).val();
         var post_num = $(this).attr("post_num");
         modalScrollPosition = $(".commentmodal-body").scrollTop();
         //alert(comment_num + comment_content + post_num);
        if(comment_content != ""){
            
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
                  scroll(commentoffset, post_num);
                  setTimeout(function() {
                      $(".commentmodal-body").scrollTop(modalScrollPosition);
                    },600);
                  commentCount(post_num);
                  
                  //답글 알람
                  ws.send('{"type":"comment","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'","comment_content":"'+comment_content+'"}');
               }
            })
         }else
            alert("답글을 입력해주세요");

      })

      $("#insertcommentbtn").click(function() {
         var formdata = $("#form").serialize();
         var inputdata=$("#commentinput").val();
         //alert(inputdata);
         var post_num=$("#inputhidden-post_num").val();
         modalScrollPosition = $(".commentmodal-body").scrollTop();
         
         if(inputdata != ""){
            
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
                  scroll(commentoffset, post_num);
                  setTimeout(function() {
                      $(".commentmodal-body").scrollTop(modalScrollPosition);
                    },600);
                  commentCount(post_num);
                  
                  //웹소켓에 댓글 알림 보내기
                  ws.send('{"type":"post","sender_num":"${sessionScope.user_num}","post_num":"'+post_num+'","guest_num":"null","comment_content":"'+inputdata+'"}');
               }
            })
         }else
            alert("댓글을 입력해주세요.");
      });
      $(document).on("click", "#addcomment", function() {
        var post_num=$("#inputhidden-post_num").val(); 
         commentoffset = commentoffset + 8;
         scroll(commentoffset, post_num);
      })

      $(document).on("click", ".recontent", function() {

         var comment_num = $(this).attr("comment_num");
         //alert(comment_num);
         $("#comment" + comment_num).toggle();
         $("#input"+ comment_num).focus();
      })

      $(document).on("click", "span.nolike", function() {

         var comment_num = $(this).attr("comment_num");
         var post_num=$("#inputhidden-post_num").val();
         modalScrollPosition = $(".commentmodal-body").scrollTop();
         //alert(comment_num);
         $.ajax({
            type : "get",
            dataType : "text",
            url : "commentlikeinsert",
            data : {
               "comment_num" : comment_num
            },
            success : function() {
               commentoffset = 0;
               $("#commentsection").empty();
               $("#addcomment").hide();
               $("#input" + comment_num).val("");
               $("#input" + comment_num).hide();
               scroll(commentoffset, post_num);
               setTimeout(function() {
                   $(".commentmodal-body").scrollTop(modalScrollPosition);
                 },600);
               commentCount(post_num);
               
               //댓글 좋아요 알림
          	 	ws.send('{"type":"clike","sender_num":"${sessionScope.user_num}","comment_num":"'+comment_num+'"}');
            }
         });

      })

      $(document).on("click", "span.yeslike", function() {

         var comment_num = $(this).attr("comment_num");
         var post_num=$("#inputhidden-post_num").val();
         modalScrollPosition = $(".commentmodal-body").scrollTop();
         //alert(comment_num);
         $.ajax({
            type : "get",
            dataType : "text",
            url : "commentlikedelete",
            data : {
               "comment_num" : comment_num
            },
            success : function() {
               commentoffset = 0;
               $("#commentsection").empty();
               $("#addcomment").hide();
               $("#input" + comment_num).val("");
               $("#input" + comment_num).hide();
               scroll(commentoffset, post_num);
               setTimeout(function() {
                   $(".commentmodal-body").scrollTop(modalScrollPosition);
                 },600);
               commentCount(post_num);
            }
         });

      })
      
      $(document).on("click",".commentdel",function(){
         
         var comment_num=$(this).attr("comment_num");
         var post_num=$("#inputhidden-post_num").val();
         modalScrollPosition = $(".commentmodal-body").scrollTop();
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
               scroll(commentoffset, post_num);
               setTimeout(function() {
                   $(".commentmodal-body").scrollTop(modalScrollPosition);
                 },600);
               commentCount(post_num);
            }
         })
      })
      
      $(document).on("click",".commentmod",function(){
         
         var comment_num=$(this).attr("comment_num");
         var div=$("#div"+comment_num).css("visibility");
         var divmod=$("#commentmod"+comment_num).css("visibility");
         
       if(div == "visible")   
            $("#div"+comment_num).css("visibility","hidden");
       else
            $("#div"+comment_num).css("visibility","visible");
       
       if(divmod == "hidden")    
            $("#commentmod"+comment_num).css("visibility","visible");
       else
            $("#commentmod"+comment_num).css("visibility","hidden");
       
       $("#ul" + comment_num).toggle();
       $("#cmmodinput"+comment_num).focus();
       $("#ulimg"+comment_num).css("visibility","hidden");
       
       
      })
      
      $(document).on("click",".modclose",function(){
         
         var comment_num=$(this).attr("comment_num");
          var div=$("#div"+comment_num).css("visibility");
          var divmod=$("#commentmod"+comment_num).css("visibility");
        if(div == "visible")   
             $("#div"+comment_num).css("visibility","hidden");
        else
             $("#div"+comment_num).css("visibility","visible");
        
        if(divmod == "hidden")    
             $("#commentmod"+comment_num).css("visibility","visible");
        else
             $("#commentmod"+comment_num).css("visibility","hidden");
        $("#ulimg"+comment_num).css("visibility","visible");

      })
      
      
      $(document).on("keydown",".inputmod",function(){
         
         if (event.keyCode === 13) {
            var comment_num=$(this).attr("comment_num");
            var post_num=$("#inputhidden-post_num").val();
            var comment_content=$(this).val();
            modalScrollPosition = $(".commentmodal-body").scrollTop();
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
                  scroll(commentoffset, post_num);
                  setTimeout(function() {
                      $(".commentmodal-body").scrollTop(modalScrollPosition);
                    },700);
                  commentCount(post_num);
               }
            });
         };
      })
      
      
      $(document).on("click",".commentspan",function(){
         
         var post_num=$(this).attr("post_num");
         var user_name=$(this).attr("user_name");
         $(".commentmodal-body").scrollTop(0);
         $("#inputhidden-post_num").val(post_num);
         $(".commenth4").text(user_name+"님의 게시물");
         $("#commentsection").empty();
         $("#posttsection").empty();
         scroll(0,post_num);
         
         $.ajax({
             type:"get",
             dataType:"json",
             url:"getpostdata",
             data:{"post_num":post_num},
             success:function(res){
                
                $.each(res,function(i,dto){

                      var s='';

                      if (dto.post_file != 'no') {

                         s += "<div class='shows' id='divs" + dto.post_num + "'>";
                         s += "<div class='showtext'>게시물을 숨겼습니다. 다시보려면 게시물을 눌러주세요.</div>";
                         s += "<button type='button' class='showbtn' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물보기</button></div>";
                         
                         s+='<div class="divmain" id="div'+dto.post_num+'">';
                         s+='<div class="top">';
                         s+='<div class="top-left">';
                         s+='<div style="float: left;" class="userimgdiv">';
                         if(dto.user_photo==null){
                             
                             s+='<img src="/image/noimg.png" class="userimg" user_num="'+dto.user_num+'">';
                          }                         
                                 if(dto.user_photo!=null){
                                 s+='<img src="${root }/photo/'+dto.user_photo+'" class="userimg" user_num="'+dto.user_num+'">';
                                 }
                         s+='</div>';
                         s+='<span style="float: left; padding: 3%; margin-right: 5px;">';
                         s+='<div>';
                         s += "<b>" + dto.user_name;
                         
                         if (dto.post_access == 'follower') {
                             s += "<i class='fa-solid fa-user-group'></i>";
                           }
                           if (dto.post_access == 'all') {
                             s += "<i class='fa-solid fa-earth-americas'></i>";
                           }
                           if (dto.post_access == 'onlyme') {
                             s += "<i class='fa-solid fa-lock'></i>";
                           }
                         
                         s+='</b></div>';
                         s+='<div>'+dto.post_time+'</div></span></div>';
                         s+='<span class="top-right">';
                         
                         if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing != 1){
                            s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'></span> ";
                             s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' style='display:none;' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' > </span> ";
                         }
                         
                         if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing == 1) {
                             s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'> </span> ";
                             s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' style='display:none;'> </span> ";
                         }
                         
                         s+='<span class="postmenu dropdown" post_num="'+dto.post_num +'"';
                         s+='user_num="${sessionScope.user_num }" dtouser_num="'+dto.user_num+'">';
                         
                         if (dto.checklogin == 1) {
                             s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height: 1.5em; display: none;'>";
                             s += "<li id='postupdate' class='postdetail' data-toggle='modal' data-target='#updatepost' post_num='" + dto.post_num + "' user_num='" + dto.user_num + "'>게시물 수정</li>";
                             s += "<li id='postdelete' class='postdetail' user_num='" + dto.user_num + "' post_num='" + dto.post_num + "'>게시물 삭제</li></ul>";
                         }
                         
                         if (dto.checklogin != 1) {
                             s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height:1.5em;display:none;'>";
                             s += "<li class='postdetail posthide' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물 숨김</li></ul>";
                         
                         }
                         
                         s += "</span></span></div>";
                         
                         s+='<div class="center">';
                         s+='<div class="center-up">'+dto.post_content+'<br><br></div>';
                         s+='<div class="center-down sliders" id="dto-'+dto.post_num+'">';
                                        
                         if((dto.post_file).includes('.mp4')){
                            s+='<div class="fileimg">';
                            s+='<video src="/post_file/'+dto.post_file+'" controls="controls" muted="muted"></video>';
                            s+='</div>';
                         }else{
                            var files = dto.post_file.split(',');
                            
                            for(var i = 0; i < files.length; i++){
                               var file = files[i].trim();
                               s+='<div class="fileimg">';
                               s+='<a href="/post_file/'+file+'" target="_new" style="text-decoration: none; outline: none;">';
                               s+='<img src="/post_file/'+file+'"></a></div>';
                            }
                         }
                               
                         s+="</div></div>";
                         
                         s+='<div class="bottom">';
                         s+='<div class="bottom-up">';
                         
                         if (dto.likecheck == 0){
                            s += "<span class='bottom-left liketoggle' style='cursor:pointer' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                             s += "<span class='like' id='likehide1" + dto.post_num + "' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                             s += "<span style='font-size: 1.2em; top: 3px; color: gray;'></span>";
                         
                             if (dto.like_count == 0) {
                             }
                             if (dto.like_count != 0) {
                             }
                             s += "</span>";
                             s += "<span class='dlike' id='likeshow1" + dto.post_num + "' user_num='${sessionScope.user_num}'";
                             s += 'post_num="' + dto.post_num + '" style="display: none;">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                             s += '</span>';
                             if (dto.like_count == 0) {
                             }
                         
                             if (dto.like_count != 0) {
                             }
                         
                             s += '</span></span>'
                         }
                         
                         if (dto.likecheck != 0) {
                         
                             s += '<span class="bottom-left liketoggle2" style="cursor: pointer" ';
                             s += 'likehide2_num="likehide2' + dto.post_num + '" likeshow2_num="likeshow2' + dto.post_num + '" ';
                             s += 'user_num="${sessionScope.user_num}" post_num="' + dto.post_num + '">';
                             s += '<span id="likehide2' + dto.post_num + '" class="dlike" user_num="${sessionScope.user_num}" ';
                             s += 'likehide1_num="likehide1' + dto.post_num + '" likeshow1_num="likeshow1' + dto.post_num + '" ';
                             s += 'post_num="' + dto.post_num + '">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                             s += '</span>';
                         
                         
                             if (dto.like_count != 1) {
                             }
                             if (dto.like_count == 1) {
                             }
                             s += '</span>';
                             s += '<span user_num="${sessionScope.user_num}" id="likeshow2' + dto.post_num + '" class="like"';
                             s += 'post_num="' + dto.post_num + '" style="display: none;">';
                             s += '<span style="font-size: 1.2em; top: 3px; color: gray;">';
                             if (dto.like_count == 1) {
                             }
                             s += '</span></span></span>';
                         
                         
                           }
                         s += '<span class="bottom-right commentspan" style="cursor: pointer;" user_name="' + dto.user_name + '"';
                         s += 'post_num="' + dto.post_num + '">';
                         s += '<span style="font-size: 1.3em; color: gray;">';
                         s += '</span>';
                         s += '</span></div></div></div><br><br>';
                         
                      }else{
                         //파일이 없을 경우
                         s += "<div class='shows' id='divs" + dto.post_num + "'>";
                          s += "<div class='showtext'>게시물을 숨겼습니다. 다시보려면 게시물을 눌러주세요.</div>";
                          s += "<button type='button' class='showbtn' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물보기</button></div>";

                          s+='<div class="divmain2" id="div'+dto.post_num+'">';
                          s+='<div class="top2">';
                          s+='<div class="top-left2">';
                          s+='<span style="float: left;" class="userimgdiv">';
                          if(dto.user_photo==null){
                              
                              s+='<img src="/image/noimg.png" class="userimg" user_num="'+dto.user_num+'"></span>';
                           }                         
                                  if(dto.user_photo!=null){
                                  s+='<img src="${root }/photo/'+dto.user_photo+'" class="userimg" user_num="'+dto.user_num+'"></span>';
                                  }
                          s+='<span style="float: left; padding: 3%; margin-right: 5px;">';
                          s+='<div>';
                          s+='<b>'+dto.user_name;
                          
                          if (dto.post_access == 'follower') {
                              s += "<i class='fa-solid fa-user-group'></i>";
                           }
                          if (dto.post_access == 'all') {
                              s += "<i class='fa-solid fa-earth-americas'></i>";
                           }
                          if (dto.post_access == 'onlyme') {
                              s += "<i class='fa-solid fa-lock'></i>";
                           }
                          
                          s+='</b></div>';

                          s+='<div>'+dto.post_time+'</div></span></div>';
                          s+='<span class="top-right2">';
                          
                          if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing != 1) {
                              s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'></span> ";
                              s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' style='display:none;' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'> </span> ";
                            }
                          
                          if (dto.user_num != "${sessionScope.user_num}" && dto.checkfollowing == 1) {
                              s += "<span class='unfollow' id='unfollow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "'from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "'> </span> ";
                              s += "<span class='follow' id='follow" + dto.post_num + "' followpost_num='follow" + dto.post_num + "' unfollowpost_num='unfollow" + dto.post_num + "' from_user='${sessionScope.user_num}' to_user='" + dto.user_num + "' style='display:none;'> </span> ";
                            }
                          
                          s += "<span class='postmenu dropdown' post_num='" + dto.post_num + "' user_num='${sessionScope.user_num}' dtouser_num='" + dto.user_num + "'>";


                          if (dto.checklogin == 1) {
                            s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height: 1.5em; display: none;'>";
                            s += "<li id='postupdate' class='postdetail' data-toggle='modal' data-target='#updatepost' post_num='" + dto.post_num + "' user_num='" + dto.user_num + "'>게시물 수정</li>";
                            s += "<li id='postdelete' class='postdetail' user_num='" + dto.user_num + "' post_num='" + dto.post_num + "'>게시물 삭제</li></ul>";
                          }
                          if (dto.checklogin != 1) {
                            s += "<ul id='" + dto.post_num + "' class='dropdown-menu dropdown-menu-right postsubmenu' style='font-size: 18px; line-height:1.5em;display:none;'>";
                            s += "<li class='postdetail posthide' divpost_num='div" + dto.post_num + "' divspost_num='divs" + dto.post_num + "'>게시물 숨김</li></ul>";

                          }
                                         
                          s += "</span></span></div>";

                          s+='<div class="center2">';
                          s+='<div class="center-up2">'+dto.post_content+'</div></div>';

                          s+='<div class="bottom2">';
                          s+='<div class="bottom-up2">';

                          if (dto.likecheck == 0) {
                              s += "<span class='bottom-left2 liketoggle' style='cursor:pointer' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                              s += "<span class='like' id='likehide1" + dto.post_num + "' user_num='${sessionScope.user_num}' likehide1_num='likehide1" + dto.post_num + "' likeshow1_num='likeshow1" + dto.post_num + "' post_num='" + dto.post_num + "'>";
                              s += "<span style='font-size: 1.2em; top: 3px; color: gray;'></span>";

                              if (dto.like_count == 0) {
                              }
                              if (dto.like_count != 0) {
                              }
                              s += "</span>";
                              s += "<span class='dlike' id='likeshow1" + dto.post_num + "' user_num='${sessionScope.user_num}'";                                   s += 'post_num="' + dto.post_num + '" style="display: none;">';
                              s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                              s += '</span>';
                              if (dto.like_count == 0) {
                              }

                              if (dto.like_count != 0) {
                              }

                              s += '</span></span>'

                            }


                            if (dto.likecheck != 0) {

                              s += '<span class="bottom-left2 liketoggle2" style="cursor: pointer" ';
                              s += 'likehide2_num="likehide2' + dto.post_num + '" likeshow2_num="likeshow2' + dto.post_num + '" ';
                              s += 'user_num="${sessionScope.user_num}" post_num="' + dto.post_num + '">';
                              s += '<span id="likehide2' + dto.post_num + '" class="dlike" user_num="${sessionScope.user_num}" ';
                              s += 'likehide1_num="likehide1' + dto.post_num + '" likeshow1_num="likeshow1' + dto.post_num + '" ';
                              s += 'post_num="' + dto.post_num + '">';
                              s += '<span style="font-size: 1.2em; top: 3px; color: blue;">';
                              s += '</span>';


                              if (dto.like_count != 1) {
                              }
                              if (dto.like_count == 1) {
                              }
                              s += '</span>';
                              s += '<span user_num="${sessionScope.user_num}" id="likeshow2' + dto.post_num + '" class="like"';
                              s += 'post_num="' + dto.post_num + '" style="display: none;">';
                              s += '<span style="font-size: 1.2em; top: 3px; color: gray;">';
                              if (dto.like_count == 1) {
                              }
                              s += '</span></span></span>';


                            }

                            s += '<span class="bottom-right2 commentspan" style="cursor: pointer;" user_name="' + dto.user_name + '"';
                            s += 'post_num="' + dto.post_num + '">';
                            s += '<span style="font-size: 1.3em; color: gray;">';
                            s += '</span>';
                            s += '</span></div></div></div><br><br>';

                      }
                   
                      var addTimeline = document.createElement("div");
                      addTimeline.innerHTML =s;
                      document.querySelector('sectiontime').appendChild(addTimeline);
                      return false;
                })
             }
           });
         
         
        commentCount(post_num);
        $(".cmmodalbtn").trigger("click");
        
         
      })
      
      //예지 비디오 부분 시작
      
      //처음 화면 로딩됐을 때 영상 위치 확인
      $(".fileimg video").each(function(i,ele){
         videoStatus($(ele));
      })
      
      //스크롤 할 때마다 영상 위치 확인
      $(window).scroll(function(){
         $(".fileimg video").each(function(i,ele){
             if(videoStatus($(ele))){
                return;
             }
          })
      })
      
      //예지 비디오 부분 끝
      
      
   })
   
   //댓글갯수 불러오기 
   function commentCount(post_num){
      $.ajax({
         type : "get",
          dataType : "json",
          url : "commentcount",
          data : {"post_num" : post_num},
          success :function(res){
             
             if(res>8)
                $("#addcomment").show();
             else
                $("#addcomment").hide();
                
          }
      });
   }
   
   
   
   function initializeSlider(elementId) {
	      $("#" + elementId).slick({
	         prevArrow: '<img id="prev-' + elementId + '" src="../image/left.png" class="prev">',
	         nextArrow: '<img id="next-' + elementId + '" src="../image/right.png" class="next">',
	         autoplay: false,
	         autoplaySpeed: 0,
	         dots: false,
	         arrows: true,
	         infinite: false,
	         slidesToShow: 1,
	         slidesToScroll: 1
	      });

	      $("#" + elementId).on('afterChange', function(event, slick, currentSlide) {
	         if (currentSlide == 0) {
	            $('#prev-' + elementId).css("visibility", "hidden");
	         } else {
	            $('#prev-' + elementId).css("visibility", "visible");
	         }
	         if (currentSlide == slick.slideCount - 1) {
	            $('#next-' + elementId).css("visibility", "hidden");
	         } else {
	            $('#next-' + elementId).css("visibility", "visible");
	         }
	      });
	   }
   
   /* 예지: 영상 화면에 보일 시 자동재생 */
   function videoStatus(video){
      var viewHeight=$(window).height();
      var scrollTop=$(window).scrollTop();
      var y=video.offset().top;
      var elementHeight=video.height();
      
      if(y<(viewHeight+scrollTop) && y>(scrollTop-elementHeight)){
         if(video.attr("onwindow")!="true"){
            video.get(0).play();
            video.attr("onwindow","true");    
         }
         
         return true;
      }
      else if(y<(viewHeight+scrollTop) && video.attr("onwindow")!="true"){
         if(video.attr("onwindow")!="true"){
            video.get(0).play();
            video.attr("onwindow","true");  
         }  
         
         return true;
      }
      else{
         video.get(0).pause();
         video.attr("onwindow","false"); 
         
         return false;
      }
   }
   /* 예지 자동재생 끝 */
   
   /* 댓글 무한스크롤 */
   function scroll(commentoffset, post_num) {

      $.ajax({
         type : "get",
         dataType : "json",
         url : "scrollcomment",
         data : {
            "commentoffset" : commentoffset,
            "post_num" : post_num
         },
         success : function(res) {

            $.each(res, function(i, item) {

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



<style type="text/css">
body {
	background-color: #F0F2F5;
}

.allmain {
	/* width: 1000px; */
	width: 100%;
	height: 100%;
	background-color: #F0F2F5;
}

.divmain {
	margin: 0 auto;
	/* width,height 수정 */
	width: 100%;
	height: 100%;
	border-radius: 10px 10px;
	background-color: white;
	display: inline-flex;
	flex-direction: column;
	box-shadow: 0px 0px 5px lightgray;
}

.top {
	width: 100%;
	height: 10%;
}

.top-left {
	float: left;
	width: 50%;
	height: 100%;
}

.top-right {
	text-align: right;
	float: right;
	width: 50%;
	height: 100%;
	display: inline-flex;
	align-items: center;
	justify-content: flex-end;
}

.center {
	width: 100%;
	height: 70%;
}

.center-up {
	width: 100%;
	font-size: 12pt;
	padding-left: 8.5%;
	padding-right: 8.5%;
}

.center-down {
	text-align: center;
	width: 100%;
	overflow: hidden;
}

.bottom {
	width: 100%;
	height: 20%;
	margin-bottom: 5px;
}

.bottom-up {
	width: 100%;
}

.bottom-left {
	text-align: center;
	font-size: 1.2em;
	float: left;
	width: 50%;
	height: 100%;
}

.bottom-right {
	text-align: center;
	font-size: 1.2em;
	float: right;
	width: 50%;
	height: 100%;
}

.bottom-down {
	width: 100%;
	height: 10%;
}

/* 파일 없을 경우  */
.divmain2 {
	margin: 0 auto;
	/* width, height 수정 */
	width: 100%;
	height: 100%;
	border-radius: 10px 10px;
	background-color: white;
	display: inline-flex;
	flex-direction: column;
	box-shadow: 0px 0px 5px lightgray;
}

.top2 {
	width: 100%;
	height: 20%;
}

.top-left2 {
	float: left;
	width: 50%;
	height: 100%;
}

.top-right2 {
	text-align: right;
	float: right;
	width: 50%;
	height: 100%;
	display: inline-flex;
	align-items: center;
	justify-content: flex-end;
}

.center2 {
	width: 100%;
	height: 57%;
}

.center-up2 {
	width: 100%;
	padding-left: 8.5%;
	padding-right: 8.5%;
	font-size: 12pt;
}

.bottom2 {
	width: 100%;
	height: 13%;
}

.bottom-up2 {
	width: 100%;
	height: 10%;
}

.bottom-left2 {
	text-align: center;
	font-size: 1.2em;
	float: left;
	width: 50%;
	height: 100%;
}

.bottom-right2 {
	text-align: center;
	font-size: 1.2em;
	float: right;
	width: 50%;
	height: 100%;
}

.bottom-down2 {
	width: 100%;
	height: 90%;
}

.postmenu {
	cursor: pointer;
	font-size: 2.5em;
	margin-right: 3%;
	color: gray;
}

.postsubmenu {
	font-size: 1.5em;
	text-align: center;
	border-radius: 15px;
	box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
	line-height: 1.5em;
}

.postdetail:hover {
	background-color: #F0F2F5;
	border-radius: 15px;
}

.postdetail {
	font-size: 0.8em;
	color: black;
}

.userimgdiv {
	width: 40px;
	height: 40px;
	border-radius: 100px;
	margin: 10px;
	overflow: hidden;
	box-shadow: 0px 0px 3px gray;
}

.userimg {
	cursor: pointer;
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.contentmodal {
	/* background: #F0F2F5; */
	border-radius: 60px;
	margin: 0 auto;
	/* width바꿈 100%로 */
	width: 85%;
}

#writeinput {
	width: 100%;
	border-radius: 30px;
	text-align: left;
	outline: none;
	border: none;
	font-size: 15pt;
	background: #F0F2F5;
	padding: 8px;
}

.writeinputdiv {
	width: 95%;
}

#coverinput {
	background: white;
	height: 65px;
	width: 100%;
	margin: 0 auto;
	border-radius: 10px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding-left: 15px;
	padding-right: 15px;
	box-shadow: 0px 0px 5px lightgray;
}

.writeimgdiv {
	width: 40px;
	height: 40px;
	margin-right: 15px;
	border-radius: 100px;
	overflow: hidden;
	box-shadow: 0px 0px 3px gray;
}

.writeimg {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.postimg {
	width: 35px;
	height: 35px;
	border: 1px solid gray;
	border-radius: 20px;
}

.shows {
	display: none;
	background-color: white;
	margin: 0 auto;
	max-width: 750px;
	min-width: 650px;
	height: 50px;
	border-radius: 10px 10px;
	padding: 0.6%;
	font-size: 18px;
	text-align: center;
}

.showtext {
	float: left;
	padding: 1%;
	margin-left: 10%;
}

.showbtn {
	border-radius: 5px 5px;
	background-color: #F0F2F5;
	border: 0.5px solid gray;
	float: right;
	height: 37px;
}

.commentarrow {
	width: 30px;
	height: 30px;
	margin-right: 3%;
	cursor: pointer;
}

.prev {
	float: left;
	position: absolute;
	z-index: 1;
	border: none;
	width: 10%;
	height: 10%;
	cursor: pointer;
	visibility: hidden;
	left: 0px;
}

.next {
	float: right;
	border: none;
	position: absolute;
	z-index: 1;
	width: 10%;
	height: 10%;
	cursor: pointer;
	right: 0px;
}

.fileimg {
	text-align: center;
	width: 100%;
}

.fileimg img {
	width: 60%;
	height: 100%;
	margin: 0 auto;
}

.fileimg video {
	width: 100%;
	height: 100%;
	obejct-fit: cover;
}

.sliders {
	width: 100%;
	height: 450px;
	overflow: hidden;
	margin: 0 auto;
	display: inline-flex;
	justify-content: center;
	align-items: center;
}

.slick-list {
	float: left;
	width: 100%;
}

.slick-track {
	display: inline-flex;
	align-items: center;
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

.unfollow {
	color: blue;
	cursor: pointer;
	font-size: 1em;
	margin-right: 10px;
}

.follow {
	color: gray;
	cursor: pointer;
	font-size: 1em;
	margin-right: 10px;
}

.follow:hover {
	color: blue;
	font-size: 1.2em;
	border: none;
	/*  box-shadow: rgba(0, 0, 0, 0.30) 0px 1px 10px; */
}

li {
	cursor: pointer;
}

#update_userphoto, #insert_userphoto {
	width: 40px;
	height: 40px;
	overflow: hidden;
	border-radius: 100px;
}

#update_userphoto img, #insert_userphoto img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

#update_username, #insert_username {
	font-size: 11pt;
	font-weight: bold;
}

#update_header, #insert_header {
	display: inline-flex;
	align-items: center;
	width: 100%;
}

#update_userbox, #insert_userbox {
	display: inline-flex;
	flex-direction: column;
	margin-left: 10px;
}

#update_access, #post_access {
	font-size: 10pt;
	font-weight: bold;
	height: 100%;
	padding: 5px;
	outline: none;
	border-radius: 5px;
	background-color: #F0F2F5;
	border: none;
}
</style>
</head>



<body>

	<c:set var="root" value="<%=request.getContextPath()%>" />

	<div class="allmain">
		<br>
		<!-- writemodal -->

		<div class="contentmodal">
			<div id="coverinput">
				<div class="writeimgdiv">
					<c:if test="${sessionScope.user_photo==null }">
                  <img src="/image/noimg.png" class="writeimg">;
                        </c:if>
               <c:if test="${sessionScope.user_photo!=null }">
                  <img src="${root }/photo/${sessionScope.user_photo}" class="writeimg">
               </c:if>
				</div>
				<div class="writeinputdiv">
					<input type="button" data-toggle="modal" data-target="#contentwrite" name="contentwirte"
						id="writeinput" value="무슨 생각을 하고 계신가요?">
				</div>
			</div>
		</div>

		<br>
		<!-- Modal -->
		<div class="modal fade" id="contentwrite" role="dialog">
			<div class="modal-dialog">

				<!-- Modal content-->
				<form method="post" enctype="multipart/form-data" id="postInsert">
					<input type="hidden" name="user_num" id="user_num" value="${sessionScope.user_num }">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title" align="center">
								<b>게시글 만들기</b>
							</h4>
						</div>
						<div class="modal-body">
							<div class="form-group" style="width: 500px;">
								<div id="insert_header">
									<div id="insert_userphoto">
										<c:if test="${sessionScope.user_photo==null }">
											<img src="/image/noimg.png">
										</c:if>
										<c:if test="${sessionScope.user_photo!=null }">
											<img src="/photo/${sessionScope.user_photo }">
										</c:if>
									</div>
									<div id="insert_userbox">
										<span id="insert_username">${login_name}</span>
										<select name="post_access" id="post_access">
											<option value="all">전체공개</option>
											<option value="follower">팔로워 공개</option>
											<option value="onlyme">나만보기</option>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group">
								<textarea style="width: 100%; height: 90px; outline: none; border: none; font-size: 12pt"
									name="post_content" required="required" id="post_content" placeholder="내용을 입력해주세요"></textarea>

								<div id="showmodimg_insert"
									style="width: 95%; height: 300px; border-radius: 10px; overflow-y: auto; display: inline-flex; flex-direction: column; text-align: center;">
								</div>
							</div>

							<input type="file" multiple="multiple" id="post_file" name="post_file" style="display: none;">
							<br>
							<button type="button" id="btncontentphoto" class="btn btn-default">사진 선택</button>
							<button type="button" class="btn btn-default" id="remove_contentphoto_btn"
								style="outline: none;">사진 모두 지우기</button>

						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal" id="insertbtn"
								style="width: 100%; height: 55px; font-size: 16pt; font-weight: bold;">게시</button>
						</div>
					</div>
				</form>

			</div>
		</div>

		<!-- 수정 Modal -->


		<div class="modal fade" id="updatepost" role="dialog">
			<div class="modal-dialog">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title" align="center">
							<b>게시글 수정</b>
						</h4>
					</div>

					<div class="modal-body">
						<div class="form-group" style="width: 100%;">
							<div id="update_header">
								<div id="update_userphoto">
									<c:if test="${sessionScope.user_photo==null }">
										<img src="/image/noimg.png">
									</c:if>
									<c:if test="${sessionScope.user_photo!=null }">
										<img src="/photo/${sessionScope.user_photo }">
									</c:if>
								</div>
								<div id="update_userbox">
									<span id="update_username">${sessionScope.name }</span>
									<select name="update_access" id="update_access" required="required">
										<option value="all">전체공개</option>
										<option value="follower">팔로워 공개</option>
										<option value="onlyme">나만보기</option>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group">
							<input type="file" name="update_file" class="form-control" required="required"
								multiple="multiple" id="update_file" style="display: none;">
						</div>
						<div class="form-group">
							<textarea style="width: 100%; height: 90px; outline: none; border: none; font-size: 12pt"
								name="update_content" required="required" id="update_content" placeholder="내용을 입력해주세요"></textarea>
						</div>
						<div id="showmodimg"
							style="width: 95%; height: 300px; border-radius: 10px; overflow-y: auto; display: inline-flex; flex-direction: column; text-align: center;">
						</div>
						<br>
						<button type="button" class="btn btn-default" id="btnmodcontentphoto" style="outline: none;">사진
							선택</button>
						<button type="button" class="btn btn-default" id="remove_photo_btn" style="outline: none;">사진
							모두 지우기</button>
					</div>

					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-default" data-dismiss="modal" id="updatetbtn"
							style="width: 100%; height: 55px; font-size: 16pt; font-weight: bold;">수정</button>
						<!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
					</div>
				</div>


			</div>
		</div>
		<section style="width: 85%; margin: 0 auto;">
			<!-- 파일이 있을경우0 -->
			<!--  동영상일 경우와 사진이 1장만 있을 경우도 .해주어야함   -->

			<c:forEach var="dto" items="${list }" varStatus="i">
				<c:if test="${dto.post_file!='no' }">

					<div class="shows" id="divs${dto.post_num }">
						<div class="showtext">게시물을 숨겼습니다. 다시 보려면 게시물 보기를 눌러주세요.</div>
						<button type="button" class="showbtn" divpost_num="div${dto.post_num }"
							divspost_num="divs${dto.post_num }">게시물 보기</button>
					</div>
					<div class="divmain" id="div${dto.post_num }">
						<div class="top">
							<div class="top-left">
								<div style="float: left;" class="userimgdiv">
									 <c:if test="${dto.user_photo==null }">
                              <img src="/image/noimg.png" class="userimg" user_num="${dto.user_num}">;
                        </c:if>
                           <c:if test="${dto.user_photo!=null }">
                              <img src="${root }/photo/${dto.user_photo}" class="userimg" user_num="${dto.user_num }">
                           </c:if>
								</div>
								<span style="float: left; padding: 3%; margin-right: 5px;">
									<div>
										<b>${dto.user_name }
											<c:if test="${dto.post_access =='follower'}">
												<i class="fa-solid fa-user-group"></i>
											</c:if>
											<c:if test="${dto.post_access =='all'}">
												<i class="fa-solid fa-earth-americas"></i>
											</c:if>
											<c:if test="${dto.post_access =='onlyme'}">
												<i class="fa-solid fa-lock"></i>
											</c:if>


										</b>
									</div>

									<div>${dto.post_time }</div>
								</span>
							</div>
							<span class="top-right">
								<c:if test="${dto.user_num!=sessionScope.user_num &&dto.checkfollowing !=1 }">
									<span class="follow" id="follow${dto.post_num}" followpost_num="follow${dto.post_num }"
										unfollowpost_num="unfollow${dto.post_num }" from_user="${sessionScope.user_num }"
										to_user="${dto.user_num }">팔로우</span>

									<span class="unfollow" id="unfollow${dto.post_num }"
										followpost_num="follow${dto.post_num }" unfollowpost_num="unfollow${dto.post_num }"
										to_user="${dto.user_num }" style="display: none;">팔로우</span>
								</c:if>
								<c:if test="${dto.user_num!=sessionScope.user_num && dto.checkfollowing ==1 }">
									<span class="unfollow" id="unfollow${dto.post_num }"
										followpost_num="follow${dto.post_num }" unfollowpost_num="unfollow${dto.post_num }"
										to_user="${dto.user_num }">팔로우 </span>
									<span class="follow" id="follow${dto.post_num}" followpost_num="follow${dto.post_num }"
										unfollowpost_num="unfollow${dto.post_num }" from_user="${sessionScope.user_num }"
										to_user="${dto.user_num }" style="display: none;">팔로우</span>
								</c:if>
								<span class="postmenu dropdown" post_num="${dto.post_num }"
									user_num="${sessionScope.user_num }" dtouser_num="${dto.user_num}">
									<i class="fa-solid fa-ellipsis"></i>
									<c:if test="${dto.checklogin ==1 }">

										<ul id="${dto.post_num }" class="dropdown-menu dropdown-menu-right postsubmenu "
											style="font-size: 18px; line-height: 1.5em; display: none;">


											<li id="postupdate" class="postdetail" data-toggle="modal" data-target="#updatepost"
												post_num="${dto.post_num }" user_num="${dto.user_num }">게시물 수정</li>
											<li id="postdelete" class="postdetail" user_num="${dto.user_num }"
												post_num="${dto.post_num }">게시물 삭제</li>
										</ul>
									</c:if>
									<c:if test="${dto.checklogin !=1 }">
										<ul id="${dto.post_num }" class="dropdown-menu dropdown-menu-right postsubmenu"
											style="font-size: 18px; line-height: 1.5em; display: none;">
											<li class="postdetail posthide" divpost_num="div${dto.post_num }"
												divspost_num="divs${dto.post_num }">게시물 숨김</li>
										</ul>
									</c:if>
								</span>
							</span>

						</div>




						<div class="center">


							<div class="center-up">${dto.post_content }<br><br></div>

							<div class="center-down sliders" id="dto-${dto.post_num}">
								<!-- 예지: 파일이 사진인지 영상인지 확인 -->
								<c:if test="${fn:contains(dto.post_file, '.mp4')}">
									<div class="fileimg">
										<video src="/post_file/${dto.post_file }" controls="controls" muted="muted"></video>
									</div>
								</c:if>
								<c:if test="${!fn:contains(dto.post_file, '.mp4')}">
									<c:forTokens items="${dto.post_file }" delims="," var="file">
										<div class="fileimg">
											<a href="/post_file/${file }" target="_new" style="text-decoration: none; outline: none;">
												<img src="/post_file/${file }">
											</a>
										</div>
									</c:forTokens>
								</c:if>
							</div>

						</div>



						<div class="bottom">
							<hr style="border: 1px solid #ced0d4; margin-bottom: 1%;">
							<div class="bottom-up">

								<!-- 체크 안했으면 보이는거 -->
								<c:if test="${dto.likecheck ==0 }">
									<span class="bottom-left liketoggle" style="cursor: pointer"
										user_num="${sessionScope.user_num}" likehide1_num="likehide1${dto.post_num}"
										likeshow1_num="likeshow1${dto.post_num}" post_num="${dto.post_num }">
										<span class="like" id="likehide1${dto.post_num}" user_num="${sessionScope.user_num}"
											likehide1_num="likehide1${dto.post_num}" likeshow1_num="likeshow1${dto.post_num}"
											post_num="${dto.post_num }">
											<span style="font-size: 1.2em; top: 3px; color: gray;">
												<i class="fa-regular fa-thumbs-up"></i>
											</span>
											<c:if test="${dto.like_count==0 }">
                                 &nbsp;좋아요 ${dto.like_count}
                                 </c:if>
											<c:if test="${dto.like_count !=0 }">
                                 &nbsp;좋아요 ${dto.like_count}명
                                 </c:if>
										</span>
										<span class="dlike" id="likeshow1${dto.post_num}" user_num="${sessionScope.user_num}"
											post_num="${dto.post_num }" style="display: none;">
											<span style="font-size: 1.2em; top: 3px; color: blue;">
												<i class="fa-solid fa-thumbs-up"></i>
											</span>
											<c:if test="${dto.like_count==0 }">
                                 &nbsp;좋아요 회원님 
                                 </c:if>
											<c:if test="${dto.like_count !=0 }">
                                 &nbsp;좋아요 회원님 외${dto.like_count}명
                                 </c:if>
										</span>

									</span>


								</c:if>

								<!-- 처음부터 체크되어있으면 보이는거  -->
								<c:if test="${dto.likecheck !=0 }">
									<span class="bottom-left liketoggle2" style="cursor: pointer"
										likehide2_num="likehide2${dto.post_num}" likeshow2_num="likeshow2${dto.post_num}"
										user_num="${sessionScope.user_num}" post_num="${dto.post_num }">
										<span id="likehide2${dto.post_num}" class="dlike" user_num="${sessionScope.user_num}"
											likehide1_num="likehide1${dto.post_num}" likeshow1_num="likeshow1${dto.post_num}"
											post_num="${dto.post_num }">
											<span style="font-size: 1.2em; top: 3px; color: blue;">
												<i class="fa-solid fa-thumbs-up"></i>
											</span>

											<c:if test="${dto.like_count!= 1}">
                                 &nbsp;좋아요 회원님 외 ${dto.like_count-1}명
                                 </c:if>
											<c:if test="${dto.like_count ==1 }">
                                 &nbsp;좋아요 회원님 
                                 </c:if>
										</span>
										<span user_num="${sessionScope.user_num}" id="likeshow2${dto.post_num}" class="like"
											post_num="${dto.post_num }" style="display: none;">
											<span style="font-size: 1.2em; top: 3px; color: gray;">
												<i class="fa-regular fa-thumbs-up"></i>
												<c:if test="${dto.like_count== 1}">
                                 &nbsp;좋아요 0
                                 </c:if>
												<c:if test="${dto.like_count!= 1}">
                                 &nbsp;좋아요 ${dto.like_count -1 }
                                 </c:if>

											</span>
										</span>


									</span>
								</c:if>



								<!-- comment -->
								<span class="bottom-right commentspan" style="cursor: pointer;" user_name=${dto.user_name }
									post_num="${dto.post_num }">
									<span style="font-size: 1.3em; color: gray;">
										<i class="fa-regular fa-comment"></i>
									</span>
									&nbsp;댓글 ${dto.comment_count }
								</span>


							</div>

						</div>

					</div>
					<br>
					<br>
				</c:if>

				<!-- 파일이 없을 경우 -->
				<c:if test="${dto.post_file=='no' }">
					<div class="shows" id="divs${dto.post_num }">
						<div class="showtext">게시물을 숨겼습니다. 다시 보려면 게시물 보기를 눌러주세요.</div>
						<button type="button" class="showbtn" divpost_num="div${dto.post_num }"
							divspost_num="divs${dto.post_num }">게시물 보기</button>
					</div>
					<div class="divmain2" id="div${dto.post_num }">
						<div class="top2">
							<div class="top-left2">
								<span style="float: left;" class="userimgdiv">
									 <c:if test="${dto.user_photo==null }">
                              <img src="/image/noimg.png" class="userimg" user_num="${dto.user_num}">;
                        </c:if>
                           <c:if test="${dto.user_photo!=null }">
                              <img src="${root }/photo/${dto.user_photo}" class="userimg" user_num="${dto.user_num }">
                           </c:if>
								</span>
								<span style="float: left; padding: 3%; margin-right: 5px;">
									<div>
										<b>${dto.user_name }
											<c:if test="${dto.post_access =='follower'}">
												<i class="fa-solid fa-user-group"></i>
											</c:if>
											<c:if test="${dto.post_access =='all'}">
												<i class="fa-solid fa-earth-americas"></i>
											</c:if>
											<c:if test="${dto.post_access =='onlyme'}">
												<i class="fa-solid fa-lock"></i>
											</c:if>


										</b>
									</div>

									<div>${dto.post_time }</div>
								</span>
							</div>
							<span class="top-right2">
								<c:if test="${dto.user_num!=sessionScope.user_num &&dto.checkfollowing !=1 }">
									<span class="follow" id="follow${dto.post_num}" followpost_num="follow${dto.post_num }"
										unfollowpost_num="unfollow${dto.post_num }" from_user="${sessionScope.user_num }"
										to_user="${dto.user_num }">팔로우 </span>

									<span class="unfollow" id="unfollow${dto.post_num }"
										followpost_num="follow${dto.post_num }" unfollowpost_num="unfollow${dto.post_num }"
										to_user="${dto.user_num }" style="display: none;">팔로우</span>
								</c:if>
								<c:if test="${dto.user_num!=sessionScope.user_num && dto.checkfollowing ==1 }">
									<span class="unfollow" id="unfollow${dto.post_num }"
										followpost_num="follow${dto.post_num }" unfollowpost_num="unfollow${dto.post_num }"
										to_user="${dto.user_num }">팔로우</span>
									<span class="follow" id="follow${dto.post_num}" followpost_num="follow${dto.post_num }"
										unfollowpost_num="unfollow${dto.post_num }" from_user="${sessionScope.user_num }"
										to_user="${dto.user_num }" style="display: none;">팔로우</span>
								</c:if>
								<span class="postmenu dropdown" post_num="${dto.post_num }"
									user_num="${sessionScope.user_num }" dtouser_num="${dto.user_num}">
									<i class="fa-solid fa-ellipsis"></i>
									<c:if test="${dto.checklogin ==1 }">

										<ul id="${dto.post_num }" class="dropdown-menu dropdown-menu-right postsubmenu"
											style="font-size: 18px; line-height: 1.5em; display: none;">


											<li id="postupdate" class="postdetail" data-toggle="modal" data-target="#updatepost"
												post_num="${dto.post_num }" user_num="${dto.user_num }">게시물 수정</li>
											<li id="postdelete" class="postdetail" user_num="${dto.user_num }"
												post_num="${dto.post_num }">게시물 삭제</li>
										</ul>
									</c:if>
									<c:if test="${dto.checklogin !=1 }">
										<ul id="${dto.post_num }" class="dropdown-menu dropdown-menu-right postsubmenu"
											style="font-size: 18px; line-height: 1.5em; display: none;">
											<li class="postdetail posthide" divpost_num="div${dto.post_num }"
												divspost_num="divs${dto.post_num }">게시물 숨김</li>
										</ul>
									</c:if>
								</span>

							</span>
						</div>
						<div class="center2">
							<div class="center-up2">${dto.post_content }</div>

						</div>
						<div class="bottom2">
							<!-- 선 없길래 추가함 -->
							<hr style="border: 1px solid #ced0d4; margin-bottom: 1%;">
							<div class="bottom-up2">



								<!-- 체크 안했으면 보이는거 -->
								<c:if test="${dto.likecheck ==0 }">
									<span class="bottom-left2 liketoggle" style="cursor: pointer"
										user_num="${sessionScope.user_num}" likehide1_num="likehide1${dto.post_num}"
										likeshow1_num="likeshow1${dto.post_num}" post_num="${dto.post_num }">
										<span class="like" id="likehide1${dto.post_num}" user_num="${sessionScope.user_num}"
											likehide1_num="likehide1${dto.post_num}" likeshow1_num="likeshow1${dto.post_num}"
											post_num="${dto.post_num }">
											<span style="font-size: 1.2em; top: 3px; color: gray;">
												<i class="fa-regular fa-thumbs-up"></i>
											</span>
											<c:if test="${dto.like_count==0 }">
                                 &nbsp;좋아요 ${dto.like_count}
                                 </c:if>
											<c:if test="${dto.like_count !=0 }">
                                 &nbsp;좋아요 ${dto.like_count}명
                                 </c:if>
										</span>
										<span class="dlike" id="likeshow1${dto.post_num}" user_num="${sessionScope.user_num}"
											post_num="${dto.post_num }" style="display: none;">
											<span style="font-size: 1.2em; top: 3px; color: blue;">
												<i class="fa-solid fa-thumbs-up"></i>
											</span>
											<c:if test="${dto.like_count==0 }">
                                 &nbsp;좋아요 회원님 
                                 </c:if>
											<c:if test="${dto.like_count !=0 }">
                                 &nbsp;좋아요 회원님 외${dto.like_count}명
                                 </c:if>
										</span>

									</span>


								</c:if>

								<!-- 처음부터 체크되어있으면 보이는거  -->
								<c:if test="${dto.likecheck !=0 }">
									<span class="bottom-left2 liketoggle2" style="cursor: pointer"
										likehide2_num="likehide2${dto.post_num}" likeshow2_num="likeshow2${dto.post_num}"
										user_num="${sessionScope.user_num}" post_num="${dto.post_num }">
										<span id="likehide2${dto.post_num}" class="dlike" user_num="${sessionScope.user_num}"
											likehide1_num="likehide1${dto.post_num}" likeshow1_num="likeshow1${dto.post_num}"
											post_num="${dto.post_num }">
											<span style="font-size: 1.2em; top: 3px; color: blue;">
												<i class="fa-solid fa-thumbs-up"></i>
											</span>

											<c:if test="${dto.like_count!= 1}">
                                 &nbsp;좋아요 회원님 외 ${dto.like_count-1}명
                                 </c:if>
											<c:if test="${dto.like_count ==1 }">
                                 &nbsp;좋아요 회원님 
                                 </c:if>
										</span>
										<span user_num="${sessionScope.user_num}" id="likeshow2${dto.post_num}" class="like"
											post_num="${dto.post_num }" style="display: none;">
											<span style="font-size: 1.2em; top: 3px; color: gray;">
												<i class="fa-regular fa-thumbs-up"></i>
												<c:if test="${dto.like_count== 1}">
                                 &nbsp;좋아요 0
                                 </c:if>
												<c:if test="${dto.like_count!= 1}">
                                 &nbsp;좋아요 ${dto.like_count -1 }
                                 </c:if>

											</span>
										</span>


									</span>
								</c:if>


								<!-- comment -->
								<span class="bottom-right2 commentspan" style="cursor: pointer;" user_name=${dto.user_name }
									post_num="${dto.post_num }">
									<span style="font-size: 1.2em; top: 3px; color: gray;">
										<i class="fa-regular fa-comment"></i>
									</span>
									&nbsp;댓글 ${dto.comment_count }
								</span>


							</div>


						</div>


					</div>

					<br>
					<br>
				</c:if>
			</c:forEach>
		</section>


		<button type="button" class="btn btn-info btn-lg cmmodalbtn hide" data-toggle="modal"
			data-target="#commentmodal"></button>
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
						<sectiontime id="posttsection"></sectiontime>
						<br>
						<hr>
						<section1 id="commentsection"> <!-- 댓글 나올 부분 --> </section1>
						<button type="button" class="btn btn-success" id="addcomment">댓글 더보기</button>
					</div>
					<div class="modal-footer" style="height: 80px; padding: 0;">
						<form method="post" class="form-inline" id="form">
							<input type="hidden" name="comment_num" value="0"> <input type="hidden"
								name="post_num" id="inputhidden-post_num">
							<div id="commentaddform">
								<c:if test="${sessionScope.user_photo != null }">
									<img src="/photo/${sessionScope.user_photo }" id="commentprofile">
								</c:if>
								<c:if test="${sessionScope.user_photo == null }">
									<img src="/image/noimg.png" id="commentprofile">
								</c:if>
								<input hidden="hidden" /> <input type="text" class="mominput" name="comment_content"
									placeholder="댓글을 입력하세요" id="commentinput">
								<button type="button" id="insertcommentbtn" class="insertcommentimg"
									style="margin-right: 20px;"></button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>