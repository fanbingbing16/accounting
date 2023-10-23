<template>
	<view class="budget-add">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="设置分类预算" @clickLeft="back" />
		<input placeholder="在此输入分类预算额度" class="m-t-2 m-b-3 input" type="number" v-model="budget" />
		<text class="text ">选择分类</text>
		<uni-section title="滑动视图" type="line" padding class="m-t-1">
			<swiper class="swiper" :indicator-dots="true">
				<swiper-item>
					<uni-grid :column="3" :highlight="true" @change="change($event,0)">
						<uni-grid-item v-for="(item, index) in listData.slice(0,20)" :index="index" :key="index">
							<view class="grid-item-box"
								:style="clickItem.id===item.id?'border:1px solid #ccc;border-radius:10px;':''">

								<uni-icons type="image" :size="30" color="#ffbcc9" />
								<text class="text">{{ item.name }}</text>
							</view>
						</uni-grid-item>
					</uni-grid>
				</swiper-item>
				<swiper-item>
					<uni-grid :column="3" :highlight="true" @change="change($event,20)">
						<uni-grid-item v-for="(item, index) in listData.slice(20,40)" :index="index" :key="index">
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
		<button class="m-t-1 button" type="warn" @click="save">保存</button>
	</view>
</template>
<script>
	import {
		ref
	} from "vue"
	import {
		request
	} from '@/public/request.ts'
import { transform } from "../../public/transform"
	export default {
		setup() {
			const budget = ref(null)
			const listData = ref([])
			const clickItem = ref({})
			request({
				url: `/category?userid=${uni.getStorageSync('user')?.id}&type=2`
			}).then(res => {
				console.log(res, 'res')

				listData.value = res.data

			})

			function back() {
				uni.navigateTo({
					url: '/pages/budget/index'
				})
			}

			function change(e, sliceIndex) {

				let {
					index
				} = e.detail
				index = index + sliceIndex
				clickItem.value = listData.value[index]
			}

			function save() {
				if (!budget.value || budget.value <= 0) {
					uni.showToast({
						title: '请输入大于0的分类预算额度',
						icon: 'none'
					})
					return
				}
				if (!clickItem.value.id) {
					uni.showToast({
						title: '请选择分类',
						icon:'none'
					})
					return
				}
				request({
					url:'/budget/add',
					data:{
						userid:uni.getStorageSync('user')?.id,
						time:transform(new Date()),
						money:budget.value,
						typeid:clickItem.value.id
					},
					method:'POST'
				}).then(()=>{
					uni.showToast({
						title:'添加成功',
						
					})
					setTimeout(()=>{
						uni.navigateTo({
							url:'/pages/budget/index'
						})
					},2000)
				})
			}
			return {
				back,
				budget,
				listData,
				clickItem,
				change,
				save
			}
		},
	}
</script>
<style lang="scss" scoped>
	.budget-add {
		padding: 0 20px 20px;

		.input {
			border: 2px solid #000;
			padding: 10px;
			border-radius: 10px;
		}

		.text {
			font-size: 18px;
			font-weight: bold;
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
			height: 55vh;

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

		.button {
			background-color: $uni-color-warning ;
		}
	}
</style>