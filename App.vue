<script>
	export default {
		onLaunch: function() {
			console.log('App Launch');

			// setTimeout(() => {
			// uni.setTabBarBadge({
			// 	index: 1,
			// 	text: '31'
			// });
			// uni.showTabBarRedDot({
			// 	index: 3
			// });
			// }, 1000);
		},
		onShow: function() {
			console.log('App Show');
		},
		onHide: function() {
			console.log('App Hide');
		}
	};
</script>

<style lang="scss">
	/*每个页面公共css */
	.flex {
		display: flex;
	}

	.flex-cen {
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.center {
		text-align: center;
	}

	@mixin set-value($side, $value) {
		#{$side}: $value;
	}

	@for $i from 0 to 200 {
		.font#{$i} {
			font-size: $i+px;
			line-height: $i+px;
		}

		.black#{$i} {
			font-size: $i+px;
			line-height: $i+px;
			color: #000;
		}

		.black#{$i}_3 {
			font-size: $i+px;
			line-height: $i+px;
			color: #333;
		}

		.white#{$i} {
			font-size: $i+px;
			line-height: $i+px;
			color: #fff;
		}

		.glay#{$i} {
			font-size: $i+px;
			line-height: $i+px;
			color: #999;
		}

		.glay#{$i}_6 {
			font-size: $i+px;
			line-height: $i+px;
			color: #666666;
		}

		.padding_b_#{$i} {
			padding: 0 $i+px;
			box-sizing: border-box;
		}

		.line-height-#{$i} {
			line-height: $i+px;
		}


		.m-t-#{$i} {
			@include set-value(margin-top, $i+vh);
		}

		.m-b-#{$i} {
			@include set-value(margin-bottom, $i+vh);
		}

		.m-l-#{$i} {
			@include set-value(margin-left, $i+px);
		}

		.m-r-#{$i} {
			@include set-value(margin-right, $i+px);
		}

		.p-t-#{$i} {
			@include set-value(padding-top, $i+vh);
		}

		.p-b-#{$i} {
			@include set-value(padding-bottom, $i+vh);
		}

		.p-l-#{$i} {
			@include set-value(padding-left, $i+px);
		}

		.p-r-#{$i} {
			@include set-value(padding-right, $i+px);
		}
	}

	@for $i from -200 to -1 {
		.line-height-#{$i} {
			line-height: $i+px;
		}

		.m-t-#{$i} {
			@include set-value(margin-top, $i+vh);
		}

		.m-b-#{$i} {
			@include set-value(margin-bottom, $i+vh);
		}

		.m-l-#{$i} {
			@include set-value(margin-left, $i+px);
		}

		.m-r-#{$i} {
			@include set-value(margin-right, $i+px);
		}

		.p-t-#{$i} {
			@include set-value(padding-top, $i+vh);
		}

		.p-b-#{$i} {
			@include set-value(padding-bottom, $i+vh);
		}

		.p-l-#{$i} {
			@include set-value(padding-left, $i+px);
		}

		.p-r-#{$i} {
			@include set-value(padding-right, $i+px);
		}
	}
</style>