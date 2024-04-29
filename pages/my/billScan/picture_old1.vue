<template>
	<view>
		上传图片
	</view>
</template>
<!-- -->
<script>
	export default {
		name: 'Picture',
		props: {
			ele: {
				default: document.body,
				type: Element
			}
		},
		data() {
			return {
				canvas: null,
				fileList: []
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
								uni.showToast({
									title: '正在转化图片，请等待',
									icon: 'none'
								})
								this.fileList = res.tempFiles; //fileList需要在data中初始定义为一个数组
								console.log(this.fileList, 'file')
								this.uploadFile()
							},
							fail: (err) => {
								console.log(err, 'err');
							}
						});
					},
					// 上传文件
					uploadFile() {


						this.fileList.forEach(async file => {
							console.log(file, 'file')
							// 加载图片
							const img = new Image();
							img.src = file.path

							// 当图片加载完成后执行
							img.onload = async () => {
								console.log(this, 'this')
								console.log('正在转化图片，请等待1')

								uni.showToast({
									title: '正在转化图片，请等待',
									icon: 'none'
								})
								// 获取视口宽度  
								const viewportWidth = window.innerWidth;

								// 计算图片的宽度，使用 calc(100vw - 20px) 的逻辑  
								const imgWidth = viewportWidth - 20;
								console.log(viewportWidth, 'viewportWidth')
								if (!this.canvas) this.canvas = document.createElement('canvas')
								const ctx = this.canvas.getContext('2d');
								console.log('正在转化图片，请等待2')

								// 将图片绘制到canvas上
								// canvas.width = img.width;
								// 设置 canvas 的宽度  
								this.canvas.width = imgWidth;
								// 保持宽高比计算高度  
								const heightRatio = img.height / img.width;
								const imgHeight = imgWidth * heightRatio;
								this.canvas.height = imgHeight;

								// canvas.height = img.height;
								// ctx.drawImage(img, 0, 0);
								ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, this.canvas
									.width,
									this.canvas.height);

								// 获取图片像素数据
								const imageData = ctx.getImageData(0, 0, this.canvas.width, this
									.canvas
									.height);
								const pixels = imageData.data;
								console.log(1)
								// 将图片转为灰度图像
								for (let i = 0; i < pixels.length; i += 4) {
									const gray = pixels[i] * 0.3 + pixels[i + 1] * 0.59 + pixels[
										i + 2] * 0.11;
									pixels[i] = gray;
									pixels[i + 1] = gray;
									pixels[i + 2] = gray;
								}
								ctx.putImageData(imageData, 0, 0);
								// 自适应阈值二值化
								const blockSize = 30; // 块大小
								const halfSize = Math.floor(blockSize / 2);
								const thresholdDelta = 10; // 阈值差值
								console.log(2)
								console.log(imgWidth, imgHeight, this.canvas.height, this.canvas
									.width, 'this.canvas.width')
								for (let y = 0; y < this.canvas.height ; y++) {
									for (let x = 0; x < this.canvas.width ; x++) {
										let sum = 0;
										let count = 0;

										for (let dy = -halfSize; dy <= halfSize; dy++) {
											for (let dx = -halfSize; dx <= halfSize; dx++) {
												const nx = x + dx;
												const ny = y + dy;
												const idx = (ny * this.canvas.width + nx) * 4;
												sum += pixels[idx] + pixels[idx + 1] + pixels[idx +
													2]; // RGB求和  
												count++;
											}
										}
										console.log(x,y,this.canvas.width,this.canvas.height)
										const average = sum / (count * 3); // 平均灰度值  
										const idx = (y * this.canvas.width + x) * 4;
										const threshold = average - thresholdDelta;
										const binary = pixels[idx] + pixels[idx + 1] + pixels[idx +
											2] > threshold * 3 ? 255 : 0; // 转换为二值化  

										pixels[idx] = binary;
										pixels[idx + 1] = binary;
										pixels[idx + 2] = binary;
										pixels[idx + 3] = 255; // 透明度保持为255  
									}
								}
								console.log(3)

								ctx.putImageData(imageData, 0, 0);

								// 将处理后的图片显示在页面中
								console.log(this.ele, 'this.ele')
								this.ele.appendChild(this
									.canvas);
								const dataURL = this.canvas.toDataURL(
									'image/png'); // 你可以指定不同的图像格式，如 'image/jpeg'
								console.log(dataURL, 'dataURL')
								// 使用Tesseract.js等库进行文字识别
								// code here
								const {
									data: {
										text
									}
								} = await Tesseract.recognize(dataURL, 'chi_sim', {
									langPath: 'https://raw.githubusercontent.com/naptha/tessdata/gh-pages/4.0.0_fast',
									logger: m => {
										console.log(m)
										uni.hideLoading()

										uni.showLoading({
											title: `目前状态${m.status}，已完成 ${Math.floor(m
												.progress *
												100)}%`
										})
									}
								})
								uni.hideLoading()

								this.$emit('text', text)
								console.log(text, 'text')
							};
						})
					},
				}
			};
</script>