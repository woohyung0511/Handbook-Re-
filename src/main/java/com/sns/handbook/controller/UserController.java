package com.sns.handbook.controller;

import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.mail.Session;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sns.handbook.dto.CommentDto;
import com.sns.handbook.dto.CommentlikeDto;
import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.GuestbookDto;
import com.sns.handbook.dto.GuestbooklikeDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.PostlikeDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.CommentService;
import com.sns.handbook.serivce.FollowingService;
import com.sns.handbook.serivce.GuestbooklikeService;
import com.sns.handbook.serivce.PostService;
import com.sns.handbook.serivce.PostlikeService;
import com.sns.handbook.serivce.UserService;

@Controller
public class UserController {

	@Autowired
	UserService uservice;

	@Autowired
	FollowingService fservice;

	@Autowired
	PostService pservice;

	@Autowired
	PostlikeService plservice;

	@Autowired
	GuestbooklikeService glservice;

	@Autowired
	CommentService cservice;

	@Autowired
	PasswordEncoder passwordEncoder;

	//커버 사진 업데이트
	@PostMapping("/user/coverupdate")
	@ResponseBody
	public void coverupdate(String user_num, MultipartFile cover,
							HttpSession session,@ModelAttribute UserDto dto) {
		//업로드 경로
		String path=session.getServletContext().getRealPath("/cover");

		//파일명 구하기
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
		String coverName="f_"+sdf.format(new Date())+cover.getOriginalFilename();

		try {
			cover.transferTo(new File(path+"\\"+coverName));

			//db수정
			uservice.updateCover(user_num, coverName);

		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	//프로필 사진 업데이트
	@PostMapping("/user/photoupdate")
	@ResponseBody
	public void photoupdate(String user_num,MultipartFile photo,
							HttpSession session,@ModelAttribute UserDto dto) {
		//업로드 경로
		String path=session.getServletContext().getRealPath("/photo");

		//파일명 구하기
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
		String photoName="f_"+sdf.format(new Date())+photo.getOriginalFilename();
		session.setAttribute("user_photo", photoName);

		try {
			photo.transferTo(new File(path+"\\"+photoName));

			uservice.updatePhoto(user_num, photoName);

		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	//마이페이지 이동
	@GetMapping("/user/mypage")
	public ModelAndView mypage(@RequestParam(defaultValue = "0") int offset,@RequestParam(defaultValue = "0") int commentoffset,
			String user_num,
			@RequestParam(required = false) String post_num,
			@RequestParam(required = false) String guest_num,
			@RequestParam(required = false) String comment_num,
			HttpSession session) {

		ModelAndView model=new ModelAndView();

		int followercount=fservice.getTotalFollower(user_num);
		int followcount=fservice.getTotalFollowing(user_num);
		String loginnum=uservice.getUserById((String)session.getAttribute("myid")).getUser_num();

		UserDto udto=uservice.getUserByNum(user_num);
		/* List<GuestbookDto> guestlist=uservice.getGuestPost(user_num); */
		/* List<PostDto> postlist=uservice.getPost(user_num); */
		List<GuestbookDto> guestlist=uservice.selectGuestbookByAccess((String)session.getAttribute("user_num"),user_num);
		List<PostDto> postlist=uservice.selectPostsByAccess(user_num, (String)session.getAttribute("user_num"));
		
		List<Map<String, Object>> alllist=new ArrayList<>();


		for(int i=0;i<postlist.size();i++) {
			postlist.get(i).setComment_count(cservice.getTotalCount(postlist.get(i).getPost_num()));
			postlist.get(i).setUser_name(uservice.getUserByNum(postlist.get(i).getUser_num()).getUser_name());
		}

		for(int i=0;i<guestlist.size();i++) {
			guestlist.get(i).setComment_count(cservice.getTotalGuestCount(guestlist.get(i).getGuest_num()));
			guestlist.get(i).setUser_name(uservice.getUserByNum(guestlist.get(i).getWrite_num()).getUser_name());
		}

		for(PostDto p:postlist) {
			Map<String, Object> map=new HashMap<>();

			map.put("post_num", p.getPost_num());
			map.put("user_num", p.getUser_num());
			map.put("owner_num", null);
			map.put("post_content", p.getPost_content());
			map.put("post_file", p.getPost_file());
			map.put("post_access", p.getPost_access());
			map.put("post_writeday", p.getPost_writeday());
			map.put("post_time", p.getPost_time());
			map.put("like_count", plservice.getTotalLike(p.getPost_num()));
			map.put("likecheck", plservice.checklike((String)session.getAttribute("user_num"),p.getPost_num()));
			map.put("comment_count",p.getComment_count());
			map.put("type", "post");
			map.put("user_name", p.getUser_name());

			alllist.add(map);
		}

		for(GuestbookDto g:guestlist) {
			Map<String, Object> map=new HashMap<>();

			map.put("post_num", g.getGuest_num());
			map.put("user_num", g.getWrite_num());
			map.put("owner_num", g.getOwner_num());
			map.put("post_content", g.getGuest_content());
			map.put("post_file", g.getGuest_file());
			map.put("post_access", g.getGuest_access());
			map.put("post_writeday", g.getGuest_writeday());
			map.put("like_count", glservice.getTotalGuestLike(g.getGuest_num()));
			map.put("likecheck", glservice.checkGuestLike((String)session.getAttribute("user_num"), g.getGuest_num()));
			map.put("comment_count",g.getComment_count());
			map.put("type", "guest");
			map.put("user_name", g.getUser_name());

			UserDto dto=uservice.getUserByNum(g.getWrite_num());
			map.put("dto", dto);

			alllist.add(map);
		}

		//최신 순 정렬
		alllist.sort((map1, map2) -> {
		    Date date1 = (Date) map1.get("post_writeday");
		    Date date2 = (Date) map2.get("post_writeday");
		    return date2.compareTo(date1); // 내림차순 정렬
		});


		for(int i = 0; i<alllist.size(); i++) {
			//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today=new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday=new Date();
			try {
				writeday=sdf.parse(alllist.get(i).get("post_writeday").toString());
				/* System.out.println(writeday); */
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long diffSec=(today.getTime()-writeday.getTime());
			diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
			/* System.out.println(diffSec); */

			//일시분초
			long day=(diffSec/(60*60*24*1000L))%365;
			long hour=(diffSec/(60*60*1000L))%24;
			long minute=(diffSec/(60*1000L))%60;
			long second=(diffSec/1000L)%60;

			String preTime="";

			if(day!=0) {
				//하루 이상이 지났으면 일수만 표시
				preTime=""+day+"일 전";
			}else {
				if(hour!=0) {
					//1시간 이상이 지났으면 시(hour)만 표시
					preTime=""+hour+"시간 전";
				}else {
					if(minute!=0) {
						//1분 이상이 지났으면 분만 표시
						preTime=""+minute+"분 전";
					}else {
						//1분 미만 초만 표시
						preTime=""+second+"초 전";
					}
				}
			}

			alllist.get(i).put("post_time", preTime);
		}

		List<FollowingDto> tflist=uservice.getFollowList(user_num, offset);

		for(int i = 0; i<tflist.size(); i++) {
			UserDto dto = uservice.getUserByNum(tflist.get(i).getTo_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			tflist.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			tflist.get(i).setUser_photo(dto.getUser_photo());
			tflist.get(i).setUser_num(dto.getUser_num());
			tflist.get(i).setTf_count(fservice.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));
		}

		model.addObject("alllist", alllist);
		model.addObject("loginnum", loginnum);
		model.addObject("dto", udto);
		model.addObject("offset", offset);
		model.addObject("commentoffset", commentoffset);
		model.addObject("tflist", tflist);
		model.addObject("postlist",postlist);
		model.addObject("followercount", followercount);
		model.addObject("followcount", followcount);
		model.addObject("checkfollowing", fservice.checkFollowing((String)session.getAttribute("user_num"), user_num));
		model.addObject("checkfollower", fservice.checkFollower((String)session.getAttribute("user_num"), user_num));
		model.addObject("tf_count", fservice.getTotalFollowing(uservice.getUserByNum(user_num).getUser_num()));

		//예지

		model.addObject("post_num",post_num);

		//게스트글

		if(guest_num!=null) {
			GuestbookDto guestdto=uservice.getDataByGuestNum(guest_num);
			model.addObject("guest_num",guest_num);

			user_num=guestdto.getOwner_num();
		}

		//댓글
		if(comment_num!=null) {
			CommentDto commentdto=cservice.getData(comment_num);
			model.addObject("post_num",commentdto.getPost_num());
			model.addObject("guest_num",commentdto.getGuest_num());

			if(commentdto.getPost_num()==null) {
				user_num=uservice.getDataByGuestNum(commentdto.getGuest_num()).getOwner_num();
			}

			System.out.println("post: "+commentdto.getPost_num()+", guest: "+commentdto.getGuest_num());
		}

		//////
		
		model.setViewName("/sub/user/mypage");

		return model;
	}
	
	@GetMapping("user/getmypostdata")
	@ResponseBody
	public List<Map<String, Object>> mypostdata(@RequestParam(defaultValue = "0") String post_num,@RequestParam(defaultValue = "0") String guest_num,HttpSession session){
		
		
		List<Map<String, Object>> alllist=new ArrayList<>();
		
		if(post_num.equals("0")) {
			List<GuestbookDto> guestlist=new ArrayList<>();
			GuestbookDto gdto=uservice.getDataByGuestNum(guest_num);
			guestlist.add(gdto);
			
			for(int i=0;i<guestlist.size();i++) {
				guestlist.get(i).setComment_count(cservice.getTotalGuestCount(guestlist.get(i).getGuest_num()));
				guestlist.get(i).setUser_name(uservice.getUserByNum(guestlist.get(i).getWrite_num()).getUser_name());
			}
			
			for(GuestbookDto g:guestlist) {
				Map<String, Object> map=new HashMap<>();

				map.put("post_num", g.getGuest_num());
				map.put("user_num", g.getWrite_num());
				map.put("owner_num", g.getOwner_num());
				map.put("post_content", g.getGuest_content());
				map.put("post_file", g.getGuest_file());
				map.put("post_access", g.getGuest_access());
				map.put("post_writeday", g.getGuest_writeday());
				map.put("like_count", glservice.getTotalGuestLike(g.getGuest_num()));
				map.put("likecheck", glservice.checkGuestLike((String)session.getAttribute("user_num"), g.getGuest_num()));
				map.put("comment_count",g.getComment_count());
				map.put("type", "guest");
				map.put("user_name", g.getUser_name());

				UserDto dto=uservice.getUserByNum(g.getWrite_num());
				map.put("dto", dto);

				alllist.add(map);
			}
			
		}else {
			List<PostDto> postlist=new ArrayList<>();
			PostDto pdto=pservice.getDataByNum(post_num);
			postlist.add(pdto);		
			
			for(int i=0;i<postlist.size();i++) {
				postlist.get(i).setComment_count(cservice.getTotalCount(postlist.get(i).getPost_num()));
				postlist.get(i).setUser_name(uservice.getUserByNum(postlist.get(i).getUser_num()).getUser_name());
			}
			
			for(PostDto p:postlist) {
				Map<String, Object> map=new HashMap<>();

				map.put("post_num", p.getPost_num());
				map.put("user_num", p.getUser_num());
				map.put("owner_num", null);
				map.put("post_content", p.getPost_content());
				map.put("post_file", p.getPost_file());
				map.put("post_access", p.getPost_access());
				map.put("post_writeday", p.getPost_writeday());
				map.put("post_time", p.getPost_time());
				map.put("like_count", plservice.getTotalLike(p.getPost_num()));
				map.put("likecheck", plservice.checklike((String)session.getAttribute("user_num"),p.getPost_num()));
				map.put("comment_count",p.getComment_count());
				map.put("type", "post");
				map.put("user_name", p.getUser_name());
				
				UserDto dto=uservice.getUserByNum(p.getUser_num());
				map.put("dto", dto);

				alllist.add(map);
			}
			}
		for(int i = 0; i<alllist.size(); i++) {
			//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today=new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday=new Date();
			try {
				writeday=sdf.parse(alllist.get(i).get("post_writeday").toString());
				/* System.out.println(writeday); */
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long diffSec=(today.getTime()-writeday.getTime());
			diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
			/* System.out.println(diffSec); */

			//일시분초
			long day=(diffSec/(60*60*24*1000L))%365;
			long hour=(diffSec/(60*60*1000L))%24;
			long minute=(diffSec/(60*1000L))%60;
			long second=(diffSec/1000L)%60;

			String preTime="";

			if(day!=0) {
				//하루 이상이 지났으면 일수만 표시
				preTime=""+day+"일 전";
			}else {
				if(hour!=0) {
					//1시간 이상이 지났으면 시(hour)만 표시
					preTime=""+hour+"시간 전";
				}else {
					if(minute!=0) {
						//1분 이상이 지났으면 분만 표시
						preTime=""+minute+"분 전";
					}else {
						//1분 미만 초만 표시
						preTime=""+second+"초 전";
					}
				}
			}

			alllist.get(i).put("post_time", preTime);
		}
		
		return alllist;
			
	}

	//게시물 사진 여러장 올리기
	@PostMapping("/user/insertpost")
	@ResponseBody
	public void insertPost(@ModelAttribute PostDto dto, @RequestParam(required = false) List<MultipartFile> photo, HttpSession session) {

		String path = session.getServletContext().getRealPath("/post_file");

		int idx = 1;
		String uploadName = "";

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

	//프로필 업데이트
	@ResponseBody
	@PostMapping("/user/updateinfo")
	public void updateinfo(UserDto dto) {
		uservice.updateUserInfo(dto);
	}


	//게시물 수정 값 불러오기
	@ResponseBody
	@GetMapping("/user/updateform")
	public PostDto updateform(String post_num) {
		PostDto dto=pservice.getDataByNum(post_num);

		return dto;
	}

	//게시물 수정
	@ResponseBody
	@PostMapping("/user/updatepost")
	public void updatepost(@ModelAttribute PostDto dto,HttpSession session,@RequestParam(required = false) List<MultipartFile> photo) {

		String path = session.getServletContext().getRealPath("/post_file");

		int idx = 1;
		String uploadName = "";


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

		}

		pservice.updatePost(dto);


	}


	//게시물 삭제(사진까지 삭제)
	@ResponseBody
	@GetMapping("/user/deletepost")
	public void deletepost(String post_num, HttpSession session) {
		String delPhoto=pservice.getDataByNum(post_num).getPost_file();

		if(delPhoto!="no") {

			String path=session.getServletContext().getRealPath("/post_file");

			File delFile=new File(path+"\\"+delPhoto);

			delFile.delete();
		}

		pservice.deletePost(post_num);
	}

	//좋아요
	@GetMapping("/user/likeinsert")
	@ResponseBody
	public void insertLike(@ModelAttribute PostlikeDto dto) {


		plservice.insertLike(dto);
	}

	//좋아요 취소
	@GetMapping("/user/likedelete")
	@ResponseBody
	public void deleteLike(String post_num,String user_num) {

		plservice.deleteLike(post_num,user_num);
	}

	//방명록 좋아요
	@GetMapping("/user/guestlikeinsert")
	@ResponseBody
	public void insertGuestLike(@ModelAttribute GuestbooklikeDto dto) {

		glservice.insertGuestLike(dto);
	}

	//방명록 좋아요 취소
	@GetMapping("/user/guestlikedelete")
	@ResponseBody
	public void deleteGuestLike(String guest_num,String user_num) {

		glservice.deleteGuestLike(guest_num, user_num);
	}

	//팔로우 하기
	@ResponseBody
	@GetMapping("/user/insertfollowing")
	public void insertfollowing(@ModelAttribute FollowingDto dto) {
		fservice.insertFollowing(dto);
	}

	//팔로우 취소
	@ResponseBody
	@GetMapping("/user/unfollowing")
	public void followingdelete(String to_user, HttpSession session) {

		fservice.deleteFollowing((String)session.getAttribute("user_num"),to_user);

	}

	//방명록 작성
	@ResponseBody
	@PostMapping("/user/insertguestbook")
	public void insertguestbook(@ModelAttribute GuestbookDto dto, @RequestParam(required = false) List<MultipartFile> photo, HttpSession session) {

		String path = session.getServletContext().getRealPath("/guest_file");

		int idx = 1;
		String uploadName = "";

		if (photo == null) {
			dto.setGuest_file("no");
			uservice.insertGuestBook(dto);

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

			dto.setGuest_file(uploadName);
			uservice.insertGuestBook(dto);

		}

	}

	//방명록 삭제(사진까지 삭제)
	@ResponseBody
	@GetMapping("/user/deleteguestbook")
	public void deleteGuestBook(String guest_num,HttpSession session) {
		String delphoto=uservice.getDataByGuestNum(guest_num).getGuest_file();

		if(delphoto!="no") {

			String path=session.getServletContext().getRealPath("/guest_file");

			File delFile=new File(path+"\\"+delphoto);

			delFile.delete();
		}

		uservice.deleteGuestBook(guest_num);
	}


	//방명록 수정
	@ResponseBody
	@PostMapping("/user/updateguestbook")
	public void updateguestbook(@ModelAttribute GuestbookDto dto,HttpSession session,@RequestParam(required = false) List<MultipartFile> photo) {

		String path = session.getServletContext().getRealPath("/guest_file");

		int idx = 1;
		String uploadName = "";

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

			dto.setGuest_file(uploadName);
		}else {

			String prevFile=uservice.getDataByGuestNum(dto.getGuest_num()).getGuest_file();
			dto.setGuest_file(prevFile);
		}

		uservice.updateGuestBook(dto);
	}


	//방명록 수정 값 불러오기
	@ResponseBody
	@GetMapping("/user/updateguestform")
	public GuestbookDto getDataByGuestNum(String guest_num) {
		GuestbookDto dto=uservice.getDataByGuestNum(guest_num);

		return dto;
	}

	//댓글 입력
	@ResponseBody
	@PostMapping("/user/cinsert")
	public void insert(@ModelAttribute CommentDto dto,HttpSession session) {

		if(!dto.getComment_num().equals("0")) {
			CommentDto momDto= cservice.getData(dto.getComment_num());

			dto.setComment_group(momDto.getComment_group());
			dto.setComment_step(momDto.getComment_step());
			dto.setComment_level(momDto.getComment_level());
		}
		dto.setUser_num((String)session.getAttribute("user_num"));
		cservice.insert(dto);

	}

	//댓글 좋아요
	@GetMapping("/user/commentlikeinsert")
	@ResponseBody
	public void likeinsert(String comment_num,HttpSession session) {

		CommentlikeDto dto=new CommentlikeDto();

		dto.setComment_num(comment_num);
		dto.setUser_num((String)session.getAttribute("user_num"));

		cservice.insertLike(dto);
	}

	//댓글 좋아요 취소
	@GetMapping("/user/commentlikedelete")
	@ResponseBody
	public void likedelete(String comment_num,HttpSession session) {

		CommentlikeDto dto=new CommentlikeDto();

		dto.setComment_num(comment_num);
		dto.setUser_num((String)session.getAttribute("user_num"));

		cservice.deleteLike((String)session.getAttribute("user_num"), comment_num);
	}

	//댓글 스크롤 json데이터 얻기
	@GetMapping("user/scrollcomment")
	@ResponseBody
	public List<CommentDto> scroll (String post_num,int commentoffset,HttpSession session) {

		List<CommentDto> list=cservice.selectScroll(post_num, commentoffset);

		for(int i=0;i<list.size();i++) {

			UserDto udto=uservice.getUserByNum(list.get(i).getUser_num());
			list.get(i).setUser_name(udto.getUser_name());
			list.get(i).setUser_photo(udto.getUser_photo());
			list.get(i).setLike_count(cservice.getTotalLikes(list.get(i).getComment_num()));
			list.get(i).setLike_check(cservice.getLikeCheck((String)session.getAttribute("user_num"), list.get(i).getComment_num()));
			list.get(i).setPost_user_num(pservice.getDataByNum(list.get(i).getPost_num()).getUser_num());

			// 대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today = new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday = new Date();
			try {
				writeday = sdf.parse(list.get(i).getComment_writeday().toString());
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
			list.get(i).setPerTime(preTime);
		}


		return list;

	}

	//방명록 댓글 스크롤 json데이터 얻기
	@GetMapping("user/scrollguestcomment")
	@ResponseBody
	public List<CommentDto> guestScroll (String guest_num,int commentoffset,HttpSession session) {

		List<CommentDto> list=cservice.selectGuestScroll(guest_num, commentoffset);

		for(int i=0;i<list.size();i++) {
			UserDto udto=uservice.getUserByNum(list.get(i).getUser_num());
			list.get(i).setUser_name(udto.getUser_name());
			list.get(i).setUser_photo(udto.getUser_photo());
			list.get(i).setLike_count(cservice.getTotalLikes(list.get(i).getComment_num()));
			list.get(i).setLike_check(cservice.getLikeCheck((String)session.getAttribute("user_num"), list.get(i).getComment_num()));
			list.get(i).setPost_user_num(cservice.getDataByGuestNum(list.get(i).getGuest_num()).getWrite_num());

			// 대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today = new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday = new Date();
			try {
				writeday = sdf.parse(list.get(i).getComment_writeday().toString());
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
			list.get(i).setPerTime(preTime);
		}


		return list;

	}

	//방명록 수정
	@PostMapping("user/commentupdate")
	@ResponseBody
	public void commentupdate(@ModelAttribute CommentDto dto,HttpSession session) {

		dto.setUser_num((String)session.getAttribute("user_num"));
		cservice.update(dto);

	}

	//방명록 삭제
	@GetMapping("user/cdelete")
	@ResponseBody
	public void cdelete(String comment_num) {

		int level=cservice.getData(comment_num).getComment_level();

		if(level == 0)
			cservice.deleteGroup(cservice.getData(comment_num).getComment_group());
		else {
			CommentDto dto=cservice.getData(comment_num);
			int comment_group=dto.getComment_group();
			int comment_setp=dto.getComment_step();

			List<CommentDto> list=cservice.getDataGroupStep(comment_group, comment_setp);

			for(int i=0; i<list.size();i++) {

				int nextlevel=list.get(i).getComment_level();
				if(nextlevel>level)
					cservice.delete(list.get(i).getComment_num());
				else
					break;
			}
			cservice.delete(comment_num);
		}

	}
	
	@GetMapping("user/postcommentcount")
	   @ResponseBody
	   public int commentcount(String post_num) {
	      
	      int count=cservice.getTotalCount(post_num);
	      
	      return count;
	   }
	
	   @GetMapping("user/guestcommentcount")
	   @ResponseBody
	   public int commentguestcount(String guest_num) {
	      
	      int count=cservice.getTotalGuestCount(guest_num);
	      
	      return count;
	   }	

	//정보 페이지 이동
	@GetMapping("/user/info")
	public String info() {
		return "/sub/user/info";
	}

	//친구 목록 이동
	@GetMapping("/user/friend")
	public String friend() {
		return "/sub/user/friend";
	}

	//회원 탈퇴
	@GetMapping("/user/userdelete")
	public String userdelete(String user_num, HttpSession session) {
		//유저 프로필 이미지, 커버 삭제
		UserDto user = uservice.getUserByNum(user_num);
		String profile_path = session.getServletContext().getRealPath("/photo");
		String cover_path = session.getServletContext().getRealPath("/cover");
		//System.out.println(profile_path);
		//System.out.println(cover_path);

		String user_photo = "";
		String user_cover = "";
		if(user.getUser_photo() != null) {
			user_photo = user.getUser_photo();
			File file = new File(profile_path+"\\"+user_photo);
			file.delete();
		}
		if(user.getUser_cover() != null) {
			user_cover = user.getUser_cover();
            File file = new File(cover_path+"\\"+user_cover);
			file.delete();
		}

		//session.removeAttribute("loginok");
		session.invalidate(); // 세션의 모든 속성을 삭제
		uservice.userDelete(user_num);
		return "redirect:/";
	}

	//비밀번호 수정창으로 이동
	@GetMapping("/user/moveupdatepassword")
	public String moveupdatepassword() {
		return "/login/updatePassword";
	}

	@PostMapping("/user/updatePassword")
	public String updatepassword(String user_pass, String user_num) {
		String encodedPassword = passwordEncoder.encode(user_pass);//비밀번호 암호화.
		UserDto dto = uservice.getUserByNum(user_num);
		dto.setUser_pass(encodedPassword);
		uservice.updateUserPass(dto);
		return "redirect:/";
	}
}
