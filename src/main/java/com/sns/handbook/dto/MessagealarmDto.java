package com.sns.handbook.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("MessagealarmDto")
public class MessagealarmDto {

	private String messal_num;
	private String receiver_num;
	private String sender_num;
	private int mess_group;
	private int chkcount;
}
