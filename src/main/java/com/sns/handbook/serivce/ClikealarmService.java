package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.ClikealarmDto;
import com.sns.handbook.dto.PlikealarmDto;
import com.sns.handbook.mapper.ClikealarmMapperInter;
import com.sns.handbook.mapper.PlikealarmMapperInter;

@Service
public class ClikealarmService implements ClikealarmServiceInter{

	@Autowired
	ClikealarmMapperInter mapperInter;

	@Override
	public void insertClikealarm(ClikealarmDto dto) {
		// TODO Auto-generated method stub
		mapperInter.insertClikealarm(dto);
	}

	@Override
	public int getTotalCountClikealarm(String receiver_num) {
		// TODO Auto-generated method stub
		return mapperInter.getTotalCountClikealarm(receiver_num);
	}

	@Override
	public List<ClikealarmDto> getAllClikealarm(String receiver_num) {
		// TODO Auto-generated method stub
		return mapperInter.getAllClikealarm(receiver_num);
	}

	@Override
	public int findSameClikealarm(String receiver_num, String sender_num, String comment_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		map.put("comment_num", comment_num);
		
		return mapperInter.findSameClikealarm(map);
	}

	@Override
	public void deleteClikealarm(String clikeal_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteClikealarm(clikeal_num);
	}

	@Override
	public ClikealarmDto getOneClikealarm(String receiver_num, String sender_num, String comment_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		map.put("comment_num", comment_num);
		
		return mapperInter.getOneClikealarm(map);
	}

	@Override
	public void deleteAllClikealarm(String receiver_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteAllClikealarm(receiver_num);
	}
}
