<template>
	<view class="detail">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="定时记账详情" @clickLeft="back" />
		<view class="box m-t-2">
			<view class="top">
				<text class="text">开始日期</text>
				<text class="text">{{data.start_time}}</text>
			</view>
			<!-- <hr/> -->
			<view class="top">
				<text class="text">结束日期</text>
				<text class="text">{{data.end_time}}</text>
			</view>
			<!-- <hr/> -->
			<view class="top">
				<text class="text">记账金额</text>
				<text class="text">{{data.type==='1'?'':'-'}}￥{{data.money}}</text>
			</view>
			<!-- <hr/> -->
			<view class="top">
				<text class="text">类型</text>
				<text class="text">{{data.typeName}}</text>
			</view>
			<view class="top">
				<text class="text">记账周期</text>
				<text class="text">{{data.every==='DAY'?'每天':(data.every==='WEEK'?'每周':'每月')}}</text>
			</view>
			<view class="top">
				<text class="text">备注</text>
				<text class="text">{{data.description||'无'}}</text>
			</view>
			<view class="top">
				<text class="text">状态</text>
				<text class="text">{{data.status}}</text>
			</view>
			<hr>
			<text class="bottom-text m-t-1" v-if="data.status==='进行中'" @click="stop('y')">暂停</text>
			<text class="bottom-text m-t-1" v-if="data.status==='暂停中'" @click="stop('n')">重启</text>
		</view>

		<text class="bottom-text m-t-2">定时记账数据</text>

		<view class="tag m-t-1 " v-for="(item,index) in data.arr" :key="index">
			<view class="flex">
				<view class="shu"></view>
				<text class="text">{{item.time}} {{item.data.length}}条</text>
			</view>
		</view>
		<view class="no-data m-t-1" v-if="!data.arr||data.arr.length===0">
			<img src="../../../static/img/miao/3.png" alt="" srcset="" class="img">
			<text>暂无数据</text>
		</view>
	</view>
</template>
<script>
	import {
		transformNoTime,transform
	} from '@/public/transform'
	import {
		request
	} from '@/public/request'
	import {
		useRoute
	} from 'vue-router';
	import {
		ref,
		onMounted
	} from 'vue';

	export default {
		setup() {
			const route = useRoute();
			const data = ref({})
			const show = ref([])
			const getData = () => {
				request({
					url: '/schedule/detail',
					data: {
						scheduleId: route.query.id
					}
				}).then(res => {
					data.value = res.data
					show.value = []
					data.value.start_time = transformNoTime(new Date(data.value.start_time))
					data.value.end_time = data.value.end_time && data.value.end_time !== '无' ?
						transformNoTime(new Date(data.value.end_time)) : '无'
					let expire = false //是否过期
					if (data.value.end_time !== '无') {
						expire = new Date(data.value.end_time).getTime() - new Date().getTime() <= 0
					}
					if (!expire && data.value.is_stop === 'n') {
						data.value.status = '进行中'
					} else if (data.value.is_stop === 'y' && !expire) {
						data.value.status = '暂停中'
					} else {
						data.value.status = '已过期'
					}
					// data.value.typeName = data.value.arr[0]?.name
					const tempDate = [];
					data.value.arr.forEach(item => {

						if (new Date(item.time).getDate() !== new Date(tempDate.slice(-1)?.[0]
								?.time).getDate()) {
							tempDate.push({
								time: transformNoTime(new Date(item.time)),
								data: [{
									...item
								}]
							})
							show.value.push([false])
						} else {
							tempDate.slice(-1)[0].data.push(item)
							show.value.slice(-1)[0].push(false)
						}
					})

					data.value.arr = [...tempDate]

				})
			}
			onMounted(() => {
				getData()
			});

			const back = () => {
				uni.navigateTo({
					url: '/pages/my/regularBookkeeping/index'
				})
			}
			let startX
			let isSliding = false
			let slideDistance = 0

			function onTouchStart(e) {
				// 记录开始滑动的位置  
				startX = e.touches[0].clientX;
				isSliding = true;
			}

			function onTouchMove(e) {
				if (isSliding) {
					// 计算滑动距离  
					const deltaX = e.touches[0].clientX - startX;
					slideDistance = deltaX;
				}
			}

			function onTouchEnd(index, index2) {
				isSliding = false;
				console.log(startX, slideDistance, 'startX')
				// 根据滑动距离决定是否显示按钮面板  
				show.value = show.value.map(item => item.map(() => false))
				if (slideDistance < -100) {
					// 展示按钮面板  
					show.value[index][index2] = true
				} else {
					// 隐藏按钮面板  
					slideDistance = 0;

				}
			}
			const stop = (isStop) => {
				request({
					url: '/schedule/edit',
					method: 'POST',
					data: {
						isStop,
						scheduleId: data.value.id,
						name:data.value.name,
						every:data.value.every,
						startTime:data.value.start_time+' 05:00:00',
						endTime:data.value.end_time==='无'?null:data.value.end_time+' 05:00:00',
						typeid:data.value.typeid,
						money:data.value.money,
						type:data.value.type,
						description:data.value.description
					}
				}).then(res => {
					if (res.status === 1) {
						uni.showToast({
							icon:'success',
							title:'修改成功'
						})
						getData()
					}
				})
			}
			return {
				back,
				data,
				show,
				onTouchStart,
				onTouchMove,
				onTouchEnd,
				stop
			}
		},
	}
</script>
<style lang="scss" scoped>
	.detail {
		padding: 0 10px 10px 10px;
		text-align: center;

		.bottom-text {
			font-weight: 600;
			display: block;
			font-size: 18px;
		}

		.action-buttons {
			transition: transform 0.3s ease;
			display: flex;
			width: 24% !important;
			position: absolute;
			right: -86px;
			background: white;
			height: 100%;
			line-height: 36px;
		}

		.no-data {
			text-align: center;

			.img {
				width: 100%;
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

			.button-list {
				display: flex;
				justify-content: flex-end;
				width: 70%;

				.text {
					margin-left: 10px;
					cursor: pointer;
				}
			}

			.text {
				font-weight: 600;
			}

			.list {
				margin-top: 1vh;
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
		}

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

			// .text:last-child {
			// 	font-size: 22px;
			// 	color: red;
			// }
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
</style>