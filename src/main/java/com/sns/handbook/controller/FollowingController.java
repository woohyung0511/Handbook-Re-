package com.sns.handbook.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sns.handbook.dto.FollowingDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.BookmarkService;
import com.sns.handbook.serivce.FollowingService;
import com.sns.handbook.serivce.UserService;

@Controller
@RequestMapping("following")
public class FollowingController {

	@Autowired
	FollowingService service;
	
	@Autowired
	UserService uservice;
	
	@Autowired
	BookmarkService bservice;
	
	
	@GetMapping("/test")
	public String test(Model model) {
		
		model.addAttribute("totalCount", service.getTotalFollowing("1"));
		model.addAttribute("totalCount2", service.getTotalFollowing("2"));
		
		return "/sub/follow/following";
	}
	
	@GetMapping("insertfollowing")
	@ResponseBody
	public void insertFollowing(@ModelAttribute FollowingDto dto) {
		
		service.insertFollowing(dto);
	}
	
	@GetMapping("followcheck")
	@ResponseBody
	public Map<String, Integer> fingCheck(String from_user,String to_user){
		
		Map<String, Integer> map=new HashMap<>();
		
		
		map.put("fingcheck", service.checkFollowing(from_user, to_user));
		map.put("fwercheck", service.checkFollower(from_user, to_user));
		
		return map;
	}
	
	@GetMapping("deletefollowing")
	@ResponseBody
	public void deleteFollowing(String to_user, HttpSession session) {
		
		service.deleteFollowing((String)session.getAttribute("user_num"),to_user);
		
		int bookMarkCheck=bservice.bookmarkCheck((String)session.getAttribute("user_num"), to_user);
		
		if(bookMarkCheck == 1)
			bservice.deleteBookmark((String)session.getAttribute("user_num"), to_user);
	}
	
	@GetMapping("followlist")
	public ModelAndView followList(@RequestParam(defaultValue = "0") int offset, String from_user, HttpSession session) {
		
		
		ModelAndView model = new ModelAndView();

		
		List<FollowingDto> list = service.getFollowList(from_user, offset); 
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getTo_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));
			list.get(i).setBookmarkcheck(bservice.bookmarkCheck((String)session.getAttribute("user_num"),list.get(i).getTo_user()));

		}
		
		model.addObject("list", list);
		model.addObject("offset", offset);
		model.addObject("from_user",from_user);
		model.setViewName("/sub/follow/followlist");

		
		return model;
		
	}
	
	@GetMapping("followerlist")
	public ModelAndView followerList(@RequestParam(defaultValue = "0") int offset, HttpSession session, String to_user) {
		
		
		ModelAndView model = new ModelAndView();
		
		List<FollowingDto> list = service.getFollowingList(to_user, offset); 
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getFrom_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));
			list.get(i).setBookmarkcheck(bservice.bookmarkCheck((String)session.getAttribute("user_num"),list.get(i).getTo_user()));
		}
		
		model.addObject("list", list);
		model.addObject("offset", offset);
		model.addObject("to_user",to_user);
		model.setViewName("/sub/follow/followerlist");

		
		return model;
		
	}
	
	@GetMapping("followlistscroll")
	@ResponseBody
	public List<FollowingDto> followlistscroll(int offset,String from_user,HttpSession session){
		
		List<FollowingDto> list=service.getFollowList(from_user, offset);
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getTo_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));

		}
		
		return list;
	}
	
	@GetMapping("followerlistscroll")
	@ResponseBody
	public List<FollowingDto> followerlistscroll(int offset,HttpSession session,String to_user){
		
		List<FollowingDto> list=service.getFollowingList(to_user, offset);
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getFrom_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));

		}
		
		return list;
	}
	
	
	//친구 목록에서 친구 검색
	@GetMapping("followsearch")
	public ModelAndView followsearch(@RequestParam(required = false) String from_user,
											@RequestParam(required = false) String searchword,
											@RequestParam(defaultValue = "0") int offset,HttpSession session)
	{
		
		List<FollowingDto> list = service.followSearch(from_user, searchword, offset);
		
		ModelAndView model = new ModelAndView();
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getTo_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));

		}
		
		model.addObject("list", list);
		model.addObject("offset", offset);
		model.addObject("from_user",from_user);
		model.setViewName("/sub/follow/followlist");
		
		return model;
		
	}
	
	//팔로워 목록에서 친구 검색
	@GetMapping("followersearch")
	public ModelAndView followersearch(@RequestParam(required = false) String searchword,
			@RequestParam(defaultValue = "0") int offset,HttpSession session, String to_user)
	{
		List<FollowingDto> list = service.followerSearch(to_user, searchword, offset);

		ModelAndView model = new ModelAndView();

		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getFrom_user()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setUser_name(dto.getUser_name());// 위에서 dto에서 name photo를 뽑아내서 리스트에 set을 해줌
			list.get(i).setUser_photo(dto.getUser_photo());
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));

		}

		model.addObject("list", list);
		model.addObject("offset", offset);
		model.addObject("to_user",to_user);
		model.setViewName("/sub/follow/followerlist");

		return model;

	}
	
	
	@GetMapping("recommendlist")
	public ModelAndView recommendlist(String from_user, HttpSession session,@RequestParam(required = false)String searchword,
	@RequestParam(defaultValue = "0") int offset)
	{
		List<UserDto> list = service.followRecommend(from_user,searchword,offset); //내가 팔로워 하지 않는 사람들 중에서 내 팔로워들이 그 사람을 팔로워를 많이 한 순서대로 리스트 뽑는다
		
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getUser_num()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));
		}			
		
		ModelAndView model = new ModelAndView();
		model.addObject("searchword", searchword);
		model.addObject("offset", offset);
		model.addObject("list",list);
		model.setViewName("/sub/follow/recommendlist");
	
		
		return model;
	}
	
	
	@GetMapping("recommendlistscroll")
	@ResponseBody
	public List<UserDto> recommemdlistscroll(String from_user,HttpSession session, @RequestParam(required = false)String searchword, 
			@RequestParam(defaultValue = "0") int offset){
		
List<UserDto> list = service.followRecommend(from_user,searchword,offset); //내가 팔로워 하지 않는 사람들 중에서 내 팔로워들이 그 사람을 팔로워를 많이 한 순서대로 리스트 뽑는다
		
		
		for(int i = 0; i<list.size(); i++) {
			UserDto dto = uservice.getUserByNum(list.get(i).getUser_num()); //여러가지 수많은 데이터에서 i번째 데이터만 가져오기, 여기서 필요한 상대방 num을 list에서 뽑아옴
			list.get(i).setTf_count(service.togetherFollow(dto.getUser_num(),(String)session.getAttribute("user_num")));
		}			
		
		return list;
	}
	
}
