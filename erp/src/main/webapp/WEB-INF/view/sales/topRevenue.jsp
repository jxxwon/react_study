<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<dl>
	<dt>
		<strong>${title}</strong>
	</dt>
	<dd class="content" style="display: flex;">
		<c:if test="${list.size() eq 0 }">
			<p>데이터가 존재하지 않습니다</p>
		</c:if>
		
		<c:if test="${list.size() > 0 }">
			<div id="topChartContainer" style="width: 60%">
				<canvas id="topChart"></canvas>
			</div>
			<table class="col" style="width: 40%">
				<colgroup>
					<col width="33%">
					<col width="33%">
					<col width="34%">
				</colgroup>
				<thead>
					<tr>
						<th>순위</th>
						<th>${nameLabel}</th>
						<th>${amountLabel}</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="item" varStatus="status">
						<tr class="top-revenue-list">
							<td>${status.count}</td>
							<td>${item.name}</td>
							<td><fmt:formatNumber value="${item.amount}" pattern="#,###" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</dd>
</dl>
<input type="hidden" id="listSize" name="listSize" value="${list.size()}"/>
<a href="#" class="closePop" onclick="btnCloseHandler()">
	<span class="hidden">닫기</span>
</a>
