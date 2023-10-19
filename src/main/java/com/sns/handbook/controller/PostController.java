package com.sns.handbook.controller;

import java.io.File; 
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sns.handbook.dto.CommentDto;
import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.PostlikeDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.CommentService;
import com.sns.handbook.serivce.FollowingService;
import com.sns.handbook.serivce.PostService;
import com.sns.handbook.serivce.PostlikeService;
import com.sns.handbook.serivce.UserService;

@Controller
public class PostController {

	@Autowired
	PostService pservice;

	@Autowired
	PostlikeService plservice;

	@Autowired
	UserService uservice;

	@Autowired
	FollowingService fservice;
	
	@Autowired
	CommentService cservice;

	@GetMapping("/post/write")
	public String write() {
		return "/post/post_writeform";
	}

	@GetMapping("/post/timeline")
	@ResponseBody
	public ModelAndView list(@RequestParam(defaultValue = "0") int offset,@RequestParam(defaultValue = "0") int commentoffset, HttpSession session,
			@RequestParam(required = false) String searchcolumn, @RequestParam(required = false) String searchword,
			FollowingDto fdto) {

		List<PostDto> list = pservice.postList((String)session.getAttribute("user_num"),searchcolumn, searchword, offset);
		for (int i = 0; i < list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getUser_num()); // 여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방
																			// num을 list에서 뽑아옴

			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			// list.get(i).setUser_name(list.get(i).getUser_name());
			// list.get(i).setUser_photo(list.get(i).getUser_photo());
			list.get(i).setLike_count(plservice.getTotalLike(list.get(i).getPost_num()));
			list.get(i).setComment_count(cservice.getTotalCount(list.get(i).getPost_num()));
			list.get(i).setLikecheck(
					plservice.checklike((String) session.getAttribute("user_num"), list.get(i).getPost_num()));
			list.get(i).setChecklogin(
					pservice.checklogin(list.get(i).getPost_num(), (String) session.getAttribute("user_num")));
			list.get(i).setCheckfollowing(
					fservice.checkFollowing((String) session.getAttribute("user_num"), list.get(i).getUser_num()));

			// 대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today = new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday = new Date();
			try {
				writeday = sdf.parse(list.get(i).getPost_writeday().toString());
				/* System.out.println(writeday); */
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long diffSec = (today.getTime() - writeday.getTime());
			diffSec -= 32400000L; // DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
			/* System.out.println(diffSec); */

			// 일시분초
			long day = (diffSec / (60 * 60 * 24 * 1000L)) % 365;
			long hour = (diffSec / (60 * 60 * 1000L)) % 24;
			long minute = (diffSec / (60 * 1000L)) % 60;
			long second = (diffSec / 1000L) % 60;

			String preTime = "";

			if (day != 0) {
				// 하루 이상이 지났으면 일수만 표시
				preTime = "" + day + "일 전";
			} else {
				if (hour != 0) {
					// 1시간 이상이 지났으면 시(hour)만 표시
					preTime = "" + hour + "시간 전";
				} else {
					if (minute != 0) {
						// 1분 이상이 지났으면 분만 표시
						preTime = "" + minute + "분 전";
					} else {
						// 1분 미만 초만 표시
						preTime = "" + second + "초 전";
					}
				}
			}

			list.get(i).setPost_time(preTime);
			
		}

		String login_name = uservice.getUserByNum((String) session.getAttribute("user_num")).getUser_name();
		ModelAndView model = new ModelAndView();
		int totalCount = pservice.getTotalCount();
		
		
		//팔로우리스트 보내기
		List<FollowingDto> ftlist = fservice.getFollowList((String)session.getAttribute("user_num"), 0); 
		
		for(int i = 0; i<ftlist.size(); i++) {
			UserDto dto = uservice.getUserByNum(ftlist.get(i).getTo_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			ftlist.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			ftlist.get(i).setUser_photo(dto.getUser_photo());
		}
		model.addObject("offset", offset);
		model.addObject("commentoffset", commentoffset);
		model.addObject("searchcolumn", searchcolumn);
		model.addObject("total", totalCount);
		model.addObject("list", list);
		model.addObject("ftlist", ftlist);
		model.addObject("login_name", login_name);

		model.setViewName("/post/post_timeline");
		return model;
	}

	@PostMapping("/post/insertpost")
	@ResponseBody
	public void insertPost(@ModelAttribute PostDto dto, @RequestParam(required = false) List<MultipartFile> photo, HttpSession session) {
		
	    String path = session.getServletContext().getRealPath("/post_file");
	    
	    int idx = 1;
	    String uploadName = "";
	    String postContent = dto.getPost_content();     
        postContent = postContent.replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>");
        dto.setPost_content(postContent);
	    
	    if (photo == null) {
	        dto.setPost_file("no");
	        pservice.insertPost(dto);
	        
	    } else {
	    	
	        for (MultipartFile f : photo) {
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
	            String fileName = idx++ + "_" + sdf.format(new Date()) + "_" + f.getOriginalFilename();
	            uploadName += fileName + ",";
	            
	            try {
	                f.transferTo(new File(path + "\\" + fileName));
	            } catch (IllegalStateException | IOException e) {
	                e.printStackTrace();
	            }
	        }
	        //콤마 제거
	        uploadName = uploadName.substring(0, uploadName.length() - 1);
	        
		    dto.setPost_file(uploadName);
		    pservice.insertPost(dto);
		    
	    }
	    
	}

	// delete
	@GetMapping("/post/delete")
	@ResponseBody
	public void delete(@RequestParam String post_num, HttpSession session ) {

		//사진 이름 받기
		String delPhoto=pservice.getDataByNum(post_num).getPost_file();
		
		if(delPhoto!="no") {
			//사진이 존재한다면 삭제
			String path=session.getServletContext().getRealPath("/post_file");
			
			File delFile=new File(path+"\\"+delPhoto);
			
			//파일(사진) 삭제
			delFile.delete();
		}
		
		pservice.deletePost(post_num);
	}

	@PostMapping("/post/updatephoto")
	@ResponseBody
	public void photoUpload(String post_num, @RequestParam(required = false) MultipartFile photo, HttpSession session) {
		// 업로드될 경로구하기
		String path = session.getServletContext().getRealPath("/post_file");

		// 파일명구하기
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String fileName = "f_" + sdf.format(new Date()) + photo.getOriginalFilename();

		try {
			photo.transferTo(new File(path + "\\" + fileName));

			pservice.updatePhoto(post_num, fileName); // db사진 수정
			session.setAttribute("post_file", fileName); // 세션의 사진변경

		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@GetMapping("/post/updateform")
	@ResponseBody
	public PostDto getData(String post_num) {
		
		PostDto dto=pservice.getDataByNum(post_num);
		
		String postContent = dto.getPost_content();     
        postContent = postContent.replaceAll("&nbsp;"," ").replaceAll("<br>", "\n");
        dto.setPost_content(postContent);
		
		return dto;	
	}

	// 수정
	@PostMapping("/post/update")
	@ResponseBody
	public void update(@ModelAttribute PostDto dto,HttpSession session,
			@RequestParam(required = false) List<MultipartFile> photo,
			@RequestParam String photodel)
	{
		
		String path = session.getServletContext().getRealPath("/post_file");
	    
	    int idx = 1;
	    String uploadName = "";
	    String postContent = dto.getPost_content();     
        postContent = postContent.replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>");
        dto.setPost_content(postContent);	    
	    
	    if (photo != null) {
	      
	        for (MultipartFile f : photo) {
	    	    
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
	            String fileName = idx++ + "_" + sdf.format(new Date()) + "_" + f.getOriginalFilename();
	            uploadName += fileName + ",";
	            
	            try {
	            	
	                f.transferTo(new File(path + "\\" + fileName));
	                
	            } catch (IllegalStateException | IOException e) {
	                e.printStackTrace();
	            }
	        }
	        //콤마 제거
	        uploadName = uploadName.substring(0, uploadName.length() - 1);
	        
		    dto.setPost_file(uploadName);
		    
		    pservice.updatePhoto(dto.getPost_num(), uploadName);
		    
	    }else if(photodel.equals("true")) {
	    	pservice.updatePhoto(dto.getPost_num(), "no");
	    }
	    
	    pservice.updatePost(dto);
	    
	    
	}


	@GetMapping("/post/scroll")
	@ResponseBody
	public List<PostDto> scroll(int offset, @RequestParam(required = false) String searchcolumn,
			@RequestParam(required = false) String searchword, HttpSession session) {

		List<PostDto> list = pservice.postList((String)session.getAttribute("user_num"),searchcolumn, searchword, offset);
		
		for (int i = 0; i < list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getUser_num()); // 여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방
																			// num을 list에서 뽑아옴

			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			// list.get(i).setUser_name(list.get(i).getUser_name());
			// list.get(i).setUser_photo(list.get(i).getUser_photo());
			list.get(i).setLike_count(plservice.getTotalLike(list.get(i).getPost_num()));
			list.get(i).setComment_count(cservice.getTotalCount(list.get(i).getPost_num()));
			list.get(i).setLikecheck(
					plservice.checklike((String) session.getAttribute("user_num"), list.get(i).getPost_num()));
			list.get(i).setChecklogin(
					pservice.checklogin(list.get(i).getPost_num(), (String) session.getAttribute("user_num")));
			list.get(i).setCheckfollowing(
					fservice.checkFollowing((String) session.getAttribute("user_num"), list.get(i).getUser_num()));

			// 대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today = new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday = new Date();
			try {
				writeday = sdf.parse(list.get(i).getPost_writeday().toString());
				/* System.out.println(writeday); */
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long diffSec = (today.getTime() - writeday.getTime());
			diffSec -= 32400000L; // DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
			/* System.out.println(diffSec); */

			// 일시분초
			long day = (diffSec / (60 * 60 * 24 * 1000L)) % 365;
			long hour = (diffSec / (60 * 60 * 1000L)) % 24;
			long minute = (diffSec / (60 * 1000L)) % 60;
			long second = (diffSec / 1000L) % 60;

			String preTime = "";

			if (day != 0) {
				// 하루 이상이 지났으면 일수만 표시
				preTime = "" + day + "일 전";
			} else {
				if (hour != 0) {
					// 1시간 이상이 지났으면 시(hour)만 표시
					preTime = "" + hour + "시간 전";
				} else {
					if (minute != 0) {
						// 1분 이상이 지났으면 분만 표시
						preTime = "" + minute + "분 전";
					} else {
						// 1분 미만 초만 표시
						preTime = "" + second + "초 전";
					}
				}
			}

			list.get(i).setPost_time(preTime);
			
		}

		return list;
	}
	
	
	@GetMapping("post/getpostdata")
	@ResponseBody
	public List<PostDto> getPostDataForModal(String post_num,HttpSession session){
		
		List<PostDto> list = new ArrayList<>(); // List 객체 생성

		PostDto pdto = pservice.getDataByNum(post_num); // 데이터 가져오기

		list.add(pdto);
		
		for (int i = 0; i < list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getUser_num()); // 여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방
																			// num을 list에서 뽑아옴

			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			// list.get(i).setUser_name(list.get(i).getUser_name());
			// list.get(i).setUser_photo(list.get(i).getUser_photo());
			list.get(i).setLike_count(plservice.getTotalLike(list.get(i).getPost_num()));
			list.get(i).setComment_count(cservice.getTotalCount(list.get(i).getPost_num()));
			list.get(i).setLikecheck(
					plservice.checklike((String) session.getAttribute("user_num"), list.get(i).getPost_num()));
			list.get(i).setChecklogin(
					pservice.checklogin(list.get(i).getPost_num(), (String) session.getAttribute("user_num")));
			list.get(i).setCheckfollowing(
					fservice.checkFollowing((String) session.getAttribute("user_num"), list.get(i).getUser_num()));

			// 대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today = new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday = new Date();
			try {
				writeday = sdf.parse(list.get(i).getPost_writeday().toString());
				/* System.out.println(writeday); */
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long diffSec = (today.getTime() - writeday.getTime());
			diffSec -= 32400000L; // DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
			/* System.out.println(diffSec); */

			// 일시분초
			long day = (diffSec / (60 * 60 * 24 * 1000L)) % 365;
			long hour = (diffSec / (60 * 60 * 1000L)) % 24;
			long minute = (diffSec / (60 * 1000L)) % 60;
			long second = (diffSec / 1000L) % 60;

			String preTime = "";

			if (day != 0) {
				// 하루 이상이 지났으면 일수만 표시
				preTime = "" + day + "일 전";
			} else {
				if (hour != 0) {
					// 1시간 이상이 지났으면 시(hour)만 표시
					preTime = "" + hour + "시간 전";
				} else {
					if (minute != 0) {
						// 1분 이상이 지났으면 분만 표시
						preTime = "" + minute + "분 전";
					} else {
						// 1분 미만 초만 표시
						preTime = "" + second + "초 전";
					}
				}
			}

			list.get(i).setPost_time(preTime);
			
		}
		
		
		
		return list;
	}

	/*
	 * @GetMapping("/post/checklike")
	 * 
	 * @ResponseBody public Map<String, Integer> checklike(String user_num,String
	 * post_num){ Map<String, Integer> map= new HashMap<>();
	 * 
	 * map.put("checklike", plservice.checklike(user_num, post_num));
	 * 
	 * return map; }
	 */

	@GetMapping("/post/likeinsert")
	@ResponseBody
	public void insertLike(@ModelAttribute PostlikeDto dto) {

		plservice.insertLike(dto);
	}

	@GetMapping("/post/likedelete")
	@ResponseBody
	public void deleteFollowing(String post_num, String user_num) {

		plservice.deleteLike(post_num, user_num);
	}

	@GetMapping("/post/followinginsert")
	@ResponseBody
	public void followinginseret(@ModelAttribute FollowingDto dto) {

		fservice.insertFollowing(dto);
	}

	@GetMapping("/post/followingdelete")
	@ResponseBody
	public void followingdelete(String to_user, HttpSession session) {

		fservice.deleteFollowing((String)session.getAttribute("user_num"),to_user);

	}

	/*
	 * @GetMapping("/post/logincheck")
	 * 
	 * @ResponseBody public Map<String, Integer> logioncheck(String user_num,String
	 * post_num){ Map<String, Integer> map= new HashMap<>();
	 * 
	 * map.put("logincheck", pservice.logincheck(user_num, post_num));
	 * 
	 * return map; }
	 */

}