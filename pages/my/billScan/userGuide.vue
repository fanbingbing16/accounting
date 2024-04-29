<template>
	<view class="user-guide">
		<uni-nav-bar dark :fixed="true" shadow background-color="#ea9518" status-bar left-icon="left" left-text="返回"
			title="小猫记账账图识别使用手册" @clickLeft="back" />
		<view class="m-t-2 ml">
			<text class="text">目录</text>
			<view class="text2" @click="scollToPage('一、账图识别简介')">一、账图识别简介</view>
			<view class="text2" @click="scollToPage('二、如何使用账图识别')">二、如何使用账图识别</view>
		</view>
		<text class="title" id="一、账图识别简介">一、账图识别简介</text>
		<text class="title2">1.简介</text>
		<text class="title3">
			在使用支付软件进行付款、收款等操作后，将账单截图上传到小猫记账，会进行识图记账，确认识别内容无误后点击提交，可将账单记录到小猫记账上。

		</text>
		<text class="title3">
			目前小猫记账仅支持微信支付宝的账单截图，后续持续更新，支持更多的支付软件。
		</text>
		<text class="title2">2.识别内容</text>
		<text class="title3">
			账图识别智能算法目前支持识别的内容如下
		</text>
		<uni-table class="m-t-1">

			<uni-tbody>
				<uni-tr>
					<uni-td>金额</uni-td>
					<uni-td>支持</uni-td>
				</uni-tr>
				<uni-tr>
					<uni-td>说明或者账户名称</uni-td>
					<uni-td>支持</uni-td>
				</uni-tr>
				<uni-tr>
					<uni-td>日期</uni-td>
					<uni-td>支持</uni-td>
				</uni-tr>
				<uni-tr>
					<uni-td>分类</uni-td>
					<uni-td>支持</uni-td>
				</uni-tr>
			</uni-tbody>
		</uni-table>
		<text class="title" id="二、如何使用账图识别">二、如何使用账图识别</text>
		<text class="title2">1.去支付软件截下账单截图</text>
		<text class="title3">
			首先，您需要在支付软件中打开您的账单页面，然后截取账单的截图。确保截图清晰，包含所有需要识别的内容。
		</text>
		<text class="title2">2.裁剪图片</text>
		<view class="flex-cen m-t-1">
			<img src="../../../static/img/billScan1.jpg"/>
			<uni-icons type="arrow-right"></uni-icons>
			<img src="../../../static/img/billScan2.jpg"/>
		</view>
		<text class="title3">接下来，使用图片编辑工具裁剪掉截图中的无关内容和图片。这样做可以提高识别的准确率，使账图识别更加精准。请参照上面的示例图片进行操作。</text>
		<text class="title2">3.修改识别到的错别字还有类型</text>
		<text class="title3">
			账图识别虽然方便，但偶尔也会出现识别错误的情况。如果识别结果中有错别字，请您手动修正。
		</text>
		<text class="title3">
			同时，识别到的内容可能会按照一定的规则进行分组，如三条或四条为一组，类型是不能重复的，三条为一组的时候可以缺少分类。请按照提示检查和调整分组，确保每条内容都归类正确。如果内容不符合预期的分组规则，请进行相应的修改或添加删除操作。请注意，如果没有明确的类型，这些记录可能会被默认为“其他”分类。
		</text>
		<img src="../../../static/img/billScan3.png" style="width: 100%;" />
		<text class="title3">
			上图是进行账图识别后识别到的内容，提示第三条不符合格式。
		</text>
		<img src="../../../static/img/billScan4.png" style="width: 100%;"/>
		<text class="title3">
			前面说到了三条或者四条为一组，类型是不能重复的，上图第二条和第三条类型一样，所以是会报错的，可以明显看出来第三条是日期，所以将其修改成日期便可以正常提交。
		</text>
		<text class="title2">4.生成账单</text>
	</view>
</template>
<script>
	export default {
		setup() {
			return {}
		},
		methods: {
			scollToPage(id) {
				const element = document.getElementById(id)
				console.log()
				if (element) {
					window.scrollTo({
						top: element.offsetTop-60,
						behavior: 'smooth' // 平滑滚动  

					})
				}

			},
			back() {

				uni.navigateTo({
					url: '/pages/my/billScan/index',
					fail: (e) => {
						consoe.log(e, 'e')
					}
				})
			},
		}
	}
</script>
<style lang="scss" scoped>
	.user-guide {
		padding: 0 20px 20px 20px;
img{
	width: 45%;
}
		.ml {
			background-color: #ffefd8;
			border: 1px solid #ea9518;
			border-radius: 10px;
			padding: 20px;

			.text {
				color: black;
				font-weight: 600;
				display: block;
				font-size: 18px;
			}

			.text2 {
				color: blue;
				display: block;
				cursor: pointer;
				margin-top: 10px;
				text-decoration: none;
			}
		}

		.title {
			color: black;
			font-weight: 600;
			font-size: 20px;
			text-decoration: none;
			margin-top: 20px;
			display: block;
		}

		.title2 {
			color: black;
			font-weight: 600;
			font-size: 18px;
			text-decoration: none;
			margin-top: 20px;
			display: block;
		}

		.title3 {
			display: block;
			margin-top: 10px;
		}
		.uni-icons{
			font-size: 30px;
		}
	}
</style>