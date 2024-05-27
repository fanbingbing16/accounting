<template>
	<view class="import-file">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="账单导入" @clickLeft="back" />
		<view class="box m-t-2 m-b-2">
			<view class="box-item">
				<!-- <text>上传文件</text> -->
				<Upload ref="uploadRef"></Upload>
				<uni-icons type="right"></uni-icons>
			</view>
			<!-- <view class="box-item" @click="goToPage('/pages/my/importFile/userGuide')">
				<text>使用教程</text>
				<uni-icons type="right"></uni-icons>
			</view> -->
			<view class="box-item" @click="goToPage('/pages/my/importFile/recognizedBill')">
				<text>导入记录</text>
				<uni-icons type="right"></uni-icons>
			</view>
		</view>
		<button type="primary" @click="upload">上传文件</button>

	</view>
</template>
<script>
	import {
		request,baseurl
	} from '@/public/request'
	import Upload from './upload.vue'
	import {
		ref
	} from 'vue'
	
	export default {
		components: {
			Upload
		},
		setup() {
			const uploadRef = ref(null)
			const back = () => {
				uni.switchTab({
					url: '/'
				})
			}
			const upload = () => {
				console.log(uploadRef.value, 'this.$refs.upload')
				const files = uploadRef.value?.$refs.file?.files || []
				const formData = new FormData()
				files.forEach((file) => {
					formData.append(`files[]`, {
						uri: file.url, // 这里根据 uni.chooseImage 返回的文件路径格式来调整  

					});
				});
				uni.uploadFile({  
				              url: baseurl+'/expenditure/upload', // 替换为你的实际上传接口  
				              filePath: files[0]?.url,  
				              name: 'files', // 后端接收的文件字段名  
				             
				              success: (uploadFileRes) => {  
								const data = JSON.parse(uploadFileRes.data||'{}')
				                console.log('文件上传成功', data,data.status,typeof data);  
				                if(data.status===1){
									uni.showModal({
										title: `您本次上传的文件解析出${data.data[0].length-1}条数据，是否确定上传到服务器？`,
										success: (modelData) => {
											console.log(modelData, 'modelData')
											if (modelData.confirm) {
												request({
													url:'/expenditure/adds',
													method:'POST',
													data:{
														data:JSON.stringify(data.data[0].map(item=>{
														item.userid = uni.getStorageSync('user')?.id
														return item
													})),
													typeAll:2
													}
												}).then(res=>{
													if(res.status===1){
														uni.showToast({
															title:'提交成功'
														})
														setTimeout(()=>{
															uni.navigateTo({
																url:'/pages/my/importFile/recognizedBill'
															})
														},1000)
													}
												})
											}
									
										},
										fail: (err) => {
											uni.showToast({
												title: err,
												icon: 'none'
											})
										}
									})
								}else{
									uni.showToast({
										title: data.message,
										icon: 'none'
									})
								}
				              },  
				              fail: (error) => {  
				                console.error('文件上传失败', error);  
				                uni.showToast({
				                	title: error,
				                	icon: 'none'
				                })
				              }  
				            });

			}
			const goToPage = (url)=>{
				uni.navigateTo({
					url
				})
			}
			return {
				back,
				upload,
				uploadRef,
				goToPage
			}
		},
	}
</script>
<style lang="scss" scoped>
	.import-file {
		padding: 0 10px 10px 10px;

		.box {
			border: 2px solid #000;

			padding: 10px 14px;
			border-radius: 10px;

			.box-item {
				display: flex;
				justify-content: space-between;
				border-bottom: 1px solid #d0d0d0;
				padding-top: 8px;
				padding-bottom: 8px;
				cursor: pointer;
			}

			.box-item:last-child {
				border-bottom: 0;
			}
		}
	}
</style>