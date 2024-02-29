export function accAdd(arg1, arg2) {
	var r1, r2, m

	try {
		r1 = arg1.toString().split('.')[1].length + 1
	} catch (e) {
		r1 = 0
	}

	try {
		r2 = arg2.toString().split('.')[1].length + 1
	} catch (e) {
		r2 = 0
	}

	m = Math.pow(10, Math.max(r1, r2))

	return (arg1 * m + arg2 * m) / m
}
export function accSub(arg1, arg2) {
	var r1, r2, m, n

	try {
		r1 = arg1.toString().split('.')[1].length + 1
	} catch (e) {
		r1 = 0
	}

	try {
		r2 = arg2.toString().split('.')[1].length + 1
	} catch (e) {
		r2 = 0
	}

	m = Math.pow(10, Math.max(r1, r2))

	n = Math.max(r1, r2)
	return ((arg1 * m - arg2 * m) / m).toFixed(n >= 1 ? n - 1 : 0)
}

export function accChu(arg1, arg2) {
	var r1, r2, m, n

	try {
		r1 = arg1.toString().split('.')[1].length + 1
	} catch (e) {
		r1 = 0
	}

	try {
		r2 = arg2.toString().split('.')[1].length + 1
	} catch (e) {
		r2 = 0
	}

	m = Math.pow(10, Math.max(r1, r2))

	n = Math.max(r1, r2)
	return (((arg1 * m) / (arg2 * m)) / m).toFixed(2)
}