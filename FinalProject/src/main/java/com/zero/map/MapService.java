package com.zero.map;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;

public interface MapService {
	
	int registMap(MapVO mapInfo);
	List<MapVO> selectMapView();
	List<MapVO> searchKeyword(String type, String keyword);
	List<MapVO> selectCategory(int category);
	
}
