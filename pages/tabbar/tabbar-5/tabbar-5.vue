<template>
	<view class="content">
		<view class="bg">
			<view class="top">
				<uni-icons type="gear-filled" size="30" color="$uni-color-warning" @click="settingClick"></uni-icons>
			</view>

			<img :src="user.avter||'../../../static/img/avter.png' " alt="" srcset="">

			<view class="m-t-1" @click="gotoPage">
				<text class="m-r-10">{{user.username||'用户xxx'}}</text>
				<svg t="1695432830038" class="icon" viewBox="0 0 1024 1024" version="1.1"
					xmlns="http://www.w3.org/2000/svg" p-id="2312" width="16" height="16">
					<path
						d="M775.84 392.768l-155.2-172.352L160.768 643.264l-38.368 187.936 190.56-12.832zM929.952 229.952l-131.2-150.944-0.288-0.32a16 16 0 0 0-22.592-0.96l-131.168 120.576 155.168 172.352 128.832-118.464a15.936 15.936 0 0 0 1.248-22.24zM96 896h832v64H96z"
						p-id="2313" fill="#ea9518"></path>
				</svg>
			</view>
			<view class="flex-cen m-t-2">
				<text>记账天数{{day}}</text>
				<view class="su m-l-10 m-r-10 "></view>
				<text>记账笔数{{times}}</text>
			</view>

		</view>

		<uni-list :border="true">
			<uni-list-chat :clickable="true" v-for="item in list" :title="item.text"
				avatar="../../../static/img/avter.png" :key="item.text" note="" @click="change(item)">
				<view class="chat-custom-right">
					<uni-icons type="image" :size="40" color="#f0ad4e" />
				</view>
			</uni-list-chat>
		</uni-list>
		<uni-popup ref="popup" type="dialog">
			<uni-popup-dialog ref="inputClose" mode="input" title="设置密码锁住,不让别人看" placeholder="请输入密码"
				@confirm="dialogInputConfirm"></uni-popup-dialog>
		</uni-popup>
	</view>
</template>

<script>
	import {
		list,
		avatarList
	} from './data.ts'
	import {
		request
	} from '@/public/request'
	export default {
		data() {
			return {
				day: 0,
				times: 0,
				list,
				avatarList,
				user: {},
				password: ''
			}
		},
		onLoad() {


		},
		onShow() {
			request({
				url: '/expenditure/dayTimes',
				data: {
					userid: uni.getStorageSync('user')?.id
				}
			})?.then(res => {
				this.day = res.data.day
				this.times = res.data.times
			})
			uni.getStorage({
				key: 'user',
				success: (data) => {

					this.user = data.data
				}
			})
		},
		mounted() {
			uni.preloadPage({
				url: '/pages/my/billScan/index'
			});
			uni.preloadPage({
				url: '/pages/my/regularBookkeeping/index'
			});
			uni.preloadPage({
				url: '/pages/budget/index'
			});
			uni.preloadPage({
				url: '/pages/my/export'
			});
			uni.preloadPage({
				url: '/pages/my/umbrellaUsers'
			});
			uni.preloadPage({
				url: '/pages/my/editUser'
			})
		},
		methods: {
			dialogInputConfirm(e) {

				uni.setStorageSync('password', e)
			},
			gotoPage() {
				uni.navigateTo({
					url: '/pages/my/editUser'
				})
			},
			change(e) {

				if (e.badge === '1') {
					this.$refs.popup.open()
					return
				}
				uni.navigateTo({
					url: e.url
				})
			},
			showDrawer(e) {
				this.$refs[e].open()
			},
			// 关闭窗口
			closeDrawer(e) {
				this.$refs[e].close()
			},
			settingClick() {
				uni.showModal({
					title: '退出登录？',
					success: (data) => {
						console.log(data, 'dtaa')
						if (data.confirm) {
							uni.removeStorage({
								key: 'user'
							})
							uni.navigateTo({
								url: '/pages/login/index'
							})
						}

					},
					fail: (err) => {
						uni.showToast({
							title: err,
							icon: 'none'
						})
					}
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.content {
		text-align: center;
		// height: ;
		min-height: calc(100vh - 50px);
		background-color: $uni-bg-color-grey;


		.bg {
			background-color: #ffef76;
			display: flex;
			flex-direction: column;
			padding: 20px;
			align-items: center;
			border-radius: 10px;
			border-top-left-radius: 0;
			border-top-right-radius: 0;

			.top {
				display: flex;
				justify-content: flex-end;
				width: 100%;

				.uniui-gear-filled {
					color: $uni-color-warning;
					width: 30px;
				}
			}

			.su {
				width: 1px;
				height: 16px;
				background-color: #19170c;
			}

			img {
				width: 50px;
				height: 50px;
				border-radius: 50%;
			}
		}

		.uni-section {
			width: 94%;
			margin: auto;
			margin-top: 20px;

			::v-deep .uni-section-header {
				display: none;
			}
		}

		.grid-item-box {
			display: flex;
			flex-direction: column;
			justify-content: center;
			height: 100%;

			.uni-icons {
				color: #ffbcc9 !important;
			}
		}

		::v-deep .uni-grid-item--border-top {
			border: 0 !important;
		}

		::v-deep .uni-grid-item--border {
			border: 0 !important;
		}

		::v-deep .uni-grid--border {
			border: 0 !important;
		}

		::v-deep .uni-grid-item {
			width: calc(100% / 4) !important;
		}

		.uni-list {
			width: 94%;
			margin: auto;
			// margin-top: 20px;
			background-color: rgba(0, 0, 0, 0);

			::v-deep .uni-list-chat {
				margin-top: 10px;
			}

			::v-deep .uni-list-chat__content-title {
				line-height: 45px;
				font-size: 20px;
			}

			::v-deep .uni-list--border-top {
				display: none;
			}

		}
	}
</style>