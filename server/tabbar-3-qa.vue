<template>
	<view class="content">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="" @clickLeft="back" />
		<view class="flex-cen m-t-3 center">
			<view class="tag-view" @click="inverted='收入';getData()">
				<uni-tag text="收入" type="primary" :inverted="inverted==='支出'" />
			</view>
			<view class="tag-view m-l-10" @click="inverted='支出';getData()">
				<uni-tag :inverted="inverted==='收入'" text="支出" type="primary" />
			</view>
		</view>
		<uni-section title="滑动视图" type="line" padding class="m-t-3">
			<swiper class="swiper" :indicator-dots="true">
				<swiper-item>
					<uni-grid :column="3" :highlight="true" @change="change($event,0)">
						<uni-grid-item v-for="(item, index) in listData.slice(0,16)" :index="index" :key="index">
							<view class="grid-item-box"
								:style="clickItem.id===item.id?'border:1px solid #ccc;border-radius:10px;':''">

								<uni-icons type="image" :size="30" color="#ffbcc9" />
								<text class="text">{{ item.name }}</text>
							</view>
						</uni-grid-item>
					</uni-grid>
				</swiper-item>
				<swiper-item v-if="inverted==='支出'">
					<uni-grid :column="3" :highlight="true" @change="change($event,16)">
						<uni-grid-item v-for="(item, index) in listData.slice(16,32)" :index="index" :key="index">
							<view class="grid-item-box"
								:style="clickItem.id===item.id?'border:1px solid #ccc;border-radius:10px;':''">
								<uni-icons type="image" :size="30" color="#ffbcc9" />
								<text class="text">{{ item.name }}</text>
							</view>
						</uni-grid-item>
					</uni-grid>
				</swiper-item>
				<swiper-item v-if="inverted==='支出'">
					<uni-grid :column="3" :highlight="true" @change="change($event,32)">
						<uni-grid-item v-for="(item, index) in listData.slice(32)" :index="index" :key="index">
							<view class="grid-item-box"
								:style="clickItem.id===item.id?'border:1px solid #ccc;border-radius:10px;':''">
								<uni-icons type="image" :size="30" color="#ffbcc9" />
								<text class="text">{{ item.name }}</text>
							</view>
						</uni-grid-item>
					</uni-grid>
				</swiper-item>
			</swiper>
		</uni-section>
		<view class="keyboard">
			<view class="flex-cen">
				<uni-easyinput v-model="remark" focus placeholder="点击输入备注"
					:styles="{borderColor:'#f0ad4e',width:'70%',backgroundColor:'white'}"></uni-easyinput>
				<text class="white16 m-l-10 m-r-10">￥{{money}}</text>
			</view>
			<view class="box flex">
				<view class="box-item" v-for="(item,index) in buttonLists" :key="item.text" @click="butonClick(item)"
					:style="(index+1)%4===0?'margin-right:0;':''">
					<text class="text">{{item.text}}</text>
				</view>
			</view>

		</view>
		<uni-calendar ref="calendar" class="uni-calendar--hook" :clear-date="true"  @confirm="confirm"
			@close="close" />
	</view>
</template>

<script>
	import {
		request
	} from '@/public/request.ts';
	import {
		transform
	} from '@/public/transform.ts'
	import {
		ref
	} from 'vue'
	import {
		list,
		buttonList
	} from './data.ts'
	export default {
		onLoad(options) {
			this.inverted = options.type || '支出'
			this.getData()
		},

		setup() {
			const money = ref('0')
			const listData = ref(list)
			const buttonLists = ref(buttonList)
			const remark = ref('')
			const inverted = ref('收入')
			const clickItem = ref('')
			let hasDian = false
			const back = () => {
				uni.navigateBack({
					delta: 1
				})
			}

			function open() {
				this.$refs.calendar.open()
			}
			function close() {
				console.log('弹窗关闭');
			}
			function change(e, sliceIndex) {
				console.log(e, 'e')
				let {
					index
				} = e.detail
				index = index + sliceIndex
				clickItem.value = listData.value[index]
			}

			function confirm(e) {
				console.log('confirm 返回:', e)
			}
			function getData() {
				request({
					url: '/category?userid=1&type=' + (this.inverted === '收入' ? 1 : 2)
				}).then(res => {
					console.log(res, 'res')

					listData.value = res.data

				})
			}

			function butonClick(item) {
				if (typeof item.text === 'number') {
					console.log(money.value, typeof money.value)
					money.value = (money.value !== '0' ? ((money.value) + item.text) : String(item.text))
					hasDian = false
					if (String(money.value).indexOf('.') > -1 && String(money.value).length - String(money.value).indexOf('.') >
						3) {
						uni.showToast({
							title: '数字最多小数点后两位',
							icon: 'none'
						})
						money.value = String(Math.floor(money.value * 100) / 100)
					}
				} else if (item.text === 'x') {
					money.value = +(money.value !== 0 ? ((money.value).slice(0, -1)) : 0)
				} else if (item.text === '.') {
					if (!(money.value).includes('.'))
						money.value = (money.value !== 0 ? (String(money.value) + '.') : '0.')
				} else if (item.text === '完成') {
					submit()
				}else if(item.id===1){
					open()
				}
			}

			function submit() {
				if (!clickItem.value) {
					return uni.showToast({
						title: '请选择分类',
						icon: 'none'
					})
				}
				if (+money.value === 0) {
					return uni.showToast({
						title: '请填写大于0的数字',
						icon: 'none'
					})
				}

				request({
					url: inverted.value === '支出' ? '/expenditure/add' : '',
					data: {
						userid: 1,
						typeid: clickItem.value.id,
						description: remark.value,
						time: transform(new Date()),
						money: money.value
					},
					method: 'POST'
				}).then(res => {
					console.log(res, 'res')

					uni.showToast({
						title: '添加成功',
						icon: 'success'
					})

				})
			}
			return {
				back,
				inverted,
				listData,
				change,
				remark,
				money,
				buttonLists,
				getData,
				clickItem,
				butonClick,
				open,
				close
			}
		}
	};
</script>

<style lang="scss" scoped>
	.content {
		text-align: center;
		height: 100vh;

		.uni-tag--primary {
			background-color: $uni-color-warning;
			border-color: $uni-color-warning;
		}

		.uni-tag--inverted {
			background-color: $uni-color-warning;
			background-color: white;
			color: $uni-color-warning;
		}

		.uni-tag {
			font-size: 16px;
		}

		::v-deep .uni-section-content {
			padding: 1vh 10px !important;
		}

		::v-deep .uni-section-header {
			display: none;
		}

		::v-deep .uni-grid-item {
			width: calc(100% / 4) !important;
			height: 10vh !important;
		}

		.swiper {
			height: 43vh;

			::v-deep .uni-grid-item--border {
				border: 0 !important;
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: center;

			}

			::v-deep .uni-grid--border {
				border: 0 !important;

			}
		}

		.grid-item-box {
			display: flex;
			flex-direction: column;
			padding: 7px;


			.image {
				width: 30px;
				height: 30px;
			}

			.text {
				font-size: 16px;
			}
		}

		.keyboard {
			width: 100vw;
			background: #f0ad4e;

			padding: 2% 10px;
			box-sizing: border-box;

			.uni-easyinput {
				width: 70%;

				::v-deep .uni-easyinput__content-input {
					height: 5vh;
				}
			}

			.box {
				display: flex;
				flex-wrap: wrap;

				.box-item {
					width: calc(calc(100% - 40px) / 4);
					margin-right: 10px;
					border: 1px solid #000;
					border-radius: 4px;
					margin-top: 2vh;
					padding: 1vh 0;
					background: rgba(0, 0, 0, 0);
					position: relative;
					overflow: hidden;

					.text {
						position: relative;
						z-index: 2;
					}
				}

				.box-item::after {

					content: ' ';
					position: absolute;
					top: -4px;
					left: 0;
					background: #fff;
					width: 100%;
					height: 100%;
					border-radius: 10px;
				}

				.box-item::before {

					content: ' ';
					position: absolute;
					bottom: 0px;
					left: 0;
					background: #ccc;
					width: 100%;
					height: 10px;
				}
			}

		}

	}
</style>