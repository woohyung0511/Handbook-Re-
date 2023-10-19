package com.sns.handbook.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("PostlikeDto")
public class PostlikeDto {

	private String plike_num;
	private String user_num;
	private String post_num;
}
