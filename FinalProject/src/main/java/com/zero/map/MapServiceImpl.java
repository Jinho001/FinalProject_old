package com.zero.map;


import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.zero.waste.mapper.MapMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MapServiceImpl implements MapService {
	
	private final MapMapper mapMapper;
	
	@Override
	public int registMap(MapVO mapInfo) {
		return mapMapper.registMap(mapInfo);
	}

	@Override 
	public List<MapVO> selectMapView() {
		return mapMapper.selectMapView();
	}

	@Override
	public List<MapVO> searchKeyword(String type, String keyword) {
		return mapMapper.searchKeyword(type, keyword);
	}
	
	@Override
	public List<MapVO> selectCategory(int category){
		return mapMapper.selectCategory(category);
	}

}
