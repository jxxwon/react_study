<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${salePlanListCnt eq 0 }">
			<tr>
				<td colspan="9">등록된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		
		<!-- 갯수가 있는 경우  -->
		<c:if test="${salePlanListCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${salePlanList}" var="list">
				<tr id="salesPlanRow" onclick="javascript:empSaledetailModal('${list.loginID}','${list.plan_num}');">					
					<td><fmt:formatDate value="${list.target_date}" pattern="yyyy-MM-dd" /></td>
					<td>${list.cust_name}</td>
					<td>${list.manufac}</td>
					<td>${list.major_class}</td>
					<td>${list.sub_class}</td>
					<td>${list.item_name}</td>
					<td>${list.goal_qut}</td>
					<td>${list.perform_qut}</td>
					<td>${list.plan_note}</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${salePlanListCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->