package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.PostlikeDto;
import com.sns.handbook.mapper.PostlikeMapperInter;

@Service
public class PostlikeService implements PostlikeServiceInter {

	@Autowired
	PostlikeMapperInter plInter;

	@Override
	public int getTotalLike(String post_num) {
		// TODO Auto-generated method stub
		return plInter.getTotalLike(post_num);
	}

	@Override
	public void insertLike(PostlikeDto dto) {
		// TODO Auto-generated method stub
		plInter.insertLike(dto);
	}

	@Override
	public void deleteLike(String post_num,String user_num) {
		// TODO Auto-generated method stub
		plInter.deleteLike(post_num,user_num);
	}

	@Override
	public int checklike(String user_num, String post_num) {
		// TODO Auto-generated method stub

		Map<String, String> map = new HashMap<>();

		map.put("user_num", user_num);
		map.put("post_num", post_num);
		return plInter.checklike(map);
	}

}
