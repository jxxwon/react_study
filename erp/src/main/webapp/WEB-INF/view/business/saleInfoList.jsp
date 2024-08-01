<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${saleInfoListCnt eq 0 }">
			<tr>
				<td colspan="12">등록된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		
		<!-- 갯수가 있는 경우  -->
		<c:if test="${saleInfoListCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${saleInfoList}" var="list">
				<tr id="salesInfoRow">
					<td>${list.loginID}</td>
					<td>${list.name}</td>				
					<td><fmt:formatDate value="${list.target_date}" pattern="yyyy-MM-dd" /></td>				
					<td>${list.item_code}</td>
					<td>${list.manufac}</td>
					<td>${list.major_class}</td>
					<td>${list.sub_class}</td>
					<td>${list.item_name}</td>
					<td>${list.goal_qut}</td>
					<td>${list.perform_qut}</td>
					<td>
						<c:choose>
		                    <c:when test="${list.goal_qut != 0}">
		                        <fmt:formatNumber value="${(list.perform_qut / list.goal_qut) * 100}" />%
		                    </c:when>
		                    <c:otherwise>
		                        N/A
		                    </c:otherwise>
		                </c:choose>
					</td>
					<td>${list.plan_note}</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${saleInfoListCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->