package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.PlikealarmDto;
import com.sns.handbook.mapper.PlikealarmMapperInter;

@Service
public class PlikealarmService implements PlikealarmServiceInter{

	@Autowired
	PlikealarmMapperInter mapperInter;

	@Override
	public void insertPlikealarm(PlikealarmDto dto) {
		// TODO Auto-generated method stub
		mapperInter.insertPlikealarm(dto);
	}

	@Override
	public int getTotalCountPlikealarm(String receiver_num) {
		// TODO Auto-generated method stub
		return mapperInter.getTotalCountPlikealarm(receiver_num);
	}

	@Override
	public List<PlikealarmDto> getAllPlikealarm(String receiver_num) {
		// TODO Auto-generated method stub
		return mapperInter.getAllPlikealarm(receiver_num);
	}

	@Override
	public int findSamePlikealarm(String receiver_num, String sender_num, String post_num, String guest_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		map.put("post_num", post_num);
		map.put("guest_num", guest_num);
		
		return mapperInter.findSamePlikealarm(map);
	}

	@Override
	public void deletePlikealarm(String plikeal_num) {
		// TODO Auto-generated method stub
		mapperInter.deletePlikealarm(plikeal_num);
	}

	@Override
	public PlikealarmDto getOnePlikealarm(String receiver_num, String sender_num, String post_num, String guest_num) {
		// TODO Auto-generated method stub
		Map<String, String> map=new HashMap<>();
		
		map.put("receiver_num", receiver_num);
		map.put("sender_num", sender_num);
		map.put("post_num", post_num);
		map.put("guest_num", guest_num);
		
		return mapperInter.getOnePlikealarm(map);
	}

	@Override
	public void deleteAllPlikeAlarm(String receiver_num) {
		// TODO Auto-generated method stub
		mapperInter.deleteAllPlikeAlarm(receiver_num);
	}
}
