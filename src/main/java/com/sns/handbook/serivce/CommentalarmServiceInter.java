package com.sns.handbook.serivce;

import java.util.List;

import com.sns.handbook.dto.CommentalarmDto;
import com.sns.handbook.dto.PostalarmDto;

public interface CommentalarmServiceInter {
	public void insertCommentAlarm(CommentalarmDto dto);
	public List<CommentalarmDto> getAllCommentAlarm(String receiver_num);
	public int getTotalCountCommentAlarm(String receiver_num);
	public void deleteAllCommentAlarm(String receiver_num);
}
