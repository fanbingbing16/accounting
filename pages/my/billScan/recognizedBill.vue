<template>
	<view class="recognized-bill">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="已识别账单" @clickLeft="back" />
			<view class="m-t-2"></view>
			<text>喵喵注：只显示最近一年的记录</text>
		<view class="tag m-t-1 " v-for="(item,index) in data" :key="index">
			<view class="flex">
				<view class="shu"></view>
				<text class="text">{{transformCnDayF(item.time)}}进行账图识别</text>
			</view>

			<view class="list">
				<view v-for="(item2,index2) in item.data" :key="index+index2*10">
				<text class="text" style="display: block;">{{index2+1}}:{{transformCnDayF(item2.time,2)}}</text>
				
				<view v-for="(item3) in item2.data" :key="item3.id" class="flex list-item" >
					<view class="flex-cen">
						<uni-icons type="image" size="26px"></uni-icons>
						<text >{{item3.name}}</text>
					</view>
					<text
						>{{item3.description&&item3.description.length>10?(item3.description.slice(0,7)+'...'):item3.description}}</text>
					<text >{{item3.type==='1'?'':'-'}}￥{{item3.money}}</text>
				</view>
					
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
		ref
	} from 'vue'
	import {
		request
	} from '@/public/request'
	import {
		transform,transformCn
	} from '@/public/transform'
	export default {
		setup() {
			const data = ref([])
			request({
				url: '/expenditure',
				data: {
					isPicture: true,
					time: String(new Date().getFullYear())

				},

			}).then(res => {
				data.value = []
				const obj = {}
				const obj2 = {}
				res.data.forEach(item => {
					
					if (obj[item.picture_time] !== undefined) {
						
						if(obj2[item.picture_time+item.time]!==undefined){
							
							data.value[obj[item.picture_time]].data[obj2[item.picture_time+item.time]].data.push(item)
						}
						
						else{
							obj2[item.picture_time+item.time] = data.value[obj[item.picture_time]].data.length
							data.value[obj[item.picture_time]].data.push({data:[item],
								time:item.time})
								
							
						}
					} else {
						obj[item.picture_time] = data.value.length
						obj2[item.picture_time+item.time] = 0
						data.value.push({
							time: item.picture_time,
							
							data: [{time:item.time,data:[item]}]
						})
					}

				})
				
			})

			function transformCnDayF(date,type=1) {
				

				// getData(searchValue.value)
				return type===1?transform(typeof date === 'object' ? date : new Date(date)):transformCn(typeof date === 'object' ? date : new Date(date),'work')
				
			}
			
			return {
				data,
				transformCnDayF,
			}
		},
		methods: {
			back() {

				uni.navigateTo({
					url: '/pages/my/billScan/index',
					fail: (e) => {
						consoe.log(e, 'e')
					}
				})
			},
		}
	}
</script>
<style lang="scss" scoped>
	.recognized-bill {
		padding: 0 10px 10px 10px;

		.no-data {
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

			.text {
				font-weight: 600;
			}

			.list {
				margin-top: 1vh;
				// background-image: url('../../../static/img/miao/2.png');

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
	}
</style>