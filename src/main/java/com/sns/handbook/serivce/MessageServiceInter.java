package com.sns.handbook.serivce;

import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.MessageDto;

public interface MessageServiceInter {

	public List<Map<String, Object>> selectAllChatMemeber(String user_num,String other_name);
	public MessageDto selectRecentMessage(String user_num,String other);
	public List<MessageDto> selectAllByGroup(int mess_group, String user_num);
	public void insertMessage(MessageDto dto);
	public int getRecentGroup(String user_num);
	public void deleteMessage(String mess_num);
	public int selectMaxNum();
	public int getCountOfMessage(String user_num,String other);
	public void deleteMessageGroup(int mess_group);
}
