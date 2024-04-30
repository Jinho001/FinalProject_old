<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>제로웨이스트지도</title>
</head>
<script>

</script>
<body>
	<div id="map" style="width: 1000px; height: 500px;"></div>
	<form name="regimap" method="post" action="/regimap">
	<input type="text" name="shopName" id="shopName" value="진호샵">
	<input type="text" name="addr" id="addr" value="천안">

	<!-- 
	<input type="double" name="lat" id="lat" value="123">
	<input type="number" name="lng" id="lng" placeholder="lng">
	<input type="number" name="category" id="category" placeholder="category">
	 -->
	<button>제출</button>
	</form>
	
	<script
		src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=4da202d77036151199a56057c568131d&libraries=clusterer"></script>
	<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(37.55489, 126.9708), // 지도의 중심좌표
			level : 3, // 지도의 확대 레벨
			mapTypeId : kakao.maps.MapTypeId.ROADMAP
		// 지도종류
		};

		// 지도를 생성한다 
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 마커 클러스터러를 생성합니다 
		var clusterer = new kakao.maps.MarkerClusterer({
			map : map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
			averageCenter : true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
			minLevel : 10
		// 클러스터 할 최소 지도 레벨 
		});
		var data = [];
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			String jdbcDriver = "jdbc:mysql://localhost:3306/zerowaste?useUnicode=true&serverTimezone=Asia/Seoul";
			String dbUser = "zerowaste";
			String dbPwd = "1234";
			
			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPwd);
			
			pstmt = conn.prepareStatement("select * from shop");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
	%>
		
		data.push([ <%= rs.getString("lat") %>, <%= rs.getString("lng") %>,
			'<div style="padding: 5px"><%= rs.getString("shopName") %></div>' ]);
		<%
			}
		}catch(SQLException se){
			se.printStackTrace();
		}finally{
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
		%>

		var markers = [];

		for (var i = 0; i < data.length; i++) {
			// 지도에 마커를 생성하고 표시한다
			var marker = new kakao.maps.Marker({
				position : new kakao.maps.LatLng(data[i][0], data[i][1]), // 마커의 좌표
				map : map
			// 마커를 표시할 지도 객체
			});

			var iwContent = '<div style="padding: 5px">내용</div>';
			// 인포윈도우를 생성합니다
			var infowindow = new kakao.maps.InfoWindow({
				content : data[i][2]
			});

			markers.push(marker);
			kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
					map, marker, infowindow));
			kakao.maps.event.addListener(marker, 'mouseout',
					makeOutListener(infowindow));
		}
		// 클러스터러에 마커들을 추가합니다
		clusterer.addMarkers(markers);

		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
			return function() {
				infowindow.open(map, marker);
			};
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
			return function() {
				infowindow.close();
			};
		}
	</script>
</body>
</html>