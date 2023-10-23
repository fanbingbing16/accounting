// const baseurl = 'http://103.152.132.87:3000'
 const baseurl ='http://localhost:3000'
export  function  request(data : { url : string, data : any, header? : any, method ?: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'HEAD' | 'OPTIONS', dataType ?: string, timeout ?: number,mustLogin?:boolean }) {
	
	if(data.mustLogin!==false){
		try {
			const value = uni.getStorageSync('user');
			if (!value.id) {
				uni.navigateTo({
					url:'/pages/login/index'
				})
				return new Promise((resolve,reject)=>{reject()})
			}
		} catch (e) {
			// error
			uni.navigateTo({
				url:'/pages/login/index'
			})
			return new Promise((resolve,reject)=>{reject()})
		}
	}
	return new Promise((resolve, reject) => {
		uni.request({
			url: baseurl + data.url,
			data: data.data,
			method: data.method || 'GET',
			timeout: data.timeout || 20000,
			success: (option) => {
				
				if ((option.data as any)?.status === 0||!(option.data as any)?.status) {
					
					uni.showToast({
						title: (option.data as any)?.msg,
						icon: 'none'
					})
					reject(option.data)

				} else
					resolve(option.data)
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