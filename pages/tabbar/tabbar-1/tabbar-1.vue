<template>
	<view class="content">

		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar>

			<view class="title flex">

				<picker :range="[YearRange,monthRange]" mode="multiSelector" :value="getPickerValue" @change="timeChange">

					<text>{{selectTime}}的账目明细</text>
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
			<view class="flex box-item">
				<text class="text">支出</text>
				<view class="bar" :style="'width:'+((zMoney/accAdd(zMoney,sMoney)*70)||0).toFixed(2)+'vw;'"></view>
				<view class="text">-￥{{zMoney}}</view>
			</view>
			<view class="flex box-item">
				<text class="text">收入</text>
				<view class="bar" :style="'width:'+((sMoney/accAdd(zMoney,sMoney)*70)||0).toFixed(2)+'vw;'"></view>
				<view class="text">￥{{sMoney}}</view>
			</view>
			<hr>
			<text class="bottom-text" @click="goToPage('/pages/budget/index')">设置预算</text>
			<text class="bottom-text" @click="goToPage('/pages/incomeExpenditure/overview')">&nbsp;&nbsp;收支概况</text>
		</view>
		<view class="search">
			<view class="flex-cen">
				<uni-search-bar :focus="true" v-model="searchValue" @input="input" placeholder="搜索账单/备注/分类等" @confirm="search"
					clearButton="auto" cancelButton="none">
				</uni-search-bar>
				<view class="flex-cen" @click="goToPage('')">
					<uni-icons type="plusempty" color="red"></uni-icons>
					<text class="text">新建</text>
				</view>

			</view>
		</view>
		<view class="tag m-t-1 " v-for="(item,index) in data" :key="index">
			<view class="flex">
				<view class="shu"></view>
				<text class="text">{{transformCnDayF(item.time)}}</text>
			</view>

			<view class="list">
				<view class="flex list-item" v-for="item2 in item.data" :key="item2.id">
					<view class="flex-cen">
						<uni-icons type="image" size="26px"></uni-icons>
						<text class="text">{{item2.name}}</text>
					</view>
					<text class="text">{{item2.description}}</text>
					<text class="text">{{item2.type==='1'?'':'-'}}￥{{item2.money}}</text>
				</view>
			</view>
		</view>

		<view class="no-data" v-if="data.length===0">
			<img src="../../../static/img/miao/3.png" alt="" srcset="" class="img">
			<text>暂无数据</text>
		</view>
	</view>
</template>

<script>
	import {
		transformCn,
		transformCnDay
	} from '@/public/transform.ts'
	import {
		getMWData
	} from '@/public/data.ts'
	import {
		computed,
		ref
	} from "vue";
	import {
		request
	} from '@/public/request.ts'
	import dataVue from '@/pages/comm/data'
	import {accAdd,accSub,accChu} from '@/public/handelAddSub.js'
	export default {
		components: {
			dataVue
		},
		onLoad() {},
		onShow() {

			this.getData()
		},
		setup() {
			const selectTime = ref(transformCn(new Date()))
			const selectDate = ref(new Date())
			const selectYear = ref('')
			const selectMonth = ref('')
			const YearRange = ref([])
			const monthRange = ref([])
			const searchValue = ref('')
			const data = ref([])
			const allMoney = ref(0)
			const zMoney = ref(0)
			const sMoney = ref(0)
			let calendarEl = null
			for (let i = 1873; i <= 2173; i++) {
				YearRange.value.push(i)
			}
			for (let i = 1; i <= 12; i++) {
				monthRange.value.push(i)
			}

			function search() {
				getData(searchValue.value)
			}

			function input(e) {
				getData(e)
			}
			const getPickerValue = computed(() => {
				const exec = /([0-9]{4})年([0-9]{1,2})月/.exec(selectTime.value)
				if (exec) {
					return [exec[1] - 1873, exec[2] - 1]
				}

			})


			function goToPage(url = '') {
				console.log(url || '/pages/tabbar-3-detial/tabbar-3-qa/tabbar-3-qa', 'cccc')
				uni.navigateTo({
					url: url || '/pages/tabbar-3-detial/tabbar-3-qa/tabbar-3-qa'
				})
			}

			function timeChange(e) {
				console.log(e, 'e time change')
				selectTime.value = YearRange.value[e.detail.value[0]] + '年' + monthRange.value[e.detail.value[1]] + '月'
				getDate(selectTime.value)
				getData(searchValue.value)
			}

			function transformCnDayF(date) {
				console.log(date, 'date')

				// getData(searchValue.value)
				return transformCnDay(typeof date === 'object' ? date : new Date(date))
			}

			function getDate(date) {
				if (typeof date === 'string') {
					const exec = /([0-9]{4})年([0-9]{1,2})月/.exec(date)
					if (exec) {
						date = `${exec[1]}-${exec[2]}-01`
					}
				}
				selectDate.value = date
			}

			function getData(search = '') {
				getMWData(true, selectTime.value, search).then(res => {
					data.value = res.data
					allMoney.value = res.allMonth
					sMoney.value = res.mIncome
					zMoney.value = res.mExpenditure
				})

			}

			const transformCnF = computed(() => {

				return transformCn(selectTime.value ? (typeof selectTime.value === 'object' ? selectTime.value : new Date(
					selectTime.value)) : new Date())
			})
			return {
				accAdd,
				accSub,
				accChu,
				transformCnF,
				selectTime,
				search,
				input,
				searchValue,
				goToPage,
				transformCnDayF,
				getData,
				allMoney,
				sMoney,
				zMoney,
				data,
				YearRange,
				selectMonth,
				selectYear,
				monthRange,
				timeChange,
				selectDate,
				getPickerValue
			}
		}
	};
</script>

<style lang="scss" scoped>
	.content {
		text-align: center;
		// height: 100vh;
		padding: 0 10px;

		::v-deep .uni-navbar__header-container {
			justify-content: center;
		}

		.box {
			border: 2px solid #000;
			// margin-top: 10px;
			padding: 10px;
			border-radius: 10px;

			.top {
				display: flex;
				justify-content: space-between;
				margin-bottom: 2vh;

				.text:first-child {
					font-weight: 600;
					font-size: 18px;

				}

				.text:last-child {
					font-size: 22px;
					color: red;
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
					width: 0vw;
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

		.no-data {
			.img {
				width: 100%;
			}
		}





		.search {
			margin-top: 2vh;

			.uni-searchbar {
				width: 80%;
			}

			.flex-cen {
				.text {
					color: red;
					font-weight: 600;
				}
			}
		}

		.tag {
			display: flex;
			flex-direction: column;

			.shu {
				width: 3px;
				height: 14px;
				background: #ffce82;
				margin-top: 4px;
				margin-right: 10px;
			}

			.text {
				font-weight: 600;
			}

			.list {
				margin-top: 1vh;
				background-image: url('../../../static/img/miao/2.png');

				.list-item {
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
		}

		.title {
			font-size: 16px;
			line-height: 88rpx;
		}

		::v-deep .uni-date {
			height: 44px;
			line-height: 44px;
		}

		.calendar {
			line-height: 120rpx;



			::v-deep .uni-date-x--border {
				border: 0;
			}

			::v-deep .uni-date-x {
				background-color: #ea9528;
				color: white;

			}

			::v-deep .uni-icons {
				color: white !important;
			}

			::v-deep .uni-date__x-input {
				display: none;
			}
		}
	}
</style>