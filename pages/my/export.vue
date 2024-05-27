<template>
	<view class="export">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="数据导出" @clickLeft="back" />
		<uni-section title="可将账单导出为表格,单次导出的账单周期需要小于1年,周期超过一年的账单可分为多次导出哦" type="line" class="m-t-1">
			<uni-forms :ref="getValiForm" :rules="rules" :modelValue="valiFormData" class="m-t-2">
				<uni-forms-item label="开始日期" required name="startTime" label-width="100">
					<uni-datetime-picker type="date" :clear-icon="false" v-model="valiFormData.startTime"
						@change="startTimeChange" />

				</uni-forms-item>
				<uni-forms-item label="结束日期" required name="endTime" label-width="100">
					<uni-datetime-picker type="date" :clear-icon="false" v-model="valiFormData.endTime"
						:start="new Date(valiFormData.startTime).setHours(24)"
						:end="new Date(valiFormData.startTime).setFullYear(new Date(valiFormData.startTime).getFullYear()+ 1)" />

				</uni-forms-item>
			</uni-forms>
			<button type="primary" @click="submit()" class="button">导出</button>

		</uni-section>
	</view>
</template>
<script>
	import {
		utils,
		writeFile
	} from 'xlsx'
	import {
		transformNoTime
	} from '@/public/transform'
	import {
		reactive,
		ref
		
	} from "vue"
	import {
		request
	} from '@/public/request'
	export default {
		mounted() {
			uni.preloadPage({url: "/"});
		},
		setup() {
			const validForm = ref(null)
			const valiFormData = reactive({
				startTime: '',
				endTime: ''
			})
			const rules = reactive({
				startTime: {
					rules: [{
						required: true,
						errorMessage: '开始时间不能为空'
					}, ]
				},
				endTime: {
					rules: [{
						required: true,
						errorMessage: '结束时间不能为空'
					}, ]
				},
			})

			function back() {
				uni.switchTab({
					url: '/'
				})
			}

			function startTimeChange(e) {
				const date = /([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})/.exec(e)


				if (valiFormData.endTime && date?.[1]) {
					if (new Date(valiFormData.endTime).getFullYear() - date[1] > 1 || new Date(valiFormData.endTime)
						.getFullYear() - date[1] < 0) {
						valiFormData.endTime = ''
					} else if (new Date(valiFormData.endTime).getFullYear() - date[1] === 1) {
						if (new Date(valiFormData.endTime).getMonth() + 1 - date[2] > 0) {
							valiFormData.endTime = ''
						} else if (new Date(valiFormData.endTime).getMonth() + 1 - date[2] === 0) {
							if (new Date(valiFormData.endTime).getDate() - date[3] > 0) {
								valiFormData.endTime = ''
							}
						}
					} else if (new Date(valiFormData.endTime).getFullYear() - date[1] === 0) {
						if (new Date(valiFormData.endTime).getMonth() + 1 < date[2]) {
							valiFormData.endTime = ''
						} else if (new Date(valiFormData.endTime).getMonth() + 1 === +date[2]) {
							if (new Date(valiFormData.endTime).getDate() < date[3]) {
								valiFormData.endTime = ''
							}
						}
					}



				}
			}

			function submit() {
				validForm.value?.validate().then(res => {
					request({
						url: '/expenditure',
						data: {
							...valiFormData,
							userid: uni.getStorageSync('user')?.id
						}
					}).then(res => {
						console.log(res, 'res')
						if (res.data.length === 0) {
							uni.showToast({
								title: '当前区间没有记录收支',
								icon: 'none'
							})
						} else {
							const data = [
								['分类名称', '金额', '日期', '描述']
							].concat(res.data.map(item => {
								return [item.name, (item.type==='1'?'':'-')+item.money,
									transformNoTime(new Date(item.time)),
									item.description || ''
								]
							}))

							const worksheet = utils.aoa_to_sheet(data);
							const workbook = utils.book_new();
							utils.book_append_sheet(workbook, worksheet, '导出');
							writeFile(workbook, valiFormData.startTime + '到' + valiFormData.endTime +
								'账单数据.xlsx');
							uni.showToast({
								title: '下载成功'
							})
						}
					})
				})
			}

			function getValiForm(e) {
				validForm.value = e
			}
			return {
				back,
				valiFormData,
				rules,
				submit,
				getValiForm,
				startTimeChange
			}
		},
	}
</script>
<style lang="scss" scoped>
	.export {
		padding: 0 20px;

		.button {
			background: $uni-color-warning;
		}
	}
</style>