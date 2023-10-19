package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.MessagealarmDto;

@Mapper
public interface MessagealarmMapperInter {

	public int getMessAlarmCount(int mess_group);
	public MessagealarmDto getMessAlarm(int mess_group);
	public void updateMessAlarmChkcount(int mess_group);
	public void delteMessAlarm(int mess_group);
	public void insertMessAlarm(Map<String, Object> map);
	public int getTotalCountMessAlarm(String user_num);
	public List<MessagealarmDto> getAllMessAlarm(String user_num);
}
