<template>
<picker :range="[0,1,2,3,4,5,6,7,8,9,10]" mode="selector" :value="0" :range-key="0"></picker>
</template>

<script>
	import {dateTimePicker} from './dateTimePicker.js'
	
	export default {
		data() {
			return {
				dateTimeArray: [],
				dateTime: "",
				upTower: ""
			}
		},
		onLoad(e) {
			let date = new Date()
			let Y = date.getFullYear() + '/'
			let M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '/'
			// let	D = date.getDate() + ' '
			let D = date.getDate() < 10 ? ('0' + date.getDate() + ' ') : (date.getDate() + ' ')


			let h = date.getHours() < 10 ? ('0' + date.getHours() + ':') : (date.getHours() + ':')
			let m = date.getMinutes() < 10 ? ('0' + date.getMinutes() + ':') : (date.getMinutes() + ':')
			let s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds()
			// h = '00' + ':',
			// m = '00' + ':',
			// s = '00';
			let arr = Y + M + D + h + m + s
			console.log(arr, 'arr1111')
			let obj = dateTimePicker.dateTimePicker(this.startYear, this.endYear, arr)
			console.log(obj, 'obj')
			this.dateTimeArray = obj.dateTimeArray
			this.dateTime = obj.dateTime
		},
		methods: {
			//时间格式化
			withData(param) {
				return param < 10 ? '0' + param : '' + param;
			},
			change(e) {
				let value = []
				e.detail.value.forEach((val, index) => {
					value.push(this.withData(val))
				})

				let allYear = this.dateTimeArray[0]
				let y = allYear[Number(value[0])];
				let m = Number(value[1]) + 1;
				let d = Number(value[2]) + 1;
				if (y < 10) y = '0' + y
				if (m < 10) m = '0' + m
				if (d < 10) d = '0' + d

				let dateArray = y + "-" + m + "-" + d + " " + value[3] + ":" + value[4] + ":" + value[5]
				this.upTower = dateArray
				this.formData.visitTime = dateArray
			},
			columnchange(e) {
				console.log(e.detail.value, 'e.detail.value111')
				let dateArr = this.dateTimeArray

				let arr = this.dateTime
				//滑动所在列的数据并对其值进行更新
				arr[e.detail.column] = e.detail.value
				//更新展示月份对应的天数（28 or 29 or 30 or 31）
				dateArr[2] = dateTimePicker.getMonthDay(dateArr[0][arr[0]], dateArr[1][arr[1]])
				//最后把最新的数值赋值到dateTimeArray
				this.dateTimeArray = dateArr
				this.dateTime = arr
			},
		}
	}
</script>

<style>
</style>