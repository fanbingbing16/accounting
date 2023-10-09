<template>
	<view class="comm-year-month-select">
		<uni-data-picker placeholder="请选择班级" popup-title="请选择所在地区" :localdata="dataTree" v-model="selectTime" class="data-tree"
			@change="onchange">
		</uni-data-picker>
		<view class="bg"></view>
	</view>
</template>
<script>
	import {
		ref
	} from "vue"
	export default {
		setup() {
			const dataTree = ref([])
			const time = ref([])
			for (let i = 1873; i <= 2173; i++) {
				dataTree.value.push({
					text: i + '年',
					value: i + '-0',
					children: []
				})
				for (let j = 1; j <= 12; j++) {
					dataTree.value.slice(-1)[0].children.push({
						text: j + '月',
						value: i + '-' + j
					})
				}
			}

			function onchange(e) {
				console.log('onchange:', e);
			}
			return {
				dataTree,
				onchange
			}
		},
	}
</script>
<style lang="scss" scoped>
	.comm-year-month-select {
		position: relative;
.data-tree{
	position: fixed;
	bottom: 250px;
	left: 0;
	z-index: 2;
}
		.bg {
			position: fixed;
			top: 0;
			z-index: 1;
			left: 0;
			background: rgba(0, 0, 0, 0.3);
			width: 100%;
			height: 100vh;
		}
	}
</style>