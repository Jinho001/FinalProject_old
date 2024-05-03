package com.zero.map;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MapController {

    private final MapService mapService;
    @GetMapping("/regimap")
    public String regist() {
    	return "map/mapGeo";
    }

    @PostMapping("/regimap")
    public String registMap(MapVO mapInfo) {
	    mapService.registMap(mapInfo);
	    return "map/mapGeo";
    }

    @GetMapping("/mapList")
    public String mapList(Model m) {
        //DB에서 지도 리스트 가져오기
        List<MapVO> mapList = mapService.selectMapView();
        
        //가져온 리스트를 화면에 전달하기
        m.addAttribute("mapList", mapList);
        return "map/map";
    }
    
    @GetMapping("/mapList/searchShop")
    public String searchKeyword(Model model, 
    		@RequestParam(value="type", required=false) String type, 
    		@RequestParam(value="keyword", required=false) String keyword) { //db에 저장된 모든 값 가져오기,값이 없다면 default값으로 1주기
    	
    	//검색한 타입과 키워드가 있다면 지도에 마커로 표시되고, 아니라면 그냥 DB의 전체 지도 리스트를 보여준다. 
    	List<MapVO> mapList = new ArrayList<>();
    
    	if(type != null  && keyword !=null) {
    		mapList = mapService.searchKeyword(type, keyword);
		}else {
			mapList = mapService.selectMapView();
		}
    	
    	//가져온 리스트를 화면에 전달하기
        model.addAttribute("mapList", mapList);
    	return "map/map";
    }
    
    @PostMapping(value="/mapList/searchCategory", produces= {"application/json; charset=utf-8"})
    @ResponseBody
    public List<MapVO> selectCategory(@RequestParam("intValue")int intValue) {
        List<MapVO> selectedCategory = mapService.selectCategory(intValue);
        //System.out.println(selectedCategory);
        return selectedCategory;
    }

}
