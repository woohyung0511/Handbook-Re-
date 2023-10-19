package com.sns.handbook.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("CommentlikeDto")
public class CommentlikeDto {

	private String clike_num;
	private String user_num;
	private String comment_num;
}
