<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


				<!-- 모달이 여러개라 id값 name값 다르게-->
                      <c:forEach items="${estDetailList}" var="list"  >
       					<tr>
		                 	 <td> ${list.item_name} </td>
                             <td> ${list.item_price}</td>
                             <td> ${list.item_surtax}</td>
                             <td> ${list.provide_value}</td>  
                             <td> ${list.qut}</td> 
						</tr>
			
					</c:forEach>
					

		  		<!-- 단건조회시 카운트와 연관 깊음 --> 			
				<input type="hidden"  id="estDetailCnt"  name="estDetailCnt"  value="${estDetailCnt}"/> 
