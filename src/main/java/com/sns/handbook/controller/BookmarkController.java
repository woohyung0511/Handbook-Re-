package com.sns.handbook.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sns.handbook.dto.BookmarkDto;
import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.BookmarkService;
import com.sns.handbook.serivce.CommentService;
import com.sns.handbook.serivce.FollowingService;
import com.sns.handbook.serivce.PostService;
import com.sns.handbook.serivce.PostlikeService;
import com.sns.handbook.serivce.UserService;

@Controller
public class BookmarkController {
	
	@Autowired
	BookmarkService bservice;
	
	@Autowired
	PostService pservice;
	
	@Autowired
	PostlikeService plservice;
	
	@Autowired
	UserService uservice;
	
	@Autowired
	CommentService cservice;
	
	@Autowired
	FollowingService fservice;

	@GetMapping("following/insertbookmark")
	@ResponseBody
	public void insertBookmark(@ModelAttribute BookmarkDto dto) {

		bservice.insertBookmark(dto);
	}
	
	@GetMapping("following/deletebookmark")
	@ResponseBody
	public void deleteBookmark(String owner_num, String bfriend_num){
		bservice.deleteBookmark(owner_num, bfriend_num);
	}
	
	@GetMapping("/post/bookmarktimeline")
	public ModelAndView list(@RequestParam(defaultValue = "0") int offset,@RequestParam(defaultValue = "0") int commentoffset, HttpSession session,
			FollowingDto fdto) {

		List<PostDto> list = bservice.bookmarkPost((String)session.getAttribute("user_num"), offset);
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
		model.addObject("total", totalCount);
		model.addObject("list", list);
		model.addObject("ftlist", ftlist);
		model.addObject("login_name", login_name);

		model.setViewName("/bookmark/bookmarklist");
		return model;
	}
	
	
	@GetMapping("/post/bookscroll")
	@ResponseBody
	public List<PostDto> scroll(int offset, @RequestParam(required = false) String searchcolumn,
			@RequestParam(required = false) String searchword, HttpSession session,
			String user_num) {

		List<PostDto> list = bservice.bookmarkPost((String)session.getAttribute("user_num"), offset);
		
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
	
}
