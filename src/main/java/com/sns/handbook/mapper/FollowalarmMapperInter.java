package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.FollowalarmDto;

@Mapper
public interface FollowalarmMapperInter {

	public void insertFollowalarm(FollowalarmDto dto);
	public List<FollowalarmDto> getAllFollowalarm(String reciever_num);
	public int getAllCountFollowalarm(String receiver_num);
	public int findSameFollowalarm(Map<String, String> map);
	public FollowalarmDto getFollowalarmByNum(Map<String, String> map);
	public void deleteFollowalarm(String followal_num);
	public void deleteAllFollowalarm(String receiver_num);
}
