const transformSE = (date) => {
	let date1 = ''
	let date2 = ''
	if (typeof date === 'string') {
		const exec = /([0-9]{4})年([0-9]{1,2})月/.exec(date)
		const exec2 = /([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日/.exec(date)
		if (exec2) {
			let weekList = getWeekDataList(`${exec2[1]}-${exec2[2]}-${exec2[3]}`)
			date1 = weekList[0]
			date2 = weekList[6]
		}
		else if (exec) {
			date1 = `${exec[1]}-${exec[2]}-01`
			date2 = `${exec[1]}-${exec[2]}-${getMonthDay(+exec[1], +exec[2])}`

		}
	}
	return {
		start: date1,
		end: date2

	}
}
function getMonthDay(year, month) {
	const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if ((year % 4 === 0) && (year % 100 !== 0 || year % 400 === 0)) {
		days[1] = 29
	}
	return days[month - 1]
}
function getWeekDataList(data) {
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
module.exports = transformSE