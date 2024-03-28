<template>
	<view>
		<button @click="chooseFile">选择文件上传</button>
		<button @click="uploadFile">上传文件</button>
		<input type="file" class="fileInput" style="display: none;" @input="handleFileChange" />
	</view>
</template>

<script>
	import axios from 'axios'
	export default {
		data() {
			return {
				selectedFile: null, // 选择的文件对象  
				uploadUrl: '你的服务器上传接口URL' // 你的文件上传接口地址  
			};
		},
		methods: {
			chooseFile() {
				//#ifdef  H5
				uni.chooseFile({
						//#endif
						// #ifdef MP-WEIXIN
						uni.chooseMessageFile({
							//#endif
							count: 10,
							success: (res) => {
								this.fileList = res.tempFiles; //fileList需要在data中初始定义为一个数组
								this.uploadFile()
							},
							fail: (err) => {
								console.log(err);
							}
						});
					},
					// 上传文件
					uploadFile() {
						  
						this.fileList.forEach(file => {
							// 调用uni.uploadFile方法上传文件
							uni.uploadFile({
								
								url: 'http://localhost:3000/budget/upload',
								
								filePath: file.path,
								name: 'file',
							
								formData: {
								},
								success: (res) => {
									console.log(res,'res')
									const {
										status,
										msg,
										data
									} = JSON.parse(res.data)
									if (status === 200) {
										this.$u.toast(msg);
										this.form.file.push(data)
									} else {
										this.$u.toast(msg);
										return
									}
								},
								fail: (err) => {
									console.log('失败啦', err);
								}
							})
						})
					},
				}
			};
</script>