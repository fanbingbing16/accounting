<template>
	<view class="upload flex">
		<uni-file-picker :auto-upload="false" v-model="imageValue" fileMediatype="all" file-extname="csv,xlsx,xls" mode="grid" @select="select"
			@progress="progress" @success="success" @fail="fail" :limit="1" ref="file"/>
		
	</view>

</template>

<script>
	export default {
		data() {
			return {
				imageValue: []
			}
		},
		methods: {
			// 获取上传状态
			select(e) {
				console.log('选择文件：', e, this.imageValue)

				return
			},
			// 获取上传进度
			progress(e) {
				console.log('上传进度：', e)
			},

			// 上传成功
			success(e) {
				console.log('上传成功')
			},

			// 上传失败
			fail(e) {
				console.log('上传失败：', e)
			}
		}
	}
</script>