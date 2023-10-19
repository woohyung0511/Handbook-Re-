package com.sns.handbook.controller;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sns.handbook.dto.ClikealarmDto;
import com.sns.handbook.dto.CommentalarmDto;
import com.sns.handbook.dto.FollowalarmDto;
import com.sns.handbook.dto.MessageDto;
import com.sns.handbook.dto.MessagealarmDto;
import com.sns.handbook.dto.PlikealarmDto;
import com.sns.handbook.dto.PostalarmDto;
import com.sns.handbook.serivce.ClikealarmService;
import com.sns.handbook.serivce.CommentService;
import com.sns.handbook.serivce.CommentalarmService;
import com.sns.handbook.serivce.FollowalarmService;
import com.sns.handbook.serivce.MessageService;
import com.sns.handbook.serivce.MessagealarmService;
import com.sns.handbook.serivce.PlikealarmService;
import com.sns.handbook.serivce.PostalarmService;
import com.sns.handbook.serivce.UserService;

@RestController
public class MessagealarmController{

	@Autowired
	UserService uservice;
	
	@Autowired
	MessageService mservice;
	
	@Autowired
	MessagealarmService maserive;
	
	@Autowired
	PostalarmService paservice;
	
	@Autowired
	CommentService cservice;
	
	@Autowired
	FollowalarmService faservice;
	
	@Autowired
	CommentalarmService caservice;
	
	@Autowired
	PlikealarmService plaservice;
	
	@Autowired
	ClikealarmService claservice;
	
	//알림전송
	@GetMapping("/messagealaramadd")
	public void messagealaramAdd(HttpSession session, String other,
			int group)
	{
		//현재 사용자의 user_num
		String user_num=(String)session.getAttribute("user_num");
		
		//상대와의 메시지 알림이 있는지 확인
		int msgAlarmCount=maserive.getMessAlarmCount(group);
		
		//알림이 존재하면 알림 +1
		if(msgAlarmCount!=0) {
			maserive.updateMessAlarmChkcount(group);
		}else {
			//알림이 존재하지 않으면 insert
			maserive.insertMessAlarm(other, user_num, group, 1); //처음이니까 chkcount는 1
		}
	}
	
	//댓글 알림 전송
	@GetMapping("/postalarmadd")
	public void postalarmAdd(HttpSession session, Map<String, String> map) {
		//현재 사용자의 user_num
		String user_num=(String)session.getAttribute("user_num");
		
		PostalarmDto dto=new PostalarmDto();
		
		dto.setReceiver_num(user_num);
		dto.setPost_num(map.get("post_num"));
		dto.setSender_num(map.get("sender_num"));
		dto.setComment_content(map.get("comment_content"));
		
		String sender_name=uservice.getUserByNum(dto.getSender_num()).getUser_name();
		String sender_photo=uservice.getUserByNum(dto.getSender_num()).getUser_photo();
		
		dto.setSender_name(sender_name);
		dto.setSender_photo(sender_photo);
		
		//알림 insert
		paservice.insertPostAlarm(dto);
	}
	
	//알림 모두 지우기
	@GetMapping("/allalarmdelete")
	public void allAlarmDelete(HttpSession session)
	{
		String receiver_num=(String)session.getAttribute("user_num");
		
		faservice.deleteAllFollowalarm(receiver_num);
		paservice.deleteallPostAlarm(receiver_num);
		caservice.deleteAllCommentAlarm(receiver_num);
		plaservice.deleteAllPlikeAlarm(receiver_num);
		claservice.deleteAllClikealarm(receiver_num);
	}
	
	//알림받아오기
	@GetMapping("/messagealarmget")
	public Map<String, Object> messagealarmGet(HttpSession session)
	{
		Map<String, Object> map=new HashMap<>();
		
		//내 num
		String user_num=(String)session.getAttribute("user_num");
		
		//알림개수 세기
		int msgalCount=maserive.getTotalCountMessAlarm(user_num);
		
		if(msgalCount!=0) {
			//메시지 알림 목록(최근대화목록)
			List<MessageDto> list=maserive.getAllMessAlarm(user_num);
			
			map.put("totalCount", maserive.getTotalCountMessAlarm(user_num));
			map.put("list", list);
		}
		
		//전체알림(메시지 제외)
		Map<Integer, Long> alarmTime=new HashMap<>();
		int timeNum=0;
		Date today=new Date();
		
		List<Object> alarmList=new ArrayList<>();
		int alarmCount=0;
		
		//댓글
		//댓글 알림개수 세기
		int postalarmCount=paservice.getTotalCountPostAlarm(user_num);
		alarmCount+=postalarmCount;
		
		if(postalarmCount!=0) {
			//댓글 목록
			List<PostalarmDto> paList=paservice.getAllPostAlarm(user_num);
			
			for(PostalarmDto p:paList) {
				String sender_num=p.getSender_num();
				
				String sender_name=uservice.getUserByNum(sender_num).getUser_name();
				String sender_photo=uservice.getUserByNum(sender_num).getUser_photo();
				
				p.setSender_name(sender_name);
				p.setSender_photo(sender_photo);
				
				////////////////
				//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
				/* System.out.println(today); */
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date writeday=new Date();
				try {
					writeday=sdf.parse(p.getComment_writeday().toString());
					/* System.out.println(writeday); */
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		
				long diffSec=(today.getTime()-writeday.getTime());
				diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
				/* System.out.println(diffSec); */
		
				p.setTimeSec(diffSec); //시간 다시 넣어주기
				alarmTime.put(timeNum, diffSec);
				++timeNum;
				
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
				
				p.setTime(preTime);
				/////////////
			}
			
			alarmList.addAll(paList);
		}
		
		//답글
		//답글 알림개수 세기
		int commentalarmCount=caservice.getTotalCountCommentAlarm(user_num);
		alarmCount+=commentalarmCount;

		if(commentalarmCount!=0) {
			//댓글 목록
			List<CommentalarmDto> caList=caservice.getAllCommentAlarm(user_num);

			for(CommentalarmDto c:caList) {
				String sender_num=c.getSender_num();

				String sender_name=uservice.getUserByNum(sender_num).getUser_name();
				String sender_photo=uservice.getUserByNum(sender_num).getUser_photo();

				c.setSender_name(sender_name);
				c.setSender_photo(sender_photo);

				////////////////
				//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
				/* System.out.println(today); */
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date writeday=new Date();
				try {
					writeday=sdf.parse(c.getComment_writeday().toString());
					/* System.out.println(writeday); */
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				long diffSec=(today.getTime()-writeday.getTime());
				diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
				/* System.out.println(diffSec); */

				c.setTimeSec(diffSec); //시간 다시 넣어주기
				alarmTime.put(timeNum, diffSec);
				++timeNum;

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

				c.setTime(preTime);
				/////////////
			}

			alarmList.addAll(caList);
		}
		
		//게시글 좋아요
		//게시글 좋아요 알림개수 세기
		int plikealarmCount=plaservice.getTotalCountPlikealarm(user_num);
		alarmCount+=plikealarmCount;

		if(plikealarmCount!=0) {
			//댓글 목록
			List<PlikealarmDto> plaList=plaservice.getAllPlikealarm(user_num);

			for(PlikealarmDto pl:plaList) {
				String sender_num=pl.getSender_num();

				String sender_name=uservice.getUserByNum(sender_num).getUser_name();
				String sender_photo=uservice.getUserByNum(sender_num).getUser_photo();

				pl.setSender_name(sender_name);
				pl.setSender_photo(sender_photo);

				////////////////
				//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
				/* System.out.println(today); */
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date writeday=new Date();
				try {
					writeday=sdf.parse(pl.getAlarmtime().toString());
					/* System.out.println(writeday); */
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				long diffSec=(today.getTime()-writeday.getTime());
				diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
				/* System.out.println(diffSec); */

				pl.setTimeSec(diffSec); //시간 다시 넣어주기
				alarmTime.put(timeNum, diffSec);
				++timeNum;

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

				pl.setTime(preTime);
				/////////////
			}

			alarmList.addAll(plaList);
		}
		
		//댓글 좋아요
		//댓글 좋아요 알림개수 세기
		int clikealarmCount=claservice.getTotalCountClikealarm(user_num);
		alarmCount+=clikealarmCount;

		if(clikealarmCount!=0) {
			//댓글 목록
			List<ClikealarmDto> claList=claservice.getAllClikealarm(user_num);

			for(ClikealarmDto cl:claList) {
				String sender_num=cl.getSender_num();

				String sender_name=uservice.getUserByNum(sender_num).getUser_name();
				String sender_photo=uservice.getUserByNum(sender_num).getUser_photo();

				cl.setSender_name(sender_name);
				cl.setSender_photo(sender_photo);

				////////////////
				//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
				/* System.out.println(today); */
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
				Date writeday=new Date();
				try {
					writeday=sdf.parse(cl.getAlarmtime().toString());
					/* System.out.println(writeday); */
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				long diffSec=(today.getTime()-writeday.getTime());
				diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
				/* System.out.println(diffSec); */

				cl.setTimeSec(diffSec); //시간 다시 넣어주기
				alarmTime.put(timeNum, diffSec);
				++timeNum;

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

				cl.setTime(preTime);
				/////////////
			}

			alarmList.addAll(claList);
		}
		
		//팔로우
		//팔로우 알림개수 세기
		int followalarmCount=faservice.getAllCountFollowalarm(user_num);
		alarmCount+=followalarmCount;
		
		if(followalarmCount!=0) {
			//팔로우 목록
			List<FollowalarmDto> faList=faservice.getAllFollowalarm(user_num);
			
			for(FollowalarmDto f:faList) {
				String sender_num=f.getSender_num();
				
				String sender_name=uservice.getUserByNum(sender_num).getUser_name();
	    		String sender_photo=uservice.getUserByNum(sender_num).getUser_photo();
	    		
	    		f.setSender_name(sender_name);
	    		f.setSender_photo(sender_photo);
	    		
	    		////////////////
	    		//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
	    		/* System.out.println(today); */
	    		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    		sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
	    		Date writeday=new Date();
	    		try {
	    			writeday=sdf.parse(f.getAlarmtime().toString());
	    			/* System.out.println(writeday); */
	    		} catch (ParseException e) {
	    			// TODO Auto-generated catch block
	    			e.printStackTrace();
	    		}

	    		long diffSec=(today.getTime()-writeday.getTime());
	    		diffSec-=32400000L; //DB에 now()로 들어가는 시간이 9시간 차이 나서 빼줌
	    		/* System.out.println(diffSec); */

	    		f.setTimeSec(diffSec); //시간 다시 넣어주기
	    		alarmTime.put(timeNum, diffSec);
	    		++timeNum;
	    		
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
				
				f.setTime(preTime);
	    		/////////////
			}
			
			alarmList.addAll(faList);
		}
		
		//시간 순으로 맞춰주기
		for(int i=0;i<alarmList.size()-1;i++) {
			for(int j=i+1;j<alarmList.size();j++) {
				if(alarmTime.get(i)<alarmTime.get(j)) {
					Object temp=alarmList.get(i);
					alarmList.set(i, alarmList.get(j));
					alarmList.set(j, temp);
				}
			}
		}
		
		try {
			String pass=uservice.getUserByNum(user_num).getUser_pass();
			
			if(pass.length()<=11) {
				Map<String, String> passMap=new HashMap<>();
				map.put("type", "pass");
				alarmList.add(passMap);
				alarmCount++;
			}
		}catch(Exception e) {
			
		}
		
		Collections.reverse(alarmList);
		
		map.put("alarmCount", alarmCount);
		map.put("alarmList", alarmList);
		
		return map;
	}
}
