package kr.happyjob.study.employee.model;

public class SalaryModel {
	
	private String loginID;			// 사번 (PK)
	private String salary_year;		// 급여연월 (PK)
	private int health_insur;		// 건강보험
	private int empl_insur;			// 고용보험
	private int nation_pens;		// 국민연금
	private int workers_insur;		// 산재보험
	private int pens;				// 퇴직금
	private String bank_code;		// 은행코드
	private String salary_account;	// 급여통장 계좌번호
	private int annual_salary;		// 연봉
	private int salary;				// 실급여
	private String pay_status;		// 지급여부
	
	private String name;			// 사원이름
	private String pos_name;		// 직급
	private String emp_date;		// 입사일자
	private String dept_name;		// 부서명
	private String dept_code;		// 부서코드
	private String pos_code;		// 직급코드
	
	
	public SalaryModel() {
	}
	
	// 데이터 없을 때 처리
	public SalaryModel(String loginID, String name) {
		
		this.loginID = loginID;		// 사번 (PK)
		this.salary_year = "0";		// 급여연월 (PK)
		this.pay_status = "N";		// 지급상태
		this.name = name;			// 이름
				
	}

	public String getLoginID() {
		return loginID;
	}

	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}

	public String getSalary_year() {
		return salary_year;
	}

	public void setSalary_year(String salary_year) {
		this.salary_year = salary_year;
	}

	public int getHealth_insur() {
		return health_insur;
	}

	public void setHealth_insur(int health_insur) {
		this.health_insur = health_insur;
	}

	public int getEmpl_insur() {
		return empl_insur;
	}

	public void setEmpl_insur(int empl_insur) {
		this.empl_insur = empl_insur;
	}

	public int getNation_pens() {
		return nation_pens;
	}

	public void setNation_pens(int nation_pens) {
		this.nation_pens = nation_pens;
	}

	public int getWorkers_insur() {
		return workers_insur;
	}

	public void setWorkers_insur(int workers_insur) {
		this.workers_insur = workers_insur;
	}

	public int getPens() {
		return pens;
	}

	public void setPens(int pens) {
		this.pens = pens;
	}

	public String getBank_code() {
		return bank_code;
	}

	public void setBank_code(String bank_code) {
		this.bank_code = bank_code;
	}

	public String getSalary_account() {
		return salary_account;
	}

	public void setSalary_account(String salary_account) {
		this.salary_account = salary_account;
	}

	public int getAnnual_salary() {
		return annual_salary;
	}

	public void setAnnual_salary(int annual_salary) {
		this.annual_salary = annual_salary;
	}

	public int getSalary() {
		return salary;
	}

	public void setSalary(int salary) {
		this.salary = salary;
	}

	public String getPay_status() {
		return pay_status;
	}

	public void setPay_status(String pay_status) {
		this.pay_status = pay_status;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPos_name() {
		return pos_name;
	}

	public void setPos_name(String pos_name) {
		this.pos_name = pos_name;
	}

	public String getEmp_date() {
		return emp_date;
	}

	public void setEmp_date(String emp_date) {
		this.emp_date = emp_date;
	}

	public String getDept_name() {
		return dept_name;
	}

	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}

	public String getPos_code() {
		return pos_code;
	}

	public void setPos_code(String pos_code) {
		this.pos_code = pos_code;
	}
}
