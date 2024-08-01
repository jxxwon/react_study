package kr.happyjob.study.sales.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.happyjob.study.sales.model.RevenueDailyModel;
import kr.happyjob.study.sales.model.RevenueModel;
import kr.happyjob.study.sales.model.TopRevenueModel;
import kr.happyjob.study.sales.service.RevenueService;

@Controller
@RequestMapping("/sales")
public class RevenueController {

	private final Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private RevenueService service;

	@RequestMapping("/dailyRevenue.do")
	public String dailyRevenue() {
		logger.info("dailyRevenue.do");

		return "sales/dailyRevenue";
	}

	@RequestMapping("/searchDaily.do")
	public String searchDaily(Model model, @RequestParam Map<String, Object> paramMap) {
		logger.info("searchDaily.do");
		logger.info("   - paramMap : " + paramMap);

		int currentPage = Integer.valueOf((String) paramMap.get("currentPage"));
		int pageSize = Integer.valueOf((String) paramMap.get("pageSize"));

		paramMap.put("startSeq", (currentPage - 1) * pageSize);
		paramMap.put("pageSize", pageSize);

		List<RevenueDailyModel> list = service.searchDaily(paramMap);
		int totalCount = service.searchDailyTotalCount(paramMap);
		long totalAmount = 0;
		long totalUnpaid = 0;
		long totalPayAmount = 0;

		for (int i = 0; i < list.size(); i++) {
			totalAmount += list.get(i).getAmount();
			totalPayAmount += list.get(i).getPayAmount();

			if (list.get(i).getUnpaidState().equals("N")) {
				totalUnpaid += list.get(i).getAmount();
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalAmount", totalAmount);
		model.addAttribute("totalPayAmount", totalPayAmount);
		model.addAttribute("totalUnpaid", totalUnpaid);

		return "sales/dailyRevenueList";
	}

	@RequestMapping("/monthlyRevenue.do")
	public String monthlyRevenue(Model model) {
		logger.info("monthlyRevenue.do");

		model.addAttribute("isMonthly", "Y");

		return "sales/revenue";
	}

	@RequestMapping("/searchRevenue.do")
	public String searchRevenue(Model model, @RequestParam Map<String, Object> paramMap) {
		logger.info("searchRevenue.do");
		logger.info("   - paramMap : " + paramMap);

		setBetweenDate(paramMap);

		List<RevenueModel> list = service.searchRevenue(paramMap);

		long totalAmount = 0;
		long totalUnpaidAmount = 0;
		long totalPayAmount = 0;

		for (int i = 0; i < list.size(); i++) {
			totalAmount += list.get(i).getAmount();
			totalUnpaidAmount += list.get(i).getUnpaidAmount();
			totalPayAmount += list.get(i).getPayAmount();
		}

		model.addAttribute("list", list);
		model.addAttribute("totalAmount", totalAmount);
		model.addAttribute("totalPayAmount", totalPayAmount);
		model.addAttribute("totalUnpaidAmount", totalUnpaidAmount);

		return "sales/revenueList";
	}

	@RequestMapping("/yearlyRevenue.do")
	public String yearlyRevenue(Model model) {
		logger.info("yearlyRevenue.do");

		model.addAttribute("isMonthly", "N");

		return "sales/revenue";
	}

	@RequestMapping("/searchTop.do")
	public String searchTop(Model model, @RequestParam Map<String, Object> paramMap) {
		logger.info("searchTop.do");
		logger.info("   - paramMap : " + paramMap);

		String type = (String) paramMap.get("type");

		setBetweenDate(paramMap);

		List<TopRevenueModel> list = null;
		String title = null;
		String nameLabel = null;
		String amountLabel = null;

		if ("item".equals(type)) {
			list = service.searchTopItem(paramMap);
			title = "매출 상위 제품";
			nameLabel = "제품명";
			amountLabel = "제품 단가";
		} else {
			list = service.searchTopCust(paramMap);
			title = "매출 상위 기업";
			nameLabel = "기업명";
			amountLabel = "매출";
		}

		model.addAttribute("list", list);
		model.addAttribute("title", title);
		model.addAttribute("nameLabel", nameLabel);
		model.addAttribute("amountLabel", amountLabel);

		return "sales/topRevenue";
	}

	private void setBetweenDate(Map<String, Object> params) {
		String isMonthly = (String) params.get("isMonthly");

		if ("Y".equals(isMonthly)) {
			String month = (String) params.get("month");

			if (!"".equals(month)) {
				month = (String) params.get("month") + "-01";
			} else {
				month = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			}

			LocalDate localDate = LocalDate.parse(month);
			LocalDate startDate = localDate.withDayOfMonth(1);
			LocalDate lastDate = localDate.withDayOfMonth(localDate.lengthOfMonth());

			params.put("startDate", startDate.format(DateTimeFormatter.ISO_LOCAL_DATE));
			params.put("endDate", lastDate.format(DateTimeFormatter.ISO_LOCAL_DATE));
		} else if ("N".equals(isMonthly)) {
			String yearStr = (String) params.get("year");
			int year = 0;

			if ("".equals(yearStr)) {
				year = LocalDate.now().getYear();
			} else {
				year = Integer.parseInt(yearStr);
			}

			params.put("startDate", (year - 4) + "-01-31");
			params.put("endDate", year + "-12-31");
		}
	}
}
