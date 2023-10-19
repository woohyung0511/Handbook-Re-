package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.ClikealarmDto;
import com.sns.handbook.dto.PlikealarmDto;

@Mapper
public interface ClikealarmMapperInter {

	public void insertClikealarm(ClikealarmDto dto);
	public int getTotalCountClikealarm(String receiver_num);
	public List<ClikealarmDto> getAllClikealarm(String receiver_num);
	public int findSameClikealarm(Map<String, String> map);
	public void deleteClikealarm(String clikeal_num);
	public ClikealarmDto getOneClikealarm(Map<String, String> map);
	public void deleteAllClikealarm(String receiver_num);
}
