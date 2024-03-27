<template>
	<view class="budget">
		<view class="left" @click="back">
			<uni-icons type="left" color="#fff" size="20"></uni-icons>
			<text class="text">返回</text>
		</view>
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar>

			<view class="title flex">
				<picker :range="getRange()" mode="multiSelector" :value="getPickerValue" @change="timeChange"
					@columnchange="timeColumnChange">
					<text>{{selectTime}}的账目预算</text>
				</picker>
			</view>
		</uni-nav-bar>
		<view class="flex two-title">
			<view class="date">{{selectTime}}</view>
			<view class="flex">
				<text :style="type==='work'?'font-weight:600;':''" @click="changeType('work')">周计划</text>
				<text>/</text>
				<text :style="type==='month'?'font-weight:600;':''" @click="changeType('month')">月计划</text>
			</view>
		</view>
		<view class="card">
			<view class="title title-1">
				<text>本{{type==='month'?'月':'周'}}总预算</text>
				<text
					class="text">￥{{moreData&&(moreData.mBudget||moreData.wBudget)&&(type==='month'?moreData.mBudget:moreData.wBudget).toFixed(2)}}</text>
			</view>
			<view class="title title-2-1">
				<template v-if="type==='month'">
					<text>{{year}}-{{month}}-01</text>
					<text>{{year}}-{{month}}-{{getMonthDay(year,month)}}</text>
				</template>
				<template v-else>
					<text>{{getWeekDataList(`${year}-${month}-${day}`)[0]}}</text>
					<text>{{getWeekDataList(`${year}-${month}-${day}`)[6]}}</text>
				</template>
			</view>
			<view class="title title-2-2">
			</view>
			<view class="title title-2">
				<text>本{{type==='month'?'月':'周'}}已支出：￥{{zMoney}}</text>
				<text class="text">剩余￥{{allMoney.toFixed(2)}}</text>
			</view>
			<hr style="color:black;" class="m-t-1 m-b-1">
			<view class="title title-3">
				<text>剩余平均每日可用</text>
				<text>￥{{type==='month'?moreData.averaM:moreData.averaW}}</text>
			</view>
		</view>
		<view class="search m-t-2 m-b-1 flex">
			<text class="text-1">分类</text>
			<text class="text-1">总预算</text>

			<text class="text-1">剩余预算</text>
			<view class="flex-cen" @click="goToPage">
				<uni-icons type="plusempty" color="red"></uni-icons>
				<text class="text">新建</text>
			</view>

		</view>
		<view class="m-t-1" v-if="budgetData.length===0">
			<img src="../../static/img/miao/1.png" style="width: 100%;" />
			<text class="flex-cen">抱歉您还没有设置分类预算哦</text>
		</view>
		<view class="list" :style="{height:height}">
			<view class="flex list-item" v-for="item in budgetData" :key="item.id">
				<view class="flex-cen item-one">
					<uni-icons type="image" size="26px"></uni-icons>
					<text class="text">{{item.name}}</text>
				</view>

				<text class="text item-one">￥{{item.total_budget}}</text>
				<text class="text item-one"
					:style="{color:accSub(item.total_budget,item.total_expenditure)<=0?'red':''}">￥{{accSub(item.total_budget,item.total_expenditure)}}</text>

			</view>
		</view>
	</view>
</template>
<script>
	import {
		transformCn,
		transformCnDay
	} from '@/public/transform.ts'
	import {
		getMWData,
		getMonthDay,
		getWeekDataList
	} from '@/public/data.ts'
	import {
		ref,
		computed,
		reactive,
		
		nextTick
	} from 'vue'
	import {
		accSub
	} from '@/public/handelAddSub.js'
	export default {
		onShow() {
			this.getData()
		},
		setup() {
			const selectTime = ref(transformCn(new Date()))
			const YearRange = ref([])
			const monthRange = ref([])
			const dateRange = ref([])
			const allMoney = ref(0)
			const sMoney = ref(0)
			const zMoney = ref(0)
			const budgetData = ref([])
			const type = ref('month')
			const changeData = []
			const year = ref(new Date().getFullYear())
			const month = ref(new Date().getMonth() + 1)
			const day = ref(new Date().getDate())
			const moreData = reactive({})
			const height = ref(0)

			const getPickerValue = computed(() => {
				const exec = /([0-9]{4})年([0-9]{1,2})月/.exec(selectTime.value)
				const exec2 = /([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日/.exec(selectTime.value)
				if (exec2) {
					return [exec2[1] - 1873, exec2[2] - 1, exec2[3] - 1]

				} else if (exec) {

					return [exec[1] - 1873, exec[2] - 1]
				}

			})
			for (let i = 1873; i <= 2173; i++) {
				YearRange.value.push(i)
			}
			for (let i = 1; i <= 12; i++) {
				monthRange.value.push(i)
			}
			// 
			function timeChange(e) {
				if (type.value === 'month') {
					selectTime.value = YearRange.value[e.detail.value[0]] + '年' + monthRange.value[e.detail.value[1]] + '月'
				} else {
					selectTime.value = YearRange.value[e.detail.value[0]] + '年' + monthRange.value[e.detail.value[1]] +
						'月' +
						dateRange.value[e.detail.value[2]] + '日'
					day.value = dateRange.value[e.detail.value[2]]
				}

				year.value = YearRange.value[e.detail.value[0]]
				month.value = monthRange.value[e.detail.value[1]]
				getData()
			}

			function timeColumnChange(e) {

				changeData[e.detail.column] = e.detail.value
				if (e.detail.column < 2) {
					dateRange.value = []
					for (let i = 1; i <= getMonthDay(YearRange.value[changeData[0]] || year, monthRange.value[changeData[
								1]] ||
							month); i++) {
						dateRange.value.push(i)
					}
				}

			}

			function getRange() {
				return [YearRange.value, monthRange.value, type.value === 'work' ? dateRange.value : undefined]
			}

			function goToPage() {
				uni.navigateTo({
					url: '/pages/budget/add'
				})
			}

			function back() {
				const pages = getCurrentPages()
				const hasRoute = pages.some(item => {
					if (item.route !== 'pages/budget/index' && item.route !== 'pages/budget/add') {
						if (item.route.indexOf('pages/tabbar') > -1) {
							uni.switchTab({
								url: '/' + item.route
							})
						} else {
							uni.navigateTo({
								url: '/' + item.route
							})
						}

						return true
					}
				})
				if (!hasRoute) {
					uni.switchTab({
						url: '/'
					})
				}
			}

			function changeType(str) {
				type.value = str

				if (str === 'month') {
					selectTime.value = transformCn(new Date(
						`${YearRange.value[getPickerValue.value[0]]}-${monthRange.value[getPickerValue.value[1]]}-1`
					))
				} else {

					selectTime.value = transformCn(new Date(
						`${YearRange.value[getPickerValue.value[0]]}-${monthRange.value[getPickerValue.value[1]]}-${day.value}`
					), 'work')
					dateRange.value = []
					for (let i = 1; i <= getMonthDay(year.value, month.value); i++) {
						dateRange.value.push(i)
					}
				}

				getData()
			}


			function getData() {
				getMWData(true, selectTime.value, '', type.value, true).then(res => {
					console.log(res, 'res')
					for (const key in res) {
						moreData[key] = res[key]
					}

					budgetData.value = res.budgetData
					if (type.value === 'month') {
						allMoney.value = res.allMonthMoney
						sMoney.value = res.mIncome
						zMoney.value = res.mExpenditure
					} else {
						allMoney.value = res.allWMoney
						sMoney.value = res.wIncome
						zMoney.value = res.wExpenditure
					}
					
					nextTick(() => {
						const classNames = ['left', 'uni-navbar','card', 'two-title', 'search']
						let totalHeight = 0
						classNames.map(item => {
							totalHeight += document.querySelector('.' + item).offsetHeight
						})
						
						height.value = `calc(100vh - ${totalHeight}px - 2vh)`
					})
				})
			}
			return {
				selectTime,
				YearRange,
				monthRange,
				dateRange,
				getPickerValue,
				timeChange,
				getData,
				allMoney,
				sMoney,
				zMoney,
				back,
				type,
				changeType,
				getWeekDataList,
				getMonthDay,
				year,
				month,
				day,
				getRange,
				timeColumnChange,
				budgetData,
				moreData,
				goToPage,
				accSub,
				height
			}
		},
	}
</script>
<style lang="scss" scoped>
	.budget {
		padding: 0 20px 20px;

		height: calc(100vh - 3vh);
		overflow-y: hidden;

		::v-deep .uni-navbar__header-container {
			justify-content: center;
		}

		.title {
			font-size: 16px;
			line-height: 88rpx;
		}

		.list {
			overflow-y: auto;
			// margin-top: 1vh;
			background-image: url('../../../static/img/miao/2.png');

			.list-item {
				padding: 4px;
				margin-top: 0.8vh;
				display: flex;
				// justify-content: space-between;
				font-size: 16px;
				align-items: center;

				.item-one {
					width: 28%;
					text-align: center;
				}

				::v-deep .uni-icons {

					color: $uni-color-warning !important;
					margin-right: 4px;
				}

				.description {
					text-overflow: ellipsis;
					width: 10vw;
				}
			}

			.list-item:hover {
				background: #f3f3f3;
			}
			.list-item:first-child{
				margin-top: 0;
			}
		}

		.left {
			margin-left: 10px;
			position: fixed;
			z-index: 999;
			line-height: 88rpx;
			color: white;
			display: flex;
		}

		.two-title {
			display: flex;
			justify-content: space-between;
			margin-top: 20px;
			font-size: 20px;

			.date {
				font-weight: 1000;
			}
		}

		.card {
			border: 2px solid #000;
			border-radius: 10px;
			padding: 10px;
			margin-top: 2vh;

			.title {
				display: flex;
				justify-content: space-between;
			}

			.title-1 {

				font-size: 18px;
				font-weight: 600;

				.text {
					color: red;
				}
			}

			.title-2 {
				.text {
					color: red;
				}
			}

			.title-3 {
				font-weight: 600;
			}

			.title.title-2-2 {
				width: 100%;
				background: #f0ad4e;
				height: 4vh;
				border-radius: 4px;
			}
		}

		.search {
			justify-content: space-between;
			font-size: 18px;
			font-weight: 600;

			.text-1 {
				width: 28%;
				text-align: center;
			}

			.text {
				color: red;
			}
		}
	}
</style>