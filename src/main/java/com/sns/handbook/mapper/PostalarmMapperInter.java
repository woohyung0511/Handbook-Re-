package com.sns.handbook.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.PostalarmDto;

@Mapper
public interface PostalarmMapperInter {
	public void insertPostAlarm(PostalarmDto dto);
	public List<PostalarmDto> getAllPostAlarm(String receiver_num);
	public int getTotalCountPostAlarm(String receiver_num);
	public void deleteallPostAlarm(String receiver_num);
}
