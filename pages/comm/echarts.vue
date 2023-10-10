<template>
	<view class="charts-box">
		
		<qiun-data-charts :type="type" :chartData="chartData" :opts="opts" />
	</view>
</template>
<script>
	import {
		ref
	} from 'vue'
	export default {
		props: {
			chartData: {
				default: () => {
					return {
						categories: [],
						series: []
					}
				},
				type: Object
			},
			opts:{
				default:()=>{return {}},
				type:Object
			},
			type:{
				default:'column',
				type:String
			}

		},
		setup(props) {
			
			

			return {
				
			}
		},

	}
</script>
<style lang="scss" scoped>
	.charts-box {
		width: 100%;
		height: 300px;
	}
</style>