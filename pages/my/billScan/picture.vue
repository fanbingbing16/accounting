<template>
	<view> 上传图片 </view>
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
				uni.chooseFile({

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
				})
			},
			// 上传文件
			uploadFile() {


				this.fileList.forEach(async file => {
					const img = new Image();
					img.src = file.path

					// 当图片加载完成后执行
					img.onload = async () => {
						console.log(this,this.canvas,'canvas')
						let hasCanvas = this.canvas
						if (!this.canvas) {
							this.canvas = document.createElement('canvas')
							this.canvas.id = 'sourceImage'
							this.ele.appendChild(this
								.canvas);
						}else{
							this.canvas.setAttribute('style','display:block')
						}
						const context = this.canvas.getContext('2d');

						// 获取视口宽度
						const viewportWidth = window.innerWidth;

						// 计算图片的宽度，使用 calc(100vw - 20px) 的逻辑  
						const imgWidth = viewportWidth - 20;
						this.canvas.width = imgWidth
						const heightRatio = img.height / img.width;
						const imgHeight = imgWidth * heightRatio;
						this.canvas.height = imgHeight
						context.drawImage(img, 0, 0, img.width, img.height, 0, 0, this.canvas
							.width,
							this.canvas.height);

						const src = cv.imread('sourceImage');
						if (!src.data) {
							console.log('Could not open or find the image');
							return;
						}
						// 转换为灰度图  
						const gray = new cv.Mat();
						cv.cvtColor(src, gray, cv.COLOR_RGBA2GRAY, 0);

						// 应用自适应阈值二值化  
						const dst = new cv.Mat();
						cv.adaptiveThreshold(gray, dst, 255, cv.ADAPTIVE_THRESH_MEAN_C, cv
							.THRESH_BINARY, 11, 12);
						const dstU8 = new cv.Mat();
						dst.convertTo(dstU8, cv.CV_8U);
						// 处理数据为4的倍数
						const width = dstU8.cols;
						const height = dstU8.rows;
						const data = new Uint8ClampedArray(width * height * 4);
						for (let i = 0; i < height; i++) {
							for (let j = 0; j < width; j++) {
								const idx = i * width + j;
								data[idx * 4] = data[idx * 4 + 1] = data[idx * 4 + 2] = dstU8.ucharAt(
									i, j);
								data[idx * 4 + 3] = 255; // 设置透明度为255
							}
						}
						const imgData = new ImageData(data, width, height);


						context.putImageData(imgData, 0, 0);
						img.remove()

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
							psm:7,
							logger: m => {
								console.log(m)
								uni.hideLoading()

								uni.showLoading({
									title: `目前状态${m.status}，已完成 ${Math.floor(m.progress * 100)}%`
								})
							}
						})
						uni.hideLoading()

						src.delete();
						gray.delete();
						dst.delete();
						dstU8.delete();
						this.$emit('text', text)
						
					}
				})
			},
		}
	};
</script>