<template>
	<el-form size="small">
		<el-form-item>
			<el-radio v-model='radioValue' :label="1">
				Day, allowed wildcards [, - * ? / L W]
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="2">
				Not Specified
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="3">
				Cycle from
				<el-input-number v-model='cycle01' :min="1" :max="30" /> -
				<el-input-number v-model='cycle02' :min="cycle01 ? cycle01 + 1 : 2" :max="31" /> day
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="4">
				From
				<el-input-number v-model='average01' :min="1" :max="30" /> day, every
				<el-input-number v-model='average02' :min="1" :max="31 - average01 || 1" /> day
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="5">
				Monthly
				<el-input-number v-model='workday' :min="1" :max="31" /> nearest weekday
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="6">
				Last Day of Month
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="7">
				Specify
				<el-select clearable v-model="checkboxList" placeholder="Multiple selection" multiple style="width:100%">
					<el-option v-for="item in 31" :key="item" :value="item">{{item}}</el-option>
				</el-select>
			</el-radio>
		</el-form-item>
	</el-form>
</template>

<script>
export default {
	data() {
		return {
			radioValue: 1,
			workday: 1,
			cycle01: 1,
			cycle02: 2,
			average01: 1,
			average02: 1,
			checkboxList: [],
			checkNum: this.$options.propsData.check
		}
	},
	name: 'crontab-day',
	props: ['check', 'cron'],
	methods: {
		// When Radio Button Value Changes
		radioChange() {
			('day rachange')
			if (this.radioValue !== 2 && this.cron.week !== '?') {
				this.$emit('update', 'week', '?', 'day')
			}

			switch (this.radioValue) {
				case 1:
					this.$emit('update', 'day', '*')
					break
				case 2:
					this.$emit('update', 'day', '?')
					break
				case 3:
					this.$emit('update', 'day', this.cycleTotal)
					break
				case 4:
					this.$emit('update', 'day', this.averageTotal)
					break
				case 5:
					this.$emit('update', 'day', this.workday + 'W')
					break
				case 6:
					this.$emit('update', 'day', 'L')
					break
				case 7:
					this.$emit('update', 'day', this.checkboxString)
					break
			}
			('day rachange end')
		},
		// When Cycle Two Values Change
		cycleChange() {
			if (this.radioValue == '3') {
				this.$emit('update', 'day', this.cycleTotal)
			}
		},
		// When Average Two Values Change
		averageChange() {
			if (this.radioValue == '4') {
				this.$emit('update', 'day', this.averageTotal)
			}
		},
		// When Nearest Weekday Value Changes
		workdayChange() {
			if (this.radioValue == '5') {
				this.$emit('update', 'day', this.workdayCheck + 'W')
			}
		},
		// When Checkbox Value Changes
		checkboxChange() {
			if (this.radioValue == '7') {
				this.$emit('update', 'day', this.checkboxString)
			}
		}
	},
	watch: {
		'radioValue': 'radioChange',
		'cycleTotal': 'cycleChange',
		'averageTotal': 'averageChange',
		'workdayCheck': 'workdayChange',
		'checkboxString': 'checkboxChange',
	},
	computed: {
		// Calculate Two Cycle Values
		cycleTotal: function () {
			const cycle01 = this.checkNum(this.cycle01, 1, 30)
			const cycle02 = this.checkNum(this.cycle02, cycle01 ? cycle01 + 1 : 2, 31, 31)
			return cycle01 + '-' + cycle02
		},
		// Calculate Average Values
		averageTotal: function () {
			const average01 = this.checkNum(this.average01, 1, 30)
			const average02 = this.checkNum(this.average02, 1, 31 - average01 || 0)
			return average01 + '/' + average02
		},
		// Calculate Weekday Format
		workdayCheck: function () {
			const workday = this.checkNum(this.workday, 1, 31)
			return workday
		},
		// Calculate Selected Checkbox Values
		checkboxString: function () {
			let str = this.checkboxList.join()
			return str == '' ? '*' : str
		}
	}
}
</script>
