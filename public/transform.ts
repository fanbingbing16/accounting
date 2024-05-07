export const transform = (date : Date) => {
	return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')} ${String(date.getHours()).padStart(2,'0')}:${String(date.getMinutes()).padStart(2,'0')}:${String(date.getSeconds()).padStart(2,'0')}`
}
export const transformNoTime= (date : Date) => {
	return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`
}
export const transformMonthDate = (date : Date) => {
	return `${date.getMonth() + 1}-${date.getDate()}`
}
export const isToday = (date : Date) => {

	const now = new Date()
	if (date.getFullYear() !== now.getFullYear()) return false
	if (date.getMonth() !== now.getMonth()) return false
	if (date.getDate() !== now.getDate()) return false
	return true
}
export const transformCn = (date : Date, type : 'month' | 'work' = 'month') => {

	return `${date.getFullYear()}年${date.getMonth() + 1}月${type === 'work' ? date.getDate() + '日' : ''}`
}
export const transformCnDay = (date : Date) => {
	return `${date.getMonth() + 1}.${date.getDate()} ${getDay(date.getDay())}`
}
function getDay(num : number) {
	return ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'][num]
}