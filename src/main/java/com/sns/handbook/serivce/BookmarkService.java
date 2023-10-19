package com.sns.handbook.serivce;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sns.handbook.dto.BookmarkDto;
import com.sns.handbook.dto.PostDto;
import com.sns.handbook.mapper.BookmarkMapperInter;

@Service
public class BookmarkService implements BookmarkServiceInter {

	@Autowired
	BookmarkMapperInter mapper;

	@Override
	public void insertBookmark(BookmarkDto dto) {
		// TODO Auto-generated method stub
		mapper.insertBookmark(dto);
	}

	@Override
	public void deleteBookmark(String owner_num, String bfriend_num) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();
		
		map.put("owner_num", owner_num);
		map.put("bfriend_num", bfriend_num);
		
		mapper.deleteBookmark(map);
	}

	@Override
	public int bookmarkCheck(String owner_num, String bfriend_num) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<>();
		
		map.put("owner_num", owner_num);
		map.put("bfriend_num", bfriend_num);
		
		return mapper.bookmarkCheck(map);
	}

	@Override
	public List<PostDto> bookmarkPost(String owner_num, int offset) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<>();
		
		map.put("owner_num", owner_num);
		map.put("offset", offset);
		
		return mapper.bookmarkPost(map);
	}
	
}
