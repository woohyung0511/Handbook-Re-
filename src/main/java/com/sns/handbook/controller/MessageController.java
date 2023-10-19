package com.sns.handbook.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;
import javax.xml.crypto.Data;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sns.handbook.dto.MessageDto;
import com.sns.handbook.dto.UserDto;
import com.sns.handbook.serivce.MessageService;
import com.sns.handbook.serivce.MessagealarmService;
import com.sns.handbook.serivce.UserService;

@Controller
public class MessageController {
	
	@Autowired
	MessageService mservice;
	
	@Autowired
	UserService uservice;
	
	@Autowired
	MessagealarmService maservice;

	@GetMapping("/message/main")
	public ModelAndView meesageMain(HttpSession session,
			@RequestParam(defaultValue = "0") int selgroup,
			@RequestParam(required = false) String search_name,
			@RequestParam(required = false) String search_num)
	{
		ModelAndView model=new ModelAndView();
		
		if(search_name!=null) {
			model.addObject("search_name",search_name);
			model.addObject("search_num",search_num);
		}
		
		//사용자의 num 받기
		String myid=(String)session.getAttribute("myid");
		String user_num=uservice.getUserById(myid).getUser_num();
		
		//로그인한 사용자가 가장 최근한 대화한 채팅방
		int recentGroup=0;
		UserDto otherInfo=new UserDto();
		
		//선택된 그룹이 없으면 최근 그룹 정보를 넘긴다.
		if(selgroup==0) {
			//로그인한 사용자가 가장 최근한 대화한 채팅방
			try {
				recentGroup=mservice.getRecentGroup(user_num);
			}catch (Exception e) {
				// TODO: handle exception
			}
			
			//가장 최근 대화한 상대 정보 전달
			List<Map<String, Object>> chatMember=null;
			try{
				chatMember=mservice.selectAllChatMemeber(user_num,null);
			}catch (Exception e) {
				// TODO: handle exception
			}
			
			//최근 상대방의 userDto
			try {
				otherInfo=uservice.getUserByNum(chatMember.get(0).get("member_num").toString());
			}catch (Exception e) {
				// TODO: handle exception
			}
		}else {
			//넘어온 그룹이 있으면 그 그룹에 대한 정보를 넘긴다.
			recentGroup=selgroup;
			
			List<Map<String, Object>> chatMember=null;
			try{
				chatMember=mservice.selectAllChatMemeber(user_num,null);
			}catch (Exception e) {
				// TODO: handle exception
			}
			
			//해당 그룹의 상대의 유저dto
			try {
				String other_num=maservice.getMessAlarm(selgroup).getSender_num();
				otherInfo=uservice.getUserByNum(other_num);
			}catch (Exception e) {
				// TODO: handle exception
			}
		}
		
		//저장
		model.addObject("recentgroup",recentGroup);
		model.addObject("otherinfo",otherInfo);
		model.addObject("user_num",user_num);
		
		model.setViewName("/sub/message/messagemain");
		
		return model;
	}
	
	@GetMapping("/message/chatting")
	@ResponseBody
	public List<MessageDto> chatting(int mess_group,HttpSession session)
	{
		try {
			Thread.sleep(100); //0.1초 기다리기
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//사용자의 num 받기
		String myid=(String)session.getAttribute("myid");
		String user_num=uservice.getUserById(myid).getUser_num();
				
		List<MessageDto> chat=new ArrayList<>();
		
		chat=mservice.selectAllByGroup(mess_group, user_num);
		Collections.reverse(chat); //역정렬
		
		//채팅 시간 
		//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
		for(MessageDto dto:chat) {
			Date today=new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday=new Date();
			try {
				writeday=sdf.parse(dto.getMess_writeday().toString());
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
						preTime="방금전";
					}
				}
			}
	
			dto.setMess_time(preTime);; //시간 다시 넣어주기
		}
		////////////
		
		//띄운 채팅이 알림에 있던 거라면 알림테이블에서 삭제(봤으니까)
		//해당 그룹의 알림이 존재하는지 확인!
		if(maservice.getMessAlarmCount(mess_group)!=0) {
			//존재한다면 로그인한 사람이 receiver인지 확인(sneder가 봤을 때 사라지는 거 방지)
			if(maservice.getMessAlarm(mess_group).getReceiver_num().equals(user_num)) {
				maservice.delteMessAlarm(mess_group);
			}
		}
		
		return chat;
	}
	
	@GetMapping("/message/memberlist")
	@ResponseBody
	public List<Map<String, Object>> memberlist(HttpSession session,
			@RequestParam(required = false) String other_name)
	{	
		try {
			Thread.sleep(100); //0.1초 기다리기
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//사용자의 num 받기
		String myid=(String)session.getAttribute("myid");
		String user_num=uservice.getUserById(myid).getUser_num();

		//대화 상대와 메시지 그룹 받아오기
		List<Map<String, Object>> chatMember=mservice.selectAllChatMemeber(user_num,other_name);

		//상대측 아이디,이름,유저사진(프사) 추가하기
		for(Map<String, Object> map:chatMember)
		{
			String contnet=map.get("content").toString();
			
			if(contnet.contains("http")) {
				map.put("content", "링크를 보냈습니다.");
			}
			else if(contnet.contains("<img") && contnet.contains("src=") && contnet.contains("/messagephoto/")) {
				map.put("content", "사진을 보냈습니다.");
			}
			
			UserDto udto=uservice.getUserByNum(map.get("member_num").toString()); //상대방의 userDto

			map.put("member_id", udto.getUser_id());
			map.put("member_name", udto.getUser_name());
			map.put("member_photo", udto.getUser_photo());

			//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today=new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday=new Date();
			try {
				writeday=sdf.parse(map.get("writeday").toString());
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

			map.put("writeday", preTime); //시간 다시 넣어주기
		}

		return chatMember;	
	}
	
	@GetMapping("/message/delete")
	@ResponseBody
	public void messageDel(String mess_num)
	{
		mservice.deleteMessage(mess_num);
	}
	
	@GetMapping("/message/searchuser")
	@ResponseBody
	public List<UserDto> searchUser(String user_name,HttpSession session)
	{
		List<UserDto> list=uservice.getUserByName(user_name);
		
		String myNum=(String)session.getAttribute("user_num");
		
		for(int i=0;i<list.size();i++) {
			if(list.get(i).getUser_num().equals(myNum)) {
				//내 이름 제거
				list.remove(i);
			}
		}
		
		return list;
	}
	
	@GetMapping("/message/newgroup")
	@ResponseBody
	public Map<String, Integer> newGroup(@RequestParam String other,HttpSession session)
	{
		Map<String, Integer> map=new HashMap<>();
		
		//내 num
		String user_num=(String)session.getAttribute("user_num");
		
		//상대와 나의 메시지가 이미 있는지 확인
		int msgCount=mservice.getCountOfMessage(user_num, other);
		
		//메시지가 존재한다면 기존의 그룹을 받아옴
		if(msgCount!=0) {
			MessageDto mdto=mservice.selectRecentMessage(user_num, other);
			map.put("group", mdto.getMess_group());
		}else {
			map.put("group", mservice.selectMaxNum()+1);
		}
		
		return map;
	}
	
	@PostMapping("/message/fileupload")
	@ResponseBody
	public Map<String,String> fileuUpload(@RequestParam MultipartFile upload,HttpSession session)
	{
		Map<String, String> map=new HashMap<>();
		
		//저장경로
		String path=session.getServletContext().getRealPath("/messagephoto");
		//파일 이름
		String fileName=upload.getOriginalFilename();
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddhhmmss");
		
		String uploadName="msg_"+sdf.format(new Date())+fileName; //저장할 파일명
		
		//저장
		try {
			upload.transferTo(new File(path+"\\"+uploadName));
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		map.put("upload", uploadName);
		
		return map;
	}
	
	@GetMapping("/message/deletegroup")
	@ResponseBody
	public void deleteGroup(int mess_group) {
		mservice.deleteMessageGroup(mess_group);
	}
 	
}
