
import {
	transformCn,transformNoTime
} from './transform.ts'
export function checkNumber(data) {
	if (typeof data === 'number') return true
	if ([true, false, null].includes(data)) return false
	return !isNaN(+data)
}
//字符串
export function checkDate(data) {
	if (checkNumber(data)) return false
	const today = new Date()
	data = data.replace('昨天', transformCn(new Date(today.setDate(today.getDate() - 1)), 'work'))
	data = data.replace('今天', transformCn(new Date(), 'work'))
	const valid = parseAndValidateDateTime(data)
	if(valid.isValid) return valid
	if (isNaN(Date.parse(data)) ) return false
	return {valid:true,text:transformNoTime(new Date(data)),format:'YYYY-MM-DD'}

}
export function parseAndValidateDateTime(dateTimeString) {
	// 定义正确的日期时间格式的正则表达式
	const fullYearRegex = /(\d{4})年(\d{1,2})月(\d{1,2})[号||日]/

	const fullYearRegex2 = /(\d{4})年(\d{1,2})月(\d{1,2})[号||日](\s)*(\d{1,2}):(\d{1,2})/
	const shortYearMonthRegex = /(\d{1,2})-(\d{1,2})(\s)*(\d{1,2}):(\d{1,2})/
	const shortYearMonthNumberRegex = /(\d{1,2})-(\d{1,2})(\s)*(\d{1,2})(\d{1,2})/
	const shortMonthDayRegex = /(\d{1,2})月(\d{1,2})[号||日](\s)*(\d{1,2})[:\.]{0,1}(\d{1,2})/
	const fullYearWithNumberRegex = /(\d{4})年(\d{1,2})月(\d{1,2})[号||日](\s)*(\d{1,2})(\d{1,2})/

	// 尝试匹配并转换日期时间字符串
	if (fullYearRegex2.test(dateTimeString)) {
		const [, year, month, day, , hours, minutes] = fullYearRegex2.exec(dateTimeString)
		dateTimeString =
			`${year}年${month.padStart(2, '0')}月${day.padStart(2, '0')}日 ${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'fullYearRegex2',
			formate: 'YYYY年MM月DD日 HH:mm'
		}
	} else if (fullYearWithNumberRegex.test(dateTimeString)) {
		// 时间和分钟之间缺少冒号，添加冒号并转换为正确格式
		const [, year, month, day, , hours, minutes] = fullYearWithNumberRegex.exec(dateTimeString)
		dateTimeString =
			`${year}年${month.padStart(2, '0')}月${day.padStart(2, '0')}日 ${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'fullYearWithNumberRegex',
			formate: 'YYYY年MM月DD日 HH:mm'
		}
	} else if (fullYearRegex.test(dateTimeString)) {
		const [, year, month, day] = fullYearRegex.exec(dateTimeString)
		dateTimeString = `${year}年${month.padStart(2, '0')}月${day.padStart(2, '0')}日`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'fullYearRegex',
			formate: 'YYYY年MM月DD日'
		}
	} else if (shortYearMonthRegex.test(dateTimeString)) {
		const [, month, day, , hours, minutes] = shortYearMonthRegex.exec(dateTimeString)
		const currentYear = new Date().getFullYear()
		dateTimeString =
			`${currentYear}-${month.padStart(2, '0')}-${day.padStart(2, '0')} ${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'shortYearMonthRegex',
			formate: 'YYYY-MM-DD HH:mm'
		}
	} else if (shortYearMonthNumberRegex.test(dateTimeString)) {
		const [, month, day, , hours, minutes] = shortYearMonthNumberRegex.exec(dateTimeString)
		const currentYear = new Date().getFullYear()
		dateTimeString =
			`${currentYear}-${month.padStart(2, '0')}-${day.padStart(2, '0')} ${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'shortYearMonthNumberRegex',
			formate: 'YYYY-MM-DD HH:mm'
		}
	} else if (shortMonthDayRegex.test(dateTimeString)) {
		const currentYear = new Date().getFullYear()

		const [, month, day, , hours, minutes] = shortMonthDayRegex.exec(dateTimeString)
		dateTimeString =
			`${currentYear}年${month.padStart(2, '0')}月${day.padStart(2, '0')}日 ${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`
		return {
			isValid: true,
			text: dateTimeString,
			type: 'shortMonthDayRegex',
			formate: 'YYYY年MM月DD日 HH:mm'
		}
	}

	// 如果不匹配任何格式，返回false
	return {
		isValid: false,
		text: dateTimeString
	}
}