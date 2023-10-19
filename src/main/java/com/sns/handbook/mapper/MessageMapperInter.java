package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.MessageDto;

@Mapper
public interface MessageMapperInter {

	public List<MessageDto> selectAllChatMemeber(Map<String, String> map);
	public MessageDto selectRecentMessage(Map<String, String> map);
	public List<MessageDto> selectAllByGroup(Map<String, Object> map);
	public void insertMessage(MessageDto dto);
	public int getRecentGroup(String user_num);
	public void deleteMessage(String mess_num);
	public int selectMaxNum();
	public int getCountOfMessage(Map<String, String> map);
	public void deleteMessageGroup(int mess_group);
}
