<template>
	<el-form size="small">
		<el-form-item>
			<el-radio v-model='radioValue' :label="1">
				Second, allowed wildcards [, - * /]
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="2">
				Cycle from
				<el-input-number v-model='cycle01' :min="0" :max="58" /> -
				<el-input-number v-model='cycle02' :min="cycle01 ? cycle01 + 1 : 1" :max="59" /> second
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="3">
				From
				<el-input-number v-model='average01' :min="0" :max="58" /> second, every
				<el-input-number v-model='average02' :min="1" :max="59 - average01 || 0" /> second
			</el-radio>
		</el-form-item>

		<el-form-item>
			<el-radio v-model='radioValue' :label="4">
				Specify
				<el-select clearable v-model="checkboxList" placeholder="Multiple selection" multiple style="width:100%">
					<el-option v-for="item in 60" :key="item" :value="item-1">{{item-1}}</el-option>
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
			cycle01: 1,
			cycle02: 2,
			average01: 0,
			average02: 1,
			checkboxList: [],
			checkNum: this.$options.propsData.check
		}
	},
	name: 'crontab-second',
	props: ['check', 'radioParent'],
	methods: {
		// When Radio Button Value Changes
		radioChange() {
			switch (this.radioValue) {
				case 1:
					this.$emit('update', 'second', '*', 'second')
					break
				case 2:
					this.$emit('update', 'second', this.cycleTotal)
					break
				case 3:
					this.$emit('update', 'second', this.averageTotal)
					break
				case 4:
					this.$emit('update', 'second', this.checkboxString)
					break
			}
		},
		// When Cycle Two Values Change
		cycleChange() {
			if (this.radioValue == '2') {
				this.$emit('update', 'second', this.cycleTotal)
			}
		},
		// When Average Two Values Change
		averageChange() {
			if (this.radioValue == '3') {
				this.$emit('update', 'second', this.averageTotal)
			}
		},
		// When Checkbox Value Changes
		checkboxChange() {
			if (this.radioValue == '4') {
				this.$emit('update', 'second', this.checkboxString)
			}
		}
	},
	watch: {
		'radioValue': 'radioChange',
		'cycleTotal': 'cycleChange',
		'averageTotal': 'averageChange',
		'checkboxString': 'checkboxChange',
		radioParent() {
			this.radioValue = this.radioParent
		}
	},
	computed: {
		// Calculate Two Cycle Values
		cycleTotal: function () {
			const cycle01 = this.checkNum(this.cycle01, 0, 58)
			const cycle02 = this.checkNum(this.cycle02, cycle01 ? cycle01 + 1 : 1, 59)
			return cycle01 + '-' + cycle02
		},
		// Calculate Average Values
		averageTotal: function () {
			const average01 = this.checkNum(this.average01, 0, 58)
			const average02 = this.checkNum(this.average02, 1, 59 - average01 || 0)
			return average01 + '/' + average02
		},
		// Calculate Selected Checkbox Values
		checkboxString: function () {
			let str = this.checkboxList.join()
			return str == '' ? '*' : str
		}
	}
}
</script>
