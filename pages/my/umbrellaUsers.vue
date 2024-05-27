<template>
	<view class="umbrella-users">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="伞下用户" @clickLeft="back" />
		<view class="flex m-t-3">
			<view class="bottom-text flex" style="width: 14%;">
				<text>头像</text>
				<view class="shu m-l-4"></view>
			</view>
			<view class="bottom-text flex" style="width: 56%;">
				<text>用户昵称</text>
				<view class="shu m-l-4">
			</view>
			</view>
			<view class="bottom-text flex" style="width: 14%;"> 
				<text>收益</text>
				<view class="shu m-l-4"></view>
			</view>
			<view class="bottom-text">
				<text>可获得</text>
			</view>
		</view>

		<view class="list">
			<view class="flex list-item" v-for="(item2,index2) in users" :key="item2.id">
				<view class="flex-cen">
					<img :src="item2.avter||'../../../static/img/avter.png' " alt="" srcset="" class="avater">
					<text class="text" style="width: 63%;">{{item2.username}}</text>
					<text class="text">{{item2.money}}</text>
					<text class="text">{{item2.money*0.3}}</text>
				</view>
			</view>
		</view>
		<view class="no-data" v-if="users.length===0">
			<img src="../../static/img/miao/3.png" alt="" srcset="" class="img">
			<text>暂无数据</text>
		</view>

	</view>
</template>
<script>
	import {
		request
	} from '@/public/request'
	import {
		ref
	} from 'vue'
	export default {
		mounted() {
			uni.preloadPage({url: "/"});
		},
		setup() {
			const users = ref([])

			function back() {
				uni.switchTab({
					url: '/'
				})
			}
			const user = uni.getStorageSync('user')
			request({
				url: '/login/users',
				data: {
					parent: user.code
				}
			}).then(res => {
				users.value = res.results
				console.log(res, 'res', users.value)
			})
			return {
				back,
				users,
				user
			}
		},
	}
</script>
<style lang="scss" scoped>
	.umbrella-users {
		text-align: center;
		// height: 100vh;
		padding: 0 10px;



		.bottom-text {
			font-weight: 600;

		}

		.avater {
			width: 10%;
			border-radius: 100%;
			margin-right: 10px;
		}

		.flex-cen {
			.text {
				width: 14%;
				text-align: left;
			}


		}

		.shu {
			width: 3px;
			height: 14px;
			background: #ffce82;
			margin-top: 4px;
			margin-right: 10px;
		}
	}

	.no-data {
		.img {
			width: 100%;
		}
	}

	.list {
		margin-top: 2vh;
		// background-image: url('../../../static/img/miao/2.png');

		.list-item {
			position: relative;
			padding: 4px;
			margin-top: 0.8vh;
			display: flex;
			justify-content: space-between;
			font-size: 16px;
			align-items: center;

			::v-deep .uni-icons {

				color: $uni-color-warning !important;
				margin-right: 10px;
			}

			.description {
				text-overflow: ellipsis;
				width: 10vw;
			}
		}

		.list-item:hover {
			background: #f3f3f3;
		}
	}
</style>