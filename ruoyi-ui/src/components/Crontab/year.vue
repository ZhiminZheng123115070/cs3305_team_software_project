<template>
	<el-form size="small">
		<el-form-item>
			<el-radio :label="1" v-model='radioValue'>
				Not Specified, allowed wildcards [, - * /]
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio :label="2" v-model='radioValue'>
				Every Year
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio :label="3" v-model='radioValue'>
				Cycle from
				<el-input-number v-model='cycle01' :min='fullYear' :max="2098" /> -
				<el-input-number v-model='cycle02' :min="cycle01 ? cycle01 + 1 : fullYear + 1" :max="2099" />
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio :label="4" v-model='radioValue'>
				From
				<el-input-number v-model='average01' :min='fullYear' :max="2098"/> year, every
				<el-input-number v-model='average02' :min="1" :max="2099 - average01 || fullYear" /> year
			</el-radio>

		</el-form-item>

		<el-form-item>
			<el-radio :label="5" v-model='radioValue'>
				Specify
				<el-select clearable v-model="checkboxList" placeholder="Multiple selection" multiple>
					<el-option v-for="item in 9" :key="item" :value="item - 1 + fullYear" :label="item -1 + fullYear" />
				</el-select>
			</el-radio>
		</el-form-item>
	</el-form>
</template>

<script>
export default {
	data() {
		return {
			fullYear: 0,
			radioValue: 1,
			cycle01: 0,
			cycle02: 0,
			average01: 0,
			average02: 1,
			checkboxList: [],
			checkNum: this.$options.propsData.check
		}
	},
	name: 'crontab-year',
	props: ['check', 'month', 'cron'],
	methods: {
		// When Radio Button Value Changes
		radioChange() {
			switch (this.radioValue) {
				case 1:
					this.$emit('update', 'year', '')
					break
				case 2:
					this.$emit('update', 'year', '*')
					break
				case 3:
					this.$emit('update', 'year', this.cycleTotal)
					break
				case 4:
					this.$emit('update', 'year', this.averageTotal)
					break
				case 5:
					this.$emit('update', 'year', this.checkboxString)
					break
			}
		},
		// When Cycle Two Values Change
		cycleChange() {
			if (this.radioValue == '3') {
				this.$emit('update', 'year', this.cycleTotal)
			}
		},
		// When Average Two Values Change
		averageChange() {
			if (this.radioValue == '4') {
				this.$emit('update', 'year', this.averageTotal)
			}
		},
		// When Checkbox Value Changes
		checkboxChange() {
			if (this.radioValue == '5') {
				this.$emit('update', 'year', this.checkboxString)
			}
		}
	},
	watch: {
		'radioValue': 'radioChange',
		'cycleTotal': 'cycleChange',
		'averageTotal': 'averageChange',
		'checkboxString': 'checkboxChange'
	},
	computed: {
		// Calculate Two Cycle Values
		cycleTotal: function () {
			const cycle01 = this.checkNum(this.cycle01, this.fullYear, 2098)
			const cycle02 = this.checkNum(this.cycle02, cycle01 ? cycle01 + 1 : this.fullYear + 1, 2099)
			return cycle01 + '-' + cycle02
		},
		// Calculate Average Values
		averageTotal: function () {
			const average01 = this.checkNum(this.average01, this.fullYear, 2098)
			const average02 = this.checkNum(this.average02, 1, 2099 - average01 || this.fullYear)
			return average01 + '/' + average02
		},
		// Calculate Selected Checkbox Values
		checkboxString: function () {
			let str = this.checkboxList.join()
			return str
		}
	},
	mounted: function () {
		// Get Current Year Only
		this.fullYear = Number(new Date().getFullYear())
		this.cycle01 = this.fullYear
		this.average01 = this.fullYear
	}
}
</script>
