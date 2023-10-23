<template>
	<view class="login">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="修改用户信息" @clickLeft="back" />
		<!-- <view class="top">
			<view class="login-top">
				<h2 class="m-t-2">修改用户信息</h2>
			</view>

		</view> -->
		<uni-forms :modelValue="formData" :rules="rules" label-position="top" class="m-t-4" :ref="getForm">
			<uni-forms-item required label="姓名" name="name">
				<uni-easyinput type="text" v-model="formData.name" placeholder="请输入姓名" />
			</uni-forms-item>
			<uni-forms-item label="头像" name="avter">
				<uni-file-picker limit="1" :del-icon="false" disable-preview :auto-upload="false" file-mediatype="image"
					v-model="formData.avter" @select="select"></uni-file-picker>
			</uni-forms-item>
		</uni-forms>

		<button type="primary" class="button m-t-4" @click="login">提交</button>
	</view>
</template>
<script>
	import {
		reactive,
		ref
	} from "vue"
	import {
		request
	} from "../../public/request"
	export default {
		setup() {
			const formData = reactive({
				name: '',
				avter: [{
					name: 'user',
					extname: 'jpg',
					url: ''
				}],
				// [{name:'user',extname:'jpg',url:''}]
			})
			const user = uni.getStorageSync('user')
			formData.name = user.username
			if (user.avter)
				formData.avter[0].url = user.avter || ''
			else {
				formData.avter = []
			}
			console.log(user, formData, 'user formdta ')
			const form = ref(null)
			const rules = reactive({
				name: {
					rules: [{
							required: true,
							errorMessage: '用户名不能为空'
						},
						{
							validateFunction: function(rule, value, data, callback) {
								if (value.length < 4) {
									callback('用户名必须填写四个字符以上')
								}
								return true
							}
						}
					]
				},
				avter: {
					rules: []
				}
			})

			function select(e) {
				console.log(e.tempFiles[0].size,e.tempFiles[0].size/1024,'e.tempFiles[0].size')
				if(e.tempFiles[0].size/1024>=400){
					formData.avter = []
					return uni.showToast({
						title:'图片只能传小于400kb的',
						icon:'none'
					})
				}
				console.log(e, 'select')
				const file = new FileReader();
				file.readAsDataURL(e.tempFiles[0].file);
				file.onload = function() {
					console.log(file.result);
					formData.avter[0] = {
						url: file.result,
						extname: e.tempFiles[0].extname,
						name: e.tempFiles[0].name
					}
				}
			}

			function getForm(e) {
				form.value = e
			}

			function back() {
				uni.switchTab({
					url: '/'
				})
			}

			function login() {
				form.value.validate().then(res => {
					console.log('success', res);
					request({
						url: '/login/edit',
						method: 'POST',
						data: {
							username: formData.name,
							avter: formData.avter[0]?.url || '',
							userid: uni.getStorageSync('user')?.id

						},
						mustLogin: false
					}).then(res => {
						console.log(res, 'res')
						uni.showToast({
							title: '修改成功',
							icon: 'success'
						})
						uni.setStorage({
							key: 'user',
							data: {
								...res.results[0],
								password: null
							},
						})
						setTimeout(() => {
								uni.switchTab({
									url: '/'
								})
							},
							1000)
					})
				}).catch(err => {
					console.log('err', err);
				})
			}
			return {
				formData,
				login,
				rules,
				getForm,
				select,
				back
			}
		},
	}
</script>
<style lang="scss" scoped>
	.login {
		padding: 0 20px;
		text-align: center;
		color: #ccc;

		.button {
			background-color: $uni-color-warning;
		}

		.top {
			height: 34vh;
			display: flex;
			align-items: center;
			justify-content: center;

			.login-top {
				display: flex;
				align-items: center;
				justify-content: center;
				flex-direction: column;
				color: darkblue;

				.image {
					border-radius: 100%;
					width: 50px;
				}
			}

		}

	}
</style>