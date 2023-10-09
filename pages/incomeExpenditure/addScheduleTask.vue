<template>
	<view class="addScheduleTask">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="添加自动记账" @clickLeft="back" />
		<uni-section title="指定日期早上五点自动记录收支" type="line">
			<view class="example">
				<uni-forms ref="valiForm" :rules="rules" :modelValue="valiFormData">
					<uni-forms-item label="金额" required name="money">
						<uni-easyinput v-model="valiFormData.money" placeholder="请输入金额" type="number" />
					</uni-forms-item>

					<uni-forms-item label="类别" required name="typeid">
						<uni-data-picker placeholder="请选择类别" :localdata="categoryData" v-model="valiFormData.typeid"
							:map="{text:'name',value:'id'}" @change="onchange">
						</uni-data-picker>
					</uni-forms-item>
					<uni-forms-item label="记账周期" required name="every" label-width="100">
						<uni-data-select v-model="valiFormData.every"
							:localdata="[{value:'DAY',text:'每天'},{value:'WEEK',text:'每周'},{value:'MONTH',text:'每月'}]" />
					</uni-forms-item>
					<uni-forms-item label="记账类别" required name="type" label-width="100">
						<uni-data-select v-model="valiFormData.type" :localdata="[{value:'1',text:'收入'},{value:'2',text:'支出'}]" />
					</uni-forms-item>
					<uni-forms-item label="结束日期" required name="endTime" label-width="100">
						<uni-data-checkbox v-model="valiFormData.endTime" :localdata="[{value:'',text:'不限制'}]"
							@click="valiFormData.endTime=''"></uni-data-checkbox>
						<uni-datetime-picker type="date" :clear-icon="false" v-model="valiFormData.endTime" />
					</uni-forms-item>
					<uni-forms-item label="备注" name="description">
						<uni-easyinput v-model="valiFormData.description" placeholder="请输入备注" />
					</uni-forms-item>
				</uni-forms>
				<button type="primary" @click="submit('valiForm')">提交</button>
			</view>
		</uni-section>

	</view>
</template>
<script>
	import {
		reactive,
		ref
	} from "vue"
	import {
		request
	} from '@/public/request.ts'
	import {transformNoTime} from '@/public/transform.ts'
	export default {
		setup() {
			const categoryData = ref([])
			const valiFormData = reactive({
				money: '',
				description: '',
				typeid: '',
				every: 'DAY',
				type: '1',
				endTime: ''
			})
			const rules = reactive({
				money: {
					rules: [{
							required: true,
							errorMessage: '金额不能为空'
						},

						{
							validateFunction: function(rule, value, data, callback) {
								if (value <= 0) {
									callback('请输入大于0的金额')
								}
								return true
							}
						}
					]
				},
				typeid: {
					rules: [{
						required: true,
						errorMessage: '类别不能为空'
					}]
				},
				every: {
					rules: [{
						required: true,
						errorMessage: '记账周期不能为空'
					}]
				},
				type: {
					rules: [{
						required: true,
						errorMessage: '记账类别不能为空'
					}]
				}
			})

			function back() {
				uni.navigateTo({
					url: '/pages/my/regularBookkeeping/index'
				})
			}
			
			request({
				url: '/category?userid=1'
			}).then(res => {
				console.log(res, 'res')

				categoryData.value = res.data

			})

			function onchange() {

			}
			return {
				back,
				categoryData,
				onchange,
				valiFormData,
				rules,
				
			}
		},
		methods:{
			submit(ref) {
				this.$refs[ref].validate().then(res => {
					console.log('success', res);
					request({
						url:'/expenditure/timeAdd',
						data:{
							...res,
							userid:'1',
							startTime:transformNoTime(new Date())+' 05:00:00'
						},
						method:'POST'
					}).then(()=>{
						uni.showToast({
							title:'添加成功',
						})
						setTimeout(()=>{
							uni.navigateTo({
								url:'/pages/my/regularBookkeeping/index'
							})
						},2000)
					})
				}).catch(err => {
					console.log('err', err);
				})
			}
		}
	}
</script>
<style lang="scss" scoped>
	.addScheduleTask {
		padding: 0 20px 20px;
	}
</style>