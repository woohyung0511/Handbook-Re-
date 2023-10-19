package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.GuestbooklikeDto;
import com.sns.handbook.mapper.GuestbooklikeMapperInter;

@Service
public class GuestbooklikeService implements GuestbooklikeServiceInter {

	@Autowired
	GuestbooklikeMapperInter glInter;
	
	@Override
	public int getTotalGuestLike(String guest_num) {
		// TODO Auto-generated method stub
		return glInter.getTotalGuestLike(guest_num);
	}

	@Override
	public void insertGuestLike(GuestbooklikeDto dto) {
		// TODO Auto-generated method stub

		glInter.insertGuestLike(dto);
	}

	@Override
	public void deleteGuestLike(String guest_num, String user_num) {
		// TODO Auto-generated method stub

		glInter.deleteGuestLike(guest_num, user_num);
	}

	@Override
	public int checkGuestLike(String user_num, String guest_num) {
		// TODO Auto-generated method stub
		
		Map<String, String> map=new HashMap<>();
		
		map.put("user_num", user_num);
		map.put("guest_num", guest_num);
		
		return glInter.checkGuestLike(map);
	}

}
