package com.sns.handbook.controller;

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
	
	@PostMapping("/user/coverupdate")
	@ResponseBody
	public void coverupdate(String user_num, MultipartFile cover, HttpSession session, @ModelAttribute UserDto dto) {
		//업데이트를 처리하는 메서드 호출
		handleFileUpdate(user_num, cover, session);
	}
	
	@PostMapping("/user/photoupdate")
	@ResponseBody
	public void photoupdate(String user_num, MultipartFile photo, HttpSession session, @ModelAttribute UserDto dto) {
		//업데이트를 처리하는 메서드 호출
		handleFileUpdate(user_num, photo, session);
	}
	
	private void handleFileUpdate(String user_num, MultipartFile file, HttpSession session) {
		//업데이트 대상 필드 (프로필사진 또는 커버사진) 확인
		String fieldName = (file.getName().equals("photo")) ? "photo" : "cover";
		//파일 업로드 경로 설정
		String uploadPath = session.getServletContext().getRealPath("/" + fieldName);
		
		//파일 이름 생성
		String fileName = "f_" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + file.getOriginalFilename();

		try {
			//파일을 업로드 경로로 복사
			file.transferTo(new File(uploadPath + "\\" + fileName));
			//DB수정
			if (fieldName.equals("photo")) {
				//프로필 사진 업데이트
				uservice.updatePhoto(user_num, fileName);
			}else {
				//커버 사진 업데이트
				uservice.updateCover(user_num, fileName);
			}
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
	}
	
	//마이페이지 이동
	@GetMapping("/user/mypage")
	public String mypage(@RequestParam(defaultValue = "0") int offset, @RequestParam(defaultValue = "0") int commentoffset, String user_num,
			@RequestParam(required = false) String post_num,
			@RequestParam(required = false) String guest_num,
			@RequestParam(required = false) String comment_num,
			HttpSession session, Model model) {
		
		//팔로워 및 팔로잉 수 가져오기
		int followercount = fservice.getTotalFollower(user_num);
		int followcount = fservice.getTotalFollowing(user_num);
		
		//로그인한 사용자의 정보 가져오기
		String loginnum = uservice.getUserById((String) session.getAttribute("myid")).getUser_num();
		
		//선택한 사용자의 정보 가져오기
		UserDto udto = uservice.getUserByNum(user_num);
		
		//게시물 및 방명록 목록 가져오기
		List<GuestbookDto> guestlist = uservice.selectGuestbookByAccess((String) session.getAttribute("user_num"),user_num);
		List<PostDto> postlist = uservice.selectPostsByAccess(user_num, (String) session.getAttribute("user_num"));
		
		//게시물 및 방명록 목록을 하나의 리스트로 통합
		List<Map<String, Object>> alllist = new ArrayList<>();
		
		//게시물을 리스트에 추가 (최신 순)
		postlist.forEach(p -> alllist.add(0,createMapFromPost(p, session)));
		
		//방명록을 리스트에 추가 (최신 순)
		guestlist.forEach(g -> alllist.add(0,createMapFromGuestbook(g, session)));
		
		//게시물과 방명록의 작성일시를 계산하고 형식화
		alllist.forEach(this::addRelativeTime);
		
		//팔로잉 목록 가져오기
		List<FollowingDto> tflist = uservice.getFollowList(user_num, offset);
		
		tflist.forEach(tf -> {
			UserDto dto =uservice.getUserByNum(tf.getTo_user());
			tf.setUser_name(dto.getUser_name());
			tf.setUser_photo(dto.getUser_photo());
			tf.setUser_num(dto.getUser_num());
			tf.setTf_count(fservice.togetherFollow(dto.getUser_num(), (String) session.getAttribute("user_num")));
		});
		
		//모델에 필요한 데이터 추가
		model.addAttribute("alllist", alllist);
		model.addAttribute("loginnum", loginnum);
		model.addAttribute("dto", udto);
		model.addAttribute("offset", offset);
		model.addAttribute("commentoffset", commentoffset);
		model.addAttribute("tflist", tflist);
		model.addAttribute("postlist", postlist);
		model.addAttribute("followercount", followercount);
		model.addAttribute("followcount", followcount);
		model.addAttribute("checkfollowing", fservice.checkFollowing((String) session.getAttribute("user_num"), user_num));
		model.addAttribute("checkfollower", fservice.checkFollower((String) session.getAttribute("user_num"), user_num));
		model.addAttribute("tf_count", fservice.getTotalFollowing(uservice.getUserByNum(user_num).getUser_num()));
		model.addAttribute("post_num", post_num);
		
		//게스트글
		if (guest_num != null) {
			GuestbookDto guestdto = uservice.getDataByGuestNum(guest_num);
			model.addAttribute("guest_num", guest_num);
			user_num = guestdto.getOwner_num();
		}
		
		//댓글
		if (comment_num != null) {
			CommentDto commentdto = cservice.getData(comment_num);
			model.addAttribute("post_num", commentdto.getPost_num());
			model.addAttribute("guest_num", commentdto.getGuest_num());
			
			if (commentdto.getPost_num() == null) {
				user_num = uservice.getDataByGuestNum(commentdto.getGuest_num()).getOwner_num();
			}
		}
		
		return "/sub/user/mypage";
	}
	
	@GetMapping("user/getmypostdata")
	@ResponseBody
	public List<Map<String, Object>> mypostdata(
	    @RequestParam(defaultValue = "0") String post_num,
	    @RequestParam(defaultValue = "0") String guest_num,
	    HttpSession session) {
	    
	    List<Map<String, Object>> alllist = new ArrayList<>();
	    boolean isGuest = !guest_num.equals("0");
	    
	    if (isGuest) {
	    	//게스트북 데이터 가져오기
	        GuestbookDto gdto = uservice.getDataByGuestNum(guest_num);
	        List<GuestbookDto> guestlist = new ArrayList<>();
	        guestlist.add(gdto);
	        
	        //게스트북 데이터 처리
	        processGuestbookList(guestlist, alllist, session);
	    } else {
	    	//포스트 데이터 가져오기
	        PostDto pdto = pservice.getDataByNum(post_num);
	        List<PostDto> postlist = new ArrayList<>();
	        postlist.add(pdto);
	        
	        //포스트 데이터 처리
	        processPostList(postlist, alllist, session);
	    }

	    return alllist;
	}

	private void processGuestbookList(
	    List<GuestbookDto> guestlist,
	    List<Map<String, Object>> alllist,
	    HttpSession session) {
	    
	    for (GuestbookDto g : guestlist) {
	        g.setComment_count(cservice.getTotalGuestCount(g.getGuest_num()));
	        g.setUser_name(uservice.getUserByNum(g.getWrite_num()).getUser_name());
	        
	        //게스트 데이터를 맵으로 변환
	        Map<String, Object> map = createMapFromGuestbook(g, session);
	        alllist.add(map);
	    }
	}

	private void processPostList(
	    List<PostDto> postlist,
	    List<Map<String, Object>> alllist,
	    HttpSession session) {
	    
	    for (PostDto p : postlist) {
	        p.setComment_count(cservice.getTotalCount(p.getPost_num()));
	        p.setUser_name(uservice.getUserByNum(p.getUser_num()).getUser_name());
	        
	        //포스트 데이터를 맵으로 변환
	        Map<String, Object> map = createMapFromPost(p, session);
	        alllist.add(map);
	    }
	}

	private Map<String, Object> createMapFromGuestbook(
	    GuestbookDto guestbook,
	    HttpSession session) {
	    
		//게스트북 정보 맵에 추가
	    Map<String, Object> map = new HashMap<>();
	    map.put("post_num", guestbook.getGuest_num());
	    map.put("user_num", guestbook.getWrite_num());
	    map.put("owner_num", guestbook.getOwner_num());
	    map.put("post_content", guestbook.getGuest_content());
	    map.put("post_file", guestbook.getGuest_file());
	    map.put("post_access", guestbook.getGuest_access());
	    map.put("post_writeday", guestbook.getGuest_writeday());
	    map.put("like_count", glservice.getTotalGuestLike(guestbook.getGuest_num()));
	    map.put("likecheck", glservice.checkGuestLike((String) session.getAttribute("user_num"), guestbook.getGuest_num()));
	    map.put("comment_count", guestbook.getComment_count());
	    map.put("type", "guest");
	    map.put("user_name", guestbook.getUser_name());
	    
	    //게스트북 작성자 정보 가져오기
	    UserDto dto = uservice.getUserByNum(guestbook.getWrite_num());
	    map.put("dto", dto);
	    
	    //게시물 작성 시간 계산 및 추가
	    addRelativeTime(map);
	    
	    return map;
	}

	private Map<String, Object> createMapFromPost(
	    PostDto post,
	    HttpSession session) {
	    
		//포스트 정보 맵에 추가
	    Map<String, Object> map = new HashMap<>();
	    map.put("post_num", post.getPost_num());
	    map.put("user_num", post.getUser_num());
	    map.put("owner_num", null);
	    map.put("post_content", post.getPost_content());
	    map.put("post_file", post.getPost_file());
	    map.put("post_access", post.getPost_access());
	    map.put("post_writeday", post.getPost_writeday());
	    map.put("like_count", plservice.getTotalLike(post.getPost_num()));
	    map.put("likecheck", plservice.checklike((String) session.getAttribute("user_num"), post.getPost_num()));
	    map.put("comment_count", post.getComment_count());
	    map.put("type", "post");
	    map.put("user_name", post.getUser_name());
	    
	    //포스트 작성자 정보 가져오기
	    UserDto dto = uservice.getUserByNum(post.getUser_num());
	    map.put("dto", dto);
	    
	    //게시물 작성 시간 계산 및 추가
	    addRelativeTime(map);
	    
	    return map;
	}

	//글 작성 시간
	private void addRelativeTime(Map<String, Object> map) {
	    Date today = new Date();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
	    Date writeday = null;
	    
	    try {
	        writeday = sdf.parse(map.get("post_writeday").toString());
	    } catch (ParseException e) {
	        e.printStackTrace();
	    }
	    
	    long diffSec = (today.getTime() - writeday.getTime());
	    diffSec -= 32400000L;
	    
	    long day = (diffSec / (60 * 60 * 24 * 1000L)) % 365;
	    long hour = (diffSec / (60 * 60 * 1000L)) % 24;
	    long minute = (diffSec / (60 * 1000L)) % 60;
	    long second = (diffSec / 1000L) % 60;
	    
	    String preTime = "";
	    if (day != 0) {
	        preTime = "" + day + "일 전";
	    } else if (hour != 0) {
	        preTime = "" + hour + "시간 전";
	    } else if (minute != 0) {
	        preTime = "" + minute + "분 전";
	    } else {
	        preTime = "" + second + "초 전";
	    }
	    
	    map.put("post_time", preTime);
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

	//게시글 수정
	@ResponseBody
	@PostMapping("/user/updatepost")
	public void updatepost(@ModelAttribute PostDto dto, HttpSession session, @RequestParam(required = false) List<MultipartFile> photos) {
	    try {
	        if (photos != null && !photos.isEmpty()) {
	            List<String> uploadedFileNames = new ArrayList<>();

	            for (MultipartFile photo : photos) {
	                String originalFileName = photo.getOriginalFilename();
	                String fileName = generateUniqueFileName(originalFileName);
	                String uploadPath = session.getServletContext().getRealPath("/post_file") + File.separator + fileName;
	                photo.transferTo(new File(uploadPath));
	                uploadedFileNames.add(fileName);
	            }

	            if (!uploadedFileNames.isEmpty()) {
	                dto.setPost_file(String.join(",", uploadedFileNames));
	                pservice.updatePhoto(dto.getPost_num(), dto.getPost_file());
	            }
	        }

	        pservice.updatePost(dto);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	private String generateUniqueFileName(String originalFileName) {
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
	    String fileName = sdf.format(new Date()) + "_" + originalFileName;
	    return fileName;
	}



	//게시글 삭제
	@ResponseBody
	@GetMapping("/user/deletepost")
	public void deletepost(String post_num, HttpSession session) {
	    PostDto post = pservice.getDataByNum(post_num);
	    String postFile = post.getPost_file();

	    if (!"no".equals(postFile)) {
	        deleteFile(session, postFile);
	    }

	    pservice.deletePost(post_num);
	}

	//사진,동영상 삭제
	private void deleteFile(HttpSession session, String fileName) {
	    String path = session.getServletContext().getRealPath("/post_file");
	    File file = new File(path, fileName);

	    if (file.exists()) {
	        if (file.delete()) {
	            System.out.println("Deleted file: " + fileName);
	        } else {
	            System.err.println("Failed to delete file: " + fileName);
	        }
	    } else {
	        System.err.println("File not found: " + fileName);

	    }
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
	public void updateguestbook(@ModelAttribute GuestbookDto dto, HttpSession session, @RequestParam(required = false) List<MultipartFile> photo) {
	    String targetPath = session.getServletContext().getRealPath("/guest_file");
	    String uploadedFiles = uploadFiles(photo, targetPath);

	    if (uploadedFiles.isEmpty()) {
	        // 파일이 업로드되지 않았을 경우 이전 파일 정보 유지
	        String prevFile = uservice.getDataByGuestNum(dto.getGuest_num()).getGuest_file();
	        dto.setGuest_file(prevFile);
	    } else {
	        dto.setGuest_file(uploadedFiles);
	    }

	    uservice.updateGuestBook(dto);
	}
	
	//방명록 사진 수정
	private String uploadFiles(List<MultipartFile> files, String targetPath) {
	    int idx = 1;
	    String uploadedFiles = "";

	    if (files != null) {
	        for (MultipartFile file : files) {
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
	            String fileName = idx++ + "_" + sdf.format(new Date()) + "_" + file.getOriginalFilename();
	            uploadedFiles += fileName + ",";

	            try {
	                file.transferTo(new File(targetPath + File.separator + fileName));
	            } catch (IllegalStateException | IOException e) {
	                e.printStackTrace();
	            }
	        }

	        // 콤마 제거
	        if (!uploadedFiles.isEmpty()) {
	            uploadedFiles = uploadedFiles.substring(0, uploadedFiles.length() - 1);
	        }
	    }

	    return uploadedFiles;
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

	//댓글 불러오기
	@GetMapping("user/scrollcomment")
	@ResponseBody
	public List<CommentDto> scroll(String post_num, int commentoffset, HttpSession session) {
	    List<CommentDto> list = cservice.selectScroll(post_num, commentoffset);

	    for (CommentDto comment : list) {
	        populateCommentData(comment, session);
	    }

	    return list;
	}

	//방명록 댓글 불러오기
	@GetMapping("user/scrollguestcomment")
	@ResponseBody
	public List<CommentDto> guestScroll(String guest_num, int commentoffset, HttpSession session) {
	    List<CommentDto> list = cservice.selectGuestScroll(guest_num, commentoffset);

	    for (CommentDto comment : list) {
	        populateCommentData(comment, session);
	    }

	    return list;
	}

	private void populateCommentData(CommentDto comment, HttpSession session) {
	    UserDto udto = uservice.getUserByNum(comment.getUser_num());
	    comment.setUser_name(udto.getUser_name());
	    comment.setUser_photo(udto.getUser_photo());
	    comment.setLike_count(cservice.getTotalLikes(comment.getComment_num()));
	    comment.setLike_check(cservice.getLikeCheck((String) session.getAttribute("user_num"), comment.getComment_num()));
	    comment.setPost_user_num(String.valueOf(getPostUserNum(comment)));
	    calculateRelativeTime(comment);
	}

	private int getPostUserNum(CommentDto comment) {
	    if (comment.getPost_num() != null) {
	        PostDto post = pservice.getDataByNum(comment.getPost_num());
	        return Integer.valueOf(post.getUser_num());
	    } else if (comment.getGuest_num() != null) {
	        GuestbookDto guestbook = cservice.getDataByGuestNum(comment.getGuest_num());
	        return Integer.valueOf(guestbook.getWrite_num());
	    }
	    return 0;
	}

	private void calculateRelativeTime(CommentDto comment) {
	    Date today = new Date();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));

	    Date writeday = null;
	    try {
	        writeday = sdf.parse(comment.getComment_writeday().toString());
	    } catch (ParseException e) {
	        e.printStackTrace();
	    }

	    long diffSec = (today.getTime() - writeday.getTime());
	    diffSec -= 32400000L;

	    long day = (diffSec / (60 * 60 * 24 * 1000L)) % 365;
	    long hour = (diffSec / (60 * 60 * 1000L)) % 24;
	    long minute = (diffSec / (60 * 1000L)) % 60;
	    long second = (diffSec / 1000L) % 60;

	    String preTime = "";
	    if (day != 0) {
	        preTime = day + "일 전";
	    } else if (hour != 0) {
	        preTime = hour + "시간 전";
	    } else if (minute != 0) {
	        preTime = minute + "분 전";
	    } else {
	        preTime = second + "초 전";
	    }
	    comment.setPerTime(preTime);
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
	    CommentDto dto = cservice.getData(comment_num);
	    int level = dto.getComment_level();
	    int comment_group = dto.getComment_group();
	    int comment_step = dto.getComment_step();

	    if (level == 0) {
	        // 댓글 그룹 전체를 삭제합니다.
	        cservice.deleteGroup(comment_group);
	    } else {
	        List<CommentDto> list = cservice.getDataGroupStep(comment_group, comment_step);

	        for (CommentDto comment : list) {
	            int nextLevel = comment.getComment_level();
	            if (nextLevel > level) {
	                cservice.delete(comment.getComment_num());
	            } else {
	                break;
	            }
	        }
	    }
	    // 마지막으로 선택한 댓글을 삭제합니다.
	    cservice.delete(comment_num);
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
