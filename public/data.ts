import { request } from '@/public/request'
let mExpenditure = 0//本月总支出
let mIncome = 0//本月总收入
let mBudget = 0//本月总预算
let allMonth = 0//本月剩余
let allMonthMoney = 0//本月剩余 预算有关
let categoryExpenditure = []//当前用户的支出分类
let wExpenditure = 0//本周总支出
let wIncome = 0//本舟总收入
let wBudget = 0//本周总预算
let allWMoney = 0//本周剩余 预算有关
let hasMonth = false//是否已经获得本月的数据
let hasWork = false//是否已经获得本周的数据
let data : { time : Date, data : any[] }[] = []//收入支出列表
let budgetData : any[] = []//分类预算列表

export const getMWData = async (change : boolean = false, date : string, search : string = '', type : 'month' | 'work' = 'month', hasBudget : boolean = false) => {
	let budget : any = {}
	if (hasBudget) {
		budget = await request({
			url: '/budget',
			data: {
				time: date,
				userid: uni.getStorageSync('user')?.id
			}
		})
		budgetData = budget.data
		if (type === 'month') {
			mBudget = 0
		} else {
			wBudget = 0
		}
		budgetData.map(item => {
			if (type === 'month') {
				mBudget += +item.money
			} else {
				wBudget += +item.money
			}
		})

	}
	if ((!hasMonth && type === 'month') || (!hasWork && type === 'work') || search || change) {
		let res = await request({
			url: '/expenditure',
			data: {
				time: date,
				userid: uni.getStorageSync('user')?.id,
				search
			},

			method: 'GET',

		})

		if (type === 'month') {
			mIncome = 0
			mExpenditure = 0
			hasMonth = true
			// allMonthMoney = 0
			allMonth = 0
		} else {
			wIncome = 0
			wExpenditure = 0
			hasWork = true
			// allWMoney = 0
		}

		const tempDate : { time : Date, data : any[] }[] = [];
		(res as any)?.data.map(item => {
			if (item.type === '1') {

				if (type === 'month') {
					mIncome += +item.money
					// allMonthMoney += +item.money
					allMonth+= +item.money
				}

				else {
					wIncome += +item.money
					// allWMoney += +item.money
				}
			} else {

				if (type === 'month') {
					mExpenditure += +item.money
					// allMonthMoney -= +item.money
					allMonth -=+item.money
				}
				else {
					wExpenditure += +item.money
					// allWMoney -= +item.money
				}
			}
			if (new Date(item.time).getDate() !== new Date(tempDate.slice(-1)?.[0]?.time).getDate()) {
				tempDate.push({
					time: new Date(item.time),
					data: [{
						...item
					}]
				})
			} else {
				tempDate.slice(-1)[0].data.push(item)
			}
		})

		data = tempDate

	}
	if (type === 'month') {
		allMonthMoney = mBudget - mExpenditure
	} else {
		allWMoney = wBudget - wExpenditure
	}
	let exec = /([0-9]{4})年([0-9]{1,2})月/.exec(date)
	return {
		mExpenditure,
		mIncome,
		mBudget,
		categoryExpenditure,
		wExpenditure,
		wIncome,
		wBudget,
		data,
		allMonthMoney,
		allMonth,
		allWMoney,
		averaW: (allWMoney / 7).toFixed(2),
		averaM: (allMonthMoney / getMonthDay(+exec[1], +exec[2])).toFixed(2),
		budgetData
	}
}
export function getMonthDay(year : number, month : number) {
	const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if ((year % 4 === 0) && (year % 100 !== 0 || year % 400 === 0)) {
		days[1] = 29
	}
	return days[month - 1]
}
export function getWeekDataList(data : string) {
	//根据日期获取本周周一~周日的年-月-日
	var weekList = ['1'];
	var date = new Date(data);
	//判断本日期是否为周日，获取本周一日期
	if (date.getDay() === 0) {
		date.setDate(date.getDate() - 6);
	} else {
		date.setDate(date.getDate() - date.getDay() + 1);
	}
	var myDate = String(date.getDate());
	var myMonth = String(date.getMonth() + 1);
	if (date.getDate() < 10) {
		myDate = '0' + myDate;
	}
	if (date.getMonth() + 1 < 10) {
		myMonth = '0' + myMonth;
	}
	weekList = []
	weekList.push(String(date.getFullYear()) + "-" + myMonth + "-" + myDate);
	// 获取周二以后日期
	for (var i = 0; i < 6; i++) {
		date.setDate(date.getDate() + 1);
		myDate = String(date.getDate());
		myMonth = String(date.getMonth() + 1);
		if (date.getDate() < 10) {
			myDate = '0' + myDate;
		}
		if (date.getMonth() + 1 < 10) {
			myMonth = '0' + myMonth;
		}
		weekList.push(date.getFullYear() + "-" + myMonth + "-" + myDate);
	}

	return weekList
}