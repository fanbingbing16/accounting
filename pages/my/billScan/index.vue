<template>
	<view class="bill-scan" ref="billScan">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="帐图识别" @clickLeft="back" />
		<view class="box m-t-2 m-b-2">
			<view class="box-item" @click="upload">
				<Picture ref="picture" :ele="ele" @text="text"></Picture><uni-icons type="right"></uni-icons>
			</view>
			<view class="box-item" @click="goToPage('/pages/my/billScan/recognizedBill')"><text>已识别账单</text><uni-icons
					type="right"></uni-icons></view>

			<view class="box-item" @click="goToPage('/pages/my/billScan/userGuide')"><text>使用教程</text><uni-icons
					type="right"></uni-icons></view>
		</view>
		<text class="bottom-text ">识别结果</text>
		<text v-if="formData.textStr.length>0">
			以下是图片识别的结果，识别结果若不对的地方请自动修改
			格式要求：日期、金额、分类、说明或者账户名称或者日期、金额、说明或者账户名称（这个顺序没有要求）
		</text>
		<uni-forms :modelValue="formData" label-width="40px" ref="form">

			<view v-for="(item,index) in formData.textStr" :key="index" class="m-t-2 text-content">
				<text>第{{index+1}}条</text>
				<uni-forms-item label="内容" :name="['textStr',index]" :rules="[{required:true,errorMessae:'必填项'}]">

					<uni-easyinput v-model="formData.textStr[index]" placeholder="请输入内容"></uni-easyinput>
				</uni-forms-item>
				<view class="flex-cen m-t-1">
					<uni-forms-item label="类型" :name="['typeArr',index]" class="m-r-4"
						:rules="[{required:true,errorMessae:'必填项'}]">
						<uni-data-select v-model="formData.typeArr[index]" :localdata="range"></uni-data-select>
					</uni-forms-item>
					<uni-icons type="plusempty" size="25" @click="add(index)"></uni-icons>
					<uni-icons type="closeempty" size="25" @click="sub(index)"></uni-icons>
				</view>

			</view>
		</uni-forms>
		<button v-if="formData.textStr.length>0" type="primary" class="m-t-2" @click="submit">提交</button>

	</view>
</template>

<script>
	import Picture from './picture.vue'
	import {
		transformCn,
		transformNoTime
	} from '@/public/transform.ts'
	import {
		checkNumber,
		parseAndValidateDateTime,
		checkDate
	} from '@/public/check.js'
	import {
		request
	} from '@/public/request.ts'
	import monent from 'moment'
	export default {
		components: {
			Picture
		},
		data() {
			return {
				ele: null,
				formData: {
					textStr: [],
					typeArr: [],
				},

				range: [{
						value: 1,
						text: "金额"
					},
					{
						value: 2,
						text: "日期"
					},
					{
						value: 3,
						text: "说明或者账户名称"
					},
					{
						value: 4,
						text: "分类"
					},
				],
			}
		},
		mounted() {
			this.ele = this.$refs.billScan.$el
			uni.preloadPage({
				url: "/pages/my/billScan/recognizedBill"
			});
			uni.preloadPage({
				url: "/pages/my/billScan/userGuide"
			});
		},
		methods: {
			goToPage(url) {
				console.log(url, 'url')
				uni.navigateTo({
					url,
					fail: (e) => {
						console.log(e, 'e', url)
					}
				})
			},
			submit() {
				this.$refs.form.validate().then(res => {
					console.log('表单数据信息：', res);

					const set = new Set()
					let errorMessage = ''
					const moneyData = []
					let dataIndex = 0
					console.log(this.formData, 'this.formData')
					this.formData.typeArr.some((item, index, arr) => {
						const check = checkDate(this.formData.textStr[index])
						if (item === 1) {
							if (!checkNumber(this.formData.textStr[index])) {
								errorMessage = `第${index+1}个类型为金额,却不是数字`
								return true
							}
						} else if (item === 2) {

							if (!check) {
								errorMessage = `第${index+1}个类型为日期,却不是正确的日期格式`
								return true
							} else {
								this.formData.textStr[index] = check.text.trim()
							}
						}
						moneyData[dataIndex] = moneyData[dataIndex] || {}
						if (item === 1) {
							if (+this.formData.textStr[index] >= 0) {
								moneyData[dataIndex].type = 1
							} else {
								moneyData[dataIndex].type = 2
							}
							moneyData[dataIndex].money = Math.abs(this.formData.textStr[index])
						} else if (item === 2) {
							moneyData[dataIndex].time = transformNoTime(monent(this.formData.textStr[
								index], check.formate || null)._d)
						} else if (item === 3) {
							moneyData[dataIndex].description = this.formData.textStr[index].trim()
						} else if (item === 4) {
							moneyData[dataIndex].typeid = this.formData.textStr[index].trim()
						} else {
							errorMessage = `第${index+1}个类型不正确`
							return true
						}

						moneyData[dataIndex]
						if (set.has(item)) {
							errorMessage =
								`第${index+1}个类型为${this.range.filter((element)=>element.value===item)[0]?.text},不符合格式`
							return true
						} else {
							set.add(item)
							if ((set.has(4) && set.size === 4) || (!set.has(4) && set.size === 3)) {
								moneyData[dataIndex].userid = uni.getStorageSync('user')?.id
								dataIndex++
								set.clear()
							}
						}
						return false
					})
					console.log(set, 'set')
					if (((set.has(4) && set.size < 4) || (!set.has(4) && set.size < 3)) && set.size !== 0 && !
						errorMessage) {
						errorMessage =
							`第${this.formData.textStr.length}个类型为${this.range.filter((element)=>element.value===this.formData.typeArr.slice(-1)[0])[0]?.text},不符合格式`
					}
					if (errorMessage) {
						uni.showToast({
							title: errorMessage,
							icon: 'none'
						})
						setTimeout(() => {
							uni.hideToast()
						}, 1000)
						return
					}
					request({
						url: '/expenditure/adds',
						data: {
							data: JSON.stringify(moneyData)
						},
						method: 'POST'
					}).then(res => {
						uni.showToast({
							title: '添加成功',
							icon: 'success'
						})
						setTimeout(() => {
							uni.navigateTo({
								url: '/pages/my/billScan/recognizedBill'
							})
						}, 2000)


					})

				}).catch(err => {
					console.log(err, 'err')
					uni.showToast({
						title: '必须填写文字以及选择类型！',
						icon: 'none'
					})
					setTimeout(() => {
						uni.hideToast()
					}, 1000)
				})

			},
			add(index) {
				this.formData.textStr.splice(index + 1, 0, '')
				this.formData.typeArr.splice(index + 1, 0, '')
			},
			sub(index) {
				uni.showModal({
					content: '确定删除？',
					success: (data) => {

						console.log(data, 'dtaa')
						if (data.confirm) {
							this.formData.textStr.splice(index, 1)
							this.formData.typeArr.splice(index, 1)
						}

					},
					fail: (err) => {
						uni.showToast({
							title: err,
							icon: 'none'
						})
					}

				})

			},
			back() {
				uni.switchTab({
					url: '/'
				})
			},
			leanText(text) {
				// 去除非打印字符和多余的空格  
				return text.replace(
						/[\u0000-\u001F\u007F-\u009F\u2000-\u2027\u2028-\u202F\u2060-\u206F\uFEFF\uFFF0-\uFFFD]/g, '')
					.replace(/\s+/g, '  '); // 替换所有连续空格为一个空格  
			},
			upload() {
				this.formData.textStr = ''
				this.$refs.picture.chooseFile()
			},
			text(data) {
				console.log(data, 'data')
				this.ele.getElementsByTagName('canvas')[0].setAttribute('style', 'display:none')
				this.formData.textStr = data.split('\n').filter(item => item.trim())
				this.formData.typeArr = []
				const regx = /^(.+)\s([0-9-+\.]+)$/
				const regxMoney = /^([0-9-+\.]+)$/
				const moneyData = []
				this.formData.textStr = this.formData.textStr.map((item, index) => {
					const today = new Date()
					item = this.leanText(item)
					item = item.replace('昨天', transformCn(new Date(today.setDate(today.getDate() - 1)), 'work'))
					item = item.replace('今天', transformCn(new Date(), 'work'))
					const result = parseAndValidateDateTime(item)

					if (result.isValid) {
						this.formData.typeArr[index] = 2
						item = result.text
					} else {
						const exec = regx.exec(item)
						if (regxMoney.test(item)) {
							this.formData.typeArr[index] = 1
						} else if (exec) {
							this.formData.typeArr[index] = 3
							item = exec[1]
							moneyData.push({
								index,
								money: exec[2]
							})
						} else {
							this.formData.typeArr[index] = 4
						}


					}

					return item

				})
				console.log(moneyData, this.formData, 'moneyData form data')
				moneyData.forEach((element, index) => {
					this.formData.textStr.splice(element.index + index, 0, element.money)
					this.formData.typeArr.splice(element.index + index, 0, 1)
				})
			},

		}
	}
</script>

<style scoped lang="scss">
	.bill-scan {
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

		.bottom-text {
			font-weight: 600;
		}

		.text-content {
			border: 1px solid #e8e8e8;
			padding: 20px;

			::v-deep .uni-forms-item:nth-child(1) {
				margin-bottom: 22px;
			}

			.flex-cen {
				::v-deep .uni-forms-item:nth-child(1) {
					margin-bottom: 0;
				}
			}
		}

		::v-deep .uni-forms-item {
			width: 80vw;
			margin-bottom: 0;
		}
	}
</style>