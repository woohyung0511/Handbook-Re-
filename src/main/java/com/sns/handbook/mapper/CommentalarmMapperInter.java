package com.sns.handbook.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.CommentalarmDto;
import com.sns.handbook.dto.PostalarmDto;

@Mapper
public interface CommentalarmMapperInter {
	public void insertCommentAlarm(CommentalarmDto dto);
	public List<CommentalarmDto> getAllCommentAlarm(String receiver_num);
	public int getTotalCountCommentAlarm(String receiver_num);
	public void deleteAllCommentAlarm(String receiver_num);
}
