<template>
	<view class="content">
		<view class="left" @click="back">
			<uni-icons type="left" color="#fff" size="20"></uni-icons>
			<text class="text">返回</text>
		</view>
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar>

			<view class="title flex">

				<picker :range="[YearRange,monthRange]" mode="multiSelector" :value="getPickerValue" @change="timeChange">

					<text>{{selectTime}}的收支概况</text>
					<!-- 	<view class="calendar m-l-10">
							<uni-datetime-picker type="date" :clear-icon="false" v-model="selectTime" />
						</view> -->


				</picker>

			</view>


		</uni-nav-bar>

		<view class="box m-t-2">
			<view class="top">
				<text class="text">本月结余</text>
				<text class="text">￥{{allMoney}}</text>
			</view>

			<view class="flex box-item m-t-1">
				<text class="text">支出</text>
				<view class="bar" :style="'width:'+(zMoney/(zMoney+sMoney)*70)+'vw;'"></view>
				<view class="text">-￥{{zMoney}}</view>
			</view>
			<view class="flex box-item">
				<text class="text">收入</text>
				<view class="bar" :style="'width:'+(sMoney/(zMoney+sMoney)*70)+'vw;'"></view>
				<view class="text">￥{{sMoney}}</view>
			</view>
		</view>
		<view class="box m-t-2">
			<view class="top">
				<text class="text">支出趋势概况</text>
			</view>
			<hr>
			<view class="m-t-1">
				<text>本月内单日最高支出</text>
			</view>
			<view>
				<text>在
					<text class="red">{{data.max&&data.max.time}}</text>
					这一天，你支出了
					<text class="red">￥{{data.max&&data.max.money}}</text>
				</text>
			</view>
			<view class="m-t-2">
				<text class="a1">本月内平均每日支出</text>
				<text>&nbsp;&nbsp;￥{{data.average}}</text>

			</view>
			<view>
				<text class="a1">本月内累计支出笔数</text>
				<text>&nbsp;&nbsp;{{data.count}}笔</text>
			</view>
			<charts :chartData="chartDataLine" type="line" :opts="optsLine"></charts>
		</view>
		<view class="box m-t-2">
			<view class="top">
				<text class="text">支出占比概况</text>
			</view>
			<hr>

			<charts type="pie" :chartData="chartDataPie" class="m-t-2"></charts>
		</view>
		<view class="box m-t-2">
			<view class="top">
				<text class="text">支出类目排行</text>
			</view>
			<hr>
			<view v-for="(category,index) in data.category" :key="category.typeid" class="flex-cen m-t-1">
				<uni-icons type="image" :size="40" color="#ffbcc9" />
				<view class="item m-l-4">
					<text>{{category.name}}</text>
					<view class="han" :style="{background:color[(index)%9]}"></view>
					<view class="flex">
						<text class="a1">本月共支出￥{{category.sum}}</text>
						<text class="a1">消费{{category.count}}笔</text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import charts from '@/pages/comm/echarts.vue'
	import {
		transformCn,
		transformCnDay
	} from '@/public/transform.ts'
	import {
		getMWData
	} from '@/public/data.ts'
	import {
		computed,
		reactive,
		ref
	} from "vue";
	import {
		request
	} from '@/public/request.ts'
	import dataVue from '@/pages/comm/data'
	import {
		getMonthDay,
		getWeekDataList
	} from '../../public/data';
	import {
		transformMonthDate
	} from '../../public/transform';
	export default {
		components: {
			dataVue,
			charts
		},
		onLoad() {},
		onShow() {

			this.getData()
		},
		setup() {
			const selectTime = ref(transformCn(new Date()))
			const year = ref(new Date().getFullYear())
			const month = ref(new Date().getMonth() + 1)
			const YearRange = ref([])
			const monthRange = ref([])
			const allMoney = ref(0)
			const zMoney = ref(0)
			const sMoney = ref(0)
			const data = reactive({})
			const chartDataLine = ref({})
			const chartDataPie = ref({})
			const optsLine = ref({})
			for (let i = 1873; i <= 2173; i++) {
				YearRange.value.push(i)
			}
			for (let i = 1; i <= 12; i++) {
				monthRange.value.push(i)
			}
			const getPickerValue = computed(() => {
				const exec = /([0-9]{4})年([0-9]{1,2})月/.exec(selectTime.value)
				if (exec) {
					return [exec[1] - 1873, exec[2] - 1]
				}

			})

			function back() {
				uni.switchTab({
					url: '/pages/tabbar/tabbar-1/tabbar-1'
				})
			}

			function goToPage(url = '') {

				uni.navigateTo({
					url: url || '/pages/tabbar-3-detial/tabbar-3-qa/tabbar-3-qa'
				})
			}

			function timeChange(e) {

				selectTime.value = YearRange.value[e.detail.value[0]] + '年' + monthRange.value[e.detail.value[1]] + '月'
				year.value = YearRange.value[e.detail.value[0]]
				month.value = monthRange.value[e.detail.value[1]]
				getData(true)
			}

			function getData(hasChange = false) {
				getMWData(hasChange, selectTime.value).then(res => {
					allMoney.value = res.allMonth
					sMoney.value = res.mIncome
					zMoney.value = res.mExpenditure
				})
				request({
					url: '/expenditure/overview',
					data: {
						userid: '1',
						startTime: `${year.value}-${month.value}-01`,
						endTime: `${year.value}-${month.value}-${getMonthDay(year.value,month.value)}`,
					}
				}).then(res => {
					chartDataLine.value = {
						categories: [],
						series: [{
							name: '支出',
							data: []
						}]
					}
					for (let i = 1; i <= getMonthDay(year.value, month.value); i++) {

						chartDataLine.value.categories.push(i % 5 === 0 || i === 1 ? i : '')
						chartDataLine.value.series[0].data.push('')
					}
					data.max = {
						time: '',
						money: 0
					}
					data.average = 0
					data.count = 0

					res.data.data1.map(item => {
						data.average += item.avg
						data.count += item.count
						chartDataLine.value.series[0].data[new Date(item.time).getDate() - 1] = item.sum
						if (item.sum >= data.max.money) {
							data.max = {
								time: transformMonthDate(new Date(item.time)),
								money: item.sum
							}
						}
					})
					chartDataPie.value = {
						series: [{
							data: []
						}]
					}
					let allMoney = 0
					data.category = res.data.data2
					res.data.data2.map(item => {
						allMoney += item.sum
						chartDataPie.value.series[0].data.push({
							name: item.name,
							value: item.sum
						})
					})
					chartDataPie.value.series[0].data = chartDataPie.value.series[0].data.map(item => {
						return {
							name: item.name,
							value: item.value / allMoney * 100
						}
					})
					console.log(chartDataLine.value, chartDataPie.value)
					data.average = Math.floor(data.average / res.data.data1.length * 100) / 100
				})
			}


			return {
				data,
				selectTime,
				goToPage,
				back,
				getData,
				allMoney,
				sMoney,
				zMoney,
				YearRange,
				monthRange,
				timeChange,
				getPickerValue,
				chartDataLine,
				optsLine,
				chartDataPie,
				color: ["#1890FF", "#91CB74", "#FAC858", "#EE6666", "#73C0DE", "#3CA272", "#FC8452", "#9A60B4", "#ea7ccc"],

			}
		}
	};
</script>

<style lang="scss" scoped>
	.content {
		text-align: center;
		// height: 100vh;
		padding: 0 10px;

		.red {
			color: red;
		}

		.a1 {
			color: #a1a1a1;
		}

		.left {
			margin-left: 10px;
			position: fixed;
			z-index: 999;
			line-height: 88rpx;
			color: white;
			display: flex;
		}

		::v-deep .uni-navbar__header-container {
			justify-content: center;
		}

		.box {
			border: 2px solid #000;
			// margin-top: 10px;
			padding: 20px;
			border-radius: 10px;

			.item {
				text-align: left;
				width: 100%;

				.han {
					width: 100%;
					height: 8px;
					border-radius: 10px;
					margin-top: 1vh;
					margin-bottom: 1vh;

				}

				.flex {
					justify-content: space-between;
				}
			}

			.top {
				display: flex;
				justify-content: space-between;
				margin-bottom: 2vh;

				.text:first-child {
					font-weight: 600;
					font-size: 18px;

				}

				.text:nth-child(2) {
					font-size: 22px;
					color: red;
					// color: #ccc;
				}
			}

			.box-item {
				margin-bottom: 1vh;
				position: relative;

				.text {
					font-size: 4vw;

				}

				.text:last-child {
					position: absolute;
					left: 35vw;
					bottom: 2px;
				}

				.bar {
					width: 10vw;
					/* margin-right: 2vw; */
					margin-left: 2vw;
					height: 2vh;
					background: #ffa829;
					border-radius: 10px;

					&::before {
						height: 2vh;
						width: 70vw;
						background-color: #fbca8161;
						border-radius: 10px;

						content: ' ';
						display: block;
					}
				}
			}

			.bottom-text {
				font-weight: 600;

			}
		}

		.title {
			font-size: 16px;
			line-height: 88rpx;
		}

		::v-deep .uni-date {
			height: 44px;
			line-height: 44px;
		}

	}
</style>