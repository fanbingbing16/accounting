<template>
	<view class="login">
		<view class="top">
			<view class="login-top">
				<img src="../../static/img/avter.png" class="image" />
				<h2 class="m-t-2">登录</h2>
			</view>

		</view>
		<uni-forms :modelValue="formData" :rules="rules" label-position="top" class="m-t-4" :ref="getForm">
			<uni-forms-item required label="姓名" name="name">
				<uni-easyinput type="text" v-model="formData.name" placeholder="请输入姓名" />
			</uni-forms-item>
			<uni-forms-item required name="password" label="密码">
				<uni-easyinput type="password" v-model="formData.password" placeholder="请输入密码" maxlength="16" step />
			</uni-forms-item>
		</uni-forms>
		<p>未注册的用户登录则默认注册</p>
		<button type="primary" class="button m-t-4" @click="login">登录</button>
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
				password: ''
			})
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
				password: {
					rules: [{
							required: true,
							errorMessage: '密码不能为空'
						},
						{
							validateFunction: function(rule, value, data, callback) {
								if (value.length < 6) {
									callback('密码必须填写六个字符以上')
								}
								return true
							}
						}
					]
				}
			})

			function getForm(e) {
				form.value = e
			}

			function login() {
				form.value.validate().then(res => {
					console.log('success', res);
					request({
						url: '/login',
						method: 'POST',
						data: {
							username: formData.name,
							password: formData.password,

						},
						mustLogin: false
					}).then(res => {
						console.log(res,'res')
						uni.showToast({
							title: '登录成功',
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
				getForm
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