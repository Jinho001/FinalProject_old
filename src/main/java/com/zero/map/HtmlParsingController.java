package com.zero.map;

import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HtmlParsingController {
    
    @GetMapping("/map")
    public String showMapPage() {
    	System.out.println("map");
    	//List<XXVO> list =
    	//model.addAttribute("jsonData", jsonData);
        return "map/map"; // 매핑된 뷰 이름 (map.jsp 또는 map.html)
    }
}
