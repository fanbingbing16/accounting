<template>
	<view class="regularBookkeeping">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="定时记账" @clickLeft="back" />
		<view class="bg" v-if="data.length===0">
			<img src="../../../static/img/miao/1.png" alt="" srcset="" class="bg-img">
			<text class="m-t-3">您可以添加固定收入和支出</text>
			<text class="m-t-2">在固定的时间会自动记账喔</text>
			<button class="button m-t-5" type="primary" @click="changePage">添加收支</button>
			<image src="../../../static/img/dialogBox.png" class="image">
			</image>
			<text class=" text">工资？房租？生活费？只要是每月、每周或每天的固定收支，都可以使用【定时记账】，会自动帮您记账喔</text>

		</view>
		<has :data="data"></has>
	</view>
</template>

<script lang="ts" setup>
	import {request} from '@/public/request'
	import {onMounted, ref} from 'vue'
	import has from './has.vue'
	import {transformNoTime} from '@/public/transform'
	onMounted(()=>{
		uni.preloadPage({url: "/pages/my/regularBookkeeping/detail"});
		uni.preloadPage({url: "/pages/incomeExpenditure/addScheduleTask"});
	})
	const data = ref([])
	function back() {
		// uni.navigateBack({
		// 	delta: 1
		// })
		uni.switchTab({
			url: '/pages/tabbar/tabbar-5/tabbar-5'
		})
	}
	const changePage = ()=>{
		uni.navigateTo({
			url:'/pages/incomeExpenditure/addScheduleTask'
		})
	}
	request({
		url:'/schedule',
		data:{
			
		}
	}).then((res:any)=>{
		// data.value = res.data
		data.value = res.data.map(item=>{
			item.start_time = transformNoTime(new Date(item.start_time))
			item.end_time = item.end_time&&item.end_time!=='无'?transformNoTime(new Date(item.end_time)):'无'
			return item
		})
	})
</script>

<style lang="scss" scoped>
	.regularBookkeeping {
		height: 100vh;

		.bg {

			background-color: #ffef76;
			// background-image: url('../../../static/img/miao/1.png');
			object-fit: contain;
			padding: 20px;
			display: flex;
			flex-direction: column;
			height: 100%;
			align-items: center;

			.bg-img {
				position: fixed;
				width: 40%;
				border-radius: 50%;
				top: 60vh;
				z-index: 1;
			}

			.button {
				background-color: $uni-color-warning ;
				border-radius: 30px;
			}

			.image {
				position: relative;
				width: 100%;

			}

			.text {
				width: 58%;
				margin: auto;
				margin-top: -173px;
			}

		}
	}
</style>