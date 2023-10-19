package com.sns.handbook.serivce;

import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.MessageDto;
import com.sns.handbook.dto.MessagealarmDto;

public interface MessagealarmServiceInter {

	public int getMessAlarmCount(int mess_group);
	public MessagealarmDto getMessAlarm(int mess_group);
	public void updateMessAlarmChkcount(int mess_group);
	public void delteMessAlarm(int mess_group);
	public void insertMessAlarm(String receiver_num,String sender_num,int mess_group,int chkcount);
	public int getTotalCountMessAlarm(String user_num);
	public List<MessageDto> getAllMessAlarm(String user_num);
}
