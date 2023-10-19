package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.FollowalarmDto;
import com.sns.handbook.mapper.FollowalarmMapperInter;

@Service
public class FollowalarmService implements FollowalarmServiceInter {

	@Autowired
	FollowalarmMapperInter mapperInter;
	
	@Override
	public void insertFollowalarm(FollowalarmDto dto) {
		// TODO Auto-generated method stub
		mapperInter.insertFollowalarm(dto);
	}

	@Override
	public List<FollowalarmDto> getAllFollowalarm(String reciever_num) {
		// TODO Auto-generated method stub
		return mapperInter.getAllFollowalarm(reciever_num);
	}

	@Override
	public int getAllCountFollowalarm(String receiver_num) {
		// TODO Auto-generated method stub
		return mapperInter.getAllCountFollowalarm(receiver_num);
	}

	@Override
	public int findSameFollowalarm(String receiver_num, String sender_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		
		return mapperInter.findSameFollowalarm(map);
	}

	@Override
	public FollowalarmDto getFollowalarmByNum(String receiver_num,String sender_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		
		return mapperInter.getFollowalarmByNum(map);
	}

	@Override
	public void deleteFollowalarm(String followal_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteFollowalarm(followal_num);
	}

	@Override
	public void deleteAllFollowalarm(String receiver_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteAllFollowalarm(receiver_num);
	}

}
