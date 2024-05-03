package com.zero.map;

import lombok.Data;

@Data
public class MapVO {
	private int shopId;
	private String shopName;
	private String addr;
	private double lat;
	private double lng;
	private int category;
}
