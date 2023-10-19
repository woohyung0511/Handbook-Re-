package com.sns.handbook.serivce;

import java.util.List;
import java.util.Map;

import com.sns.handbook.dto.BookmarkDto;
import com.sns.handbook.dto.PostDto;

public interface BookmarkServiceInter {
	public void insertBookmark(BookmarkDto dto);
	public void deleteBookmark(String owner_num, String	bfriend_num);
	public int bookmarkCheck(String owner_num, String bfriend_num);
	public List<PostDto> bookmarkPost(String owner_num, int offset);
}
