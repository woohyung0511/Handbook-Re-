package com.sns.handbook.serivce;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sns.handbook.dto.MessageDto;
import com.sns.handbook.dto.MessagealarmDto;
import com.sns.handbook.mapper.MessagealarmMapperInter;

@Service
public class MessagealarmService implements MessagealarmServiceInter {

	@Autowired
	MessagealarmMapperInter mapperInter;
	
	@Autowired
	MessageService mservice;
	
	@Autowired
	UserService uservice;

	@Override
	public int getMessAlarmCount(int mess_group) {
		// TODO Auto-generated method stub
		return mapperInter.getMessAlarmCount(mess_group);
	}

	@Override
	public MessagealarmDto getMessAlarm(int mess_group) {
		// TODO Auto-generated method stub
		return mapperInter.getMessAlarm(mess_group);
	}

	@Override
	public void updateMessAlarmChkcount(int mess_group) {
		// TODO Auto-generated method stub
		mapperInter.updateMessAlarmChkcount(mess_group);
	}

	@Override
	public void delteMessAlarm(int mess_group) {
		// TODO Auto-generated method stub
		mapperInter.delteMessAlarm(mess_group);
	}

	@Override
	public void insertMessAlarm(String receiver_num,String sender_num, int mess_group, int chkcount) {
		// TODO Auto-generated method stub
		Map<String, Object> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		map.put("mess_group", mess_group);
		map.put("chkcount", chkcount);
		
		mapperInter.insertMessAlarm(map);
	}

	@Override
	public int getTotalCountMessAlarm(String user_num) {
		// TODO Auto-generated method stub
		return mapperInter.getTotalCountMessAlarm(user_num);
	}

	@Override
	public List<MessageDto> getAllMessAlarm(String user_num) {
		// TODO Auto-generated method stub
		
		
		List<MessagealarmDto> alarm=mapperInter.getAllMessAlarm(user_num);
		//알람 가져옴
		
		List<MessageDto> list=new ArrayList<>(); //최근 대화목록(알림) 띄울 리스트
		
		for(MessagealarmDto madto:alarm) {
			MessageDto mdto = mservice.selectRecentMessage(user_num, madto.getSender_num());
			
			mdto.setSender_name(uservice.getUserByNum(mdto.getSender_num()).getUser_name());
			mdto.setReceiver_name(uservice.getUserByNum(mdto.getReceiver_num()).getUser_name());
			mdto.setSender_photo(uservice.getUserByNum(mdto.getSender_num()).getUser_photo());
			
			list.add(mdto);
		}
		
		//최신순으로 정렬
		for(int i=0;i<list.size()-1;i++) {
			for(int j=i+1;j<list.size();j++) {
				int inum=Integer.parseInt(list.get(i).getMess_num());
				int jnum=Integer.parseInt(list.get(j).getMess_num());

				//뒤에 데이터가 더 최신 거면 앞으로 옮기기(자리 바꾸기)
				if(inum<jnum) {
					MessageDto temp=list.get(j);
					list.set(j, list.get(i));
					list.set(i, temp);
				}
			}
		}
		
		///////////////////////
		
		for(MessageDto m:list) {
			//대화 시간 오늘 날짜에서 빼기(몇 초전... 몇 분 전...)
			Date today=new Date();
			/* System.out.println(today); */
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
			Date writeday=new Date();
			try {
				writeday=sdf.parse(m.getMess_writeday().toString());
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

			m.setMess_time(preTime);
		}
		
		////////////////////////
		
		
		return list;
	}
}
