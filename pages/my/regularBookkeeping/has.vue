<template>
	<view class="regularBookkeeping">
		<view class="flex m-t-3">
			<view class="bottom-text flex">
				<text>起始日期</text>
				<view class="shu m-l-4"></view>
			</view>
			<view class="bottom-text flex" >
				<text>结束日期</text>
				<view class="shu m-l-4">
				</view>
			</view>

		</view>

		<view class="list">
			<view class="flex list-item" v-for="(item2,index2) in data" :key="item2.id">

				<text class="text">{{item2.start_time}}</text>
				<text class="text">{{item2.end_time}}</text>

				<button type="primary" size="mini" @click="changePage2(item2.id)">查看详情</button>

			</view>
		</view>
		<button class="button m-t-5" type="primary" @click="changePage">添加定时记账</button>
		
	</view>
</template>
<script>
	export default {
		props: {
			data: {
				type: Object,
				default: () => ({})
			}
		},
		setup() {

			const changePage = () => {
				uni.navigateTo({
					url: '/pages/incomeExpenditure/addScheduleTask'
				})
			}
			const changePage2 = (id) => {
				uni.navigateTo({
					url: '/pages/my/regularBookkeeping/detail?id='+id
				})
			}
			return {

				changePage,
				changePage2
			}
		},
	}
</script>
<style lang="scss" scoped>
	.regularBookkeeping {
		padding: 0 10px;
	}

	.bottom-text {
		font-weight: 600;
width: 37%;
	}




	.text {
		width: 37%;
		text-align: left;
		display: block;
	}




	.shu {
		width: 3px;
		height: 14px;
		background: #ffce82;
		margin-top: 4px;
		margin-right: 10px;
	}

	.list {
		margin-top: 2vh;
		// background-image: url('../../../static/img/miao/2.png');

		.list-item {
			margin-top: 0.8vh;
			/* display: flex; */
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