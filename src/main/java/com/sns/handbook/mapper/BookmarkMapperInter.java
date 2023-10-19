package com.sns.handbook.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sns.handbook.dto.BookmarkDto;
import com.sns.handbook.dto.PostDto;

@Mapper
public interface BookmarkMapperInter {
	
	public void insertBookmark(BookmarkDto dto);
	public void deleteBookmark(Map<String, String> map);
	public int bookmarkCheck(Map<String, String> map);
	public List<PostDto> bookmarkPost(Map<String, Object> map);
}
