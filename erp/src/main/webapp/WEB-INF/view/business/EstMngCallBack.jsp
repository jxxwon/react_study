<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


							<c:if test="${estCnt eq 0 }">
								<tr>
									<td colspan="9">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
				
							<c:if test="${estCnt > 0 }">w
								<c:set var="nRow" value="${pageSize*(currentPage-1)}" />
		
								<c:forEach items="${estList}" var="list"  >
									<tr>
										 <!-- 날짜 누르면 readonly  -->
										 <td><a  href="javascript:estOne('${list.estm_num}')" ><strong >${list.estm_date} </strong></a></td>
						                  <td> ${list.cust_name} </td>
						                  <td> ${list.item_name} </td>
			                              <td><fmt:formatNumber value="${list.item_price}" /> 원</td>
			                              <td><fmt:formatNumber value="${list.item_surtax}" /> 원</td>
			                              <td><fmt:formatNumber value="${list.provide_value}" /> 원</td>
			                              <td> ${list.apply_yn} </td>
									</tr>
									<c:set var="nRow" value="${nRow + 1}" /> <!-- 페이징 네비게이션 -->
								</c:forEach>
							</c:if>

							<!-- 단건조회시 카운트와 연관 깊음 --> 			
							<input type="hidden"  id="estCnt"  name="estCnt"  value="${estCnt}"/>