import App from './App.vue'
console.log(process.env.NODE_ENV ,'process.env.NODE_ENV ')
if (process.env.NODE_ENV !== "development") {
	console.log = () => {};
	console.info= () => {};
}
// #ifndef VUE3
import Vue from 'vue'
Vue.config.productionTip = false
App.mpType = 'app'
const app = new Vue({
	...App
})
app.$mount()
// #endif

// #ifdef VUE3
import {
	createSSRApp
} from 'vue'
export function createApp() {
	const app = createSSRApp(App)
	return {
		app
	}
}
// #endif
