export function accAdd(num1, num2) {
	// 将数字转为字符串  
	const str1 = num1.toString();
	const str2 = num2.toString();

	// 找到小数点的位置  
	const dotIndex1 = str1.indexOf('.');
	const dotIndex2 = str2.indexOf('.');

	// 分割整数部分和小数部分  
	let integerPart1 = dotIndex1 === -1 ? str1 : str1.substring(0, dotIndex1);
	let decimalPart1 = dotIndex1 === -1 ? '0' : str1.substring(dotIndex1 + 1);
	let integerPart2 = dotIndex2 === -1 ? str2 : str2.substring(0, dotIndex2);
	let decimalPart2 = dotIndex2 === -1 ? '0' : str2.substring(dotIndex2 + 1);

	// 确保小数部分长度相同，不够的补0  
	const maxLength = Math.max(decimalPart1.length, decimalPart2.length);
	decimalPart1 = decimalPart1.padEnd(maxLength, '0');
	decimalPart2 = decimalPart2.padEnd(maxLength, '0');

	// 初始化进位  
	let carry = 0;
	let resultDecimal = ''; // 存储小数部分的结果  
	let resultInteger = ''; // 存储整数部分的结果  

	// 先计算小数部分  
	for (let i = maxLength - 1; i >= 0; i--) {
		const sum = parseInt(decimalPart1[i]) + parseInt(decimalPart2[i]) + carry;
		resultDecimal = (sum % 10) + resultDecimal; // 取个位数  
		carry = Math.floor(sum / 10); // 计算进位  
	}
	if (carry > 0) { // 如果最后还有进位，需要添加到结果的最前面  
		resultInteger = String(carry);
	}

	// 计算整数部分  
	carry = 0; // 重置进位  
	const maxLengthInteger = Math.max(integerPart1.length, integerPart2.length);
	integerPart1 = integerPart1.padStart(maxLengthInteger, '0'); // 不够位数前面补0  
	integerPart2 = integerPart2.padStart(maxLengthInteger, '0');
	for (let i = maxLengthInteger - 1; i >= 0; i--) {
		const sum = parseInt(integerPart1[i]) + parseInt(integerPart2[i]) + carry;
		if (i === maxLengthInteger - 1 && resultInteger > 0) {
			resultInteger = sum + Number(resultInteger)
			if (resultInteger >= 10) {
				carry = Math.floor(resultInteger / 10)
				resultInteger = String(resultInteger % 10)

			} else {
				resultInteger = String(resultInteger)
			}
		} else {
			resultInteger = (sum % 10) + resultInteger; // 取个位数  
			carry = Math.floor(sum / 10); // 计算进位  
		}
	}
	if (carry > 0) { // 如果最后还有进位，需要添加到结果的最前面  
		resultInteger = carry + resultInteger;
	}
	// 合并结果  
	if (resultInteger === '') {
		resultInteger = '0';
	}
	if (resultDecimal !== '') {
		return Number(resultInteger + '.' + resultDecimal)
	} else {
		return +resultInteger;
	}
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
	return Number(((arg1 * m - arg2 * m) / m).toFixed(n >= 1 ? n - 1 : 0))
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