const baseurl = 'https://zhangyanling.top/api'
// const baseurl = 'http://localhost:3000/api'
interface dataObj {
	url : string, data : any, header ?: any, method ?: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'HEAD' | 'OPTIONS', dataType ?: string, timeout ?: number, mustLogin ?: boolean
}
const promiseData : any = {

}
const timeData : any = {}
function generateId(data : any) {
	let str : string = ''
	if (data.url) str += data.url
	if (data.data) {
		for (const key in data.data) {
			str += String(key)
			if (data.data[key]) str += JSON.stringify(data.data[key])
		}
	}

	return str
}
export function request(data : dataObj) {

	if (data.mustLogin !== false) {
		try {
			const value = uni.getStorageSync('user');
			if (!value.id) {

				uni.navigateTo({
					url: '/pages/login/index'
				})
				return new Promise((resolve, reject) => { reject() })
			}
			const pass = uni.getStorageSync('password')
			if (pass) {
				return new Promise((resolve, reject) => {
					uni.showModal({
						title: '屏幕已锁定',
						editable: true,
						placeholderText: '请输入解锁密码',
						success: (res) => {
							if (res.confirm) {
								if (res.content !== pass) {
									uni.showToast({
										title: '密码错误',
										icon: 'none'
									})
									reject()
								} else {
									uni.removeStorage({
										key: 'password'
									})
									console.log(pass, '123', data)
									resolve(requestPass(data))

								}
							}
						}
					})
				})
			} else {
				return requestPass(data)
			}
		} catch (e) {
			// error
			uni.navigateTo({
				url: '/pages/login/index'
			})
			return new Promise((resolve, reject) => { reject() })
		}
	} else {
		return requestPass(data)
	}

}
function requestPass(data : dataObj) {

	const id = generateId(data)


	return new Promise((resolve, reject) => {
		if (data.method === 'GET' || !data.method) {
			if (promiseData[id]) {
				resolve(promiseData[id])
				return
			}
		} else {
			
			if ( new Date().getTime()-timeData[id] <1000  && timeData[id]) {
				timeData[id] = new Date().getTime()
				uni.showToast({
					title: '请不要连续请求相同的内容',
					icon: 'none'
				})
				reject({})
				return
			}
			timeData[id] = new Date().getTime()
			const urls = data.url.split('/')
			for (const key in promiseData) {
				if (urls.some(url => key.includes(url))) {
					promiseData[key] = null
					delete promiseData[key]
				}
			}
		}

		console.log(data, 'data')
		if (data.data && !data.data?.userid) {
			data.data.userid = uni.getStorageSync('user')?.id
		}
		uni.request({
			url: baseurl + data.url,
			data: data.data,
			method: data.method || 'GET',
			timeout: data.timeout || 20000,
			success: (option) => {

				if ((option.data as any)?.status === 0 || !(option.data as any)?.status) {

					uni.showToast({
						title: (option.data as any)?.msg,
						icon: 'none'
					})
					reject(option.data)

				} else {
					promiseData[id] = option.data
					resolve(option.data)
				}

			},
			fail: (err) => {
				console.log(err, 'err')
				uni.showToast({
					title: '未知错误',
					icon: 'none'
				})
				reject(err)
			}
		})
	})
}