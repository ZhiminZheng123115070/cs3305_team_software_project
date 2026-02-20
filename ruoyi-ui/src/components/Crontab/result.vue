<template>
	<div class="popup-result">
		<p class="title">Last 5 Execution Times</p>
		<ul class="popup-result-scroll">
			<template v-if='isShow'>
				<li v-for='item in resultList' :key="item">{{item}}</li>
			</template>
			<li v-else>Calculating results...</li>
		</ul>
	</div>
</template>

<script>
export default {
	data() {
		return {
			dayRule: '',
			dayRuleSup: '',
			dateArr: [],
			resultList: [],
			isShow: false
		}
	},
	name: 'crontab-result',
	methods: {
		// When Expression Value Changes, Start Calculating Results
		expressionChange() {

			// Calculation Start - Hide Results
			this.isShow = false
			// Get Rule Array [0 second, 1 minute, 2 hour, 3 day, 4 month, 5 week, 6 year]
			let ruleArr = this.$options.propsData.ex.split(' ')
			// Used to Record Number of Loop Iterations
			let nums = 0
			// Array to Temporarily Store Time Rule Results
			let resultArr = []
			// Get Current Time Accurate to [Year, Month, Day, Hour, Minute, Second]
			let nTime = new Date()
			let nYear = nTime.getFullYear()
			let nMonth = nTime.getMonth() + 1
			let nDay = nTime.getDate()
			let nHour = nTime.getHours()
			let nMin = nTime.getMinutes()
			let nSecond = nTime.getSeconds()
			// Get Possible Year Array, Month Array, etc. for Next 100 Years Based on Rules
			this.getSecondArr(ruleArr[0])
			this.getMinArr(ruleArr[1])
			this.getHourArr(ruleArr[2])
			this.getDayArr(ruleArr[3])
			this.getMonthArr(ruleArr[4])
			this.getWeekArr(ruleArr[5])
			this.getYearArr(ruleArr[6], nYear)
			// Assign Retrieved Arrays for Easy Use
			let sDate = this.dateArr[0]
			let mDate = this.dateArr[1]
			let hDate = this.dateArr[2]
			let DDate = this.dateArr[3]
			let MDate = this.dateArr[4]
			let YDate = this.dateArr[5]
			// Get Current Time Index in Array
			let sIdx = this.getIndex(sDate, nSecond)
			let mIdx = this.getIndex(mDate, nMin)
			let hIdx = this.getIndex(hDate, nHour)
			let DIdx = this.getIndex(DDate, nDay)
			let MIdx = this.getIndex(MDate, nMonth)
			let YIdx = this.getIndex(YDate, nYear)
			// Reset Month, Day, Hour, Minute, Second Functions (Used Frequently)
			const resetSecond = function () {
				sIdx = 0
				nSecond = sDate[sIdx]
			}
			const resetMin = function () {
				mIdx = 0
				nMin = mDate[mIdx]
				resetSecond()
			}
			const resetHour = function () {
				hIdx = 0
				nHour = hDate[hIdx]
				resetMin()
			}
			const resetDay = function () {
				DIdx = 0
				nDay = DDate[DIdx]
				resetHour()
			}
			const resetMonth = function () {
				MIdx = 0
				nMonth = MDate[MIdx]
				resetDay()
			}
			// If Current Year is Not Current Value in Array
			if (nYear !== YDate[YIdx]) {
				resetMonth()
			}
			// If Current Month is Not Current Value in Array
			if (nMonth !== MDate[MIdx]) {
				resetDay()
			}
			// If Current "Day" is Not Current Value in Array
			if (nDay !== DDate[DIdx]) {
				resetHour()
			}
			// If Current "Hour" is Not Current Value in Array
			if (nHour !== hDate[hIdx]) {
				resetMin()
			}
			// If Current "Minute" is Not Current Value in Array
			if (nMin !== mDate[mIdx]) {
				resetSecond()
			}

			// Loop Year Array
			goYear: for (let Yi = YIdx; Yi < YDate.length; Yi++) {
				let YY = YDate[Yi]
				// If Reached Maximum Value
				if (nMonth > MDate[MDate.length - 1]) {
					resetMonth()
					continue
				}
				// Loop Month Array
				goMonth: for (let Mi = MIdx; Mi < MDate.length; Mi++) {
					// Assign Value for Later Calculation
					let MM = MDate[Mi];
					MM = MM < 10 ? '0' + MM : MM
					// If Reached Maximum Value
					if (nDay > DDate[DDate.length - 1]) {
						resetDay()
						if (Mi == MDate.length - 1) {
							resetMonth()
							continue goYear
						}
						continue
					}
					// Loop Day Array
					goDay: for (let Di = DIdx; Di < DDate.length; Di++) {
						// Assign Value for Later Calculation
						let DD = DDate[Di]
						let thisDD = DD < 10 ? '0' + DD : DD

						// If Reached Maximum Value
						if (nHour > hDate[hDate.length - 1]) {
							resetHour()
							if (Di == DDate.length - 1) {
								resetDay()
								if (Mi == MDate.length - 1) {
									resetMonth()
									continue goYear
								}
								continue goMonth
							}
							continue
						}

						// Check Date Validity, Exit Current Loop if Invalid
						if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true && this.dayRule !== 'workDay' && this.dayRule !== 'lastWeek' && this.dayRule !== 'lastDay') {
							resetDay()
							continue goMonth
						}
						// If Date Rule Has Value
						if (this.dayRule == 'lastDay') {
							// If Not Valid Date, Adjust to Valid Date (Last Day of Month)

							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--
									thisDD = DD < 10 ? '0' + DD : DD
								}
							}
						} else if (this.dayRule == 'workDay') {
							// Validate and Adjust if Invalid Date Like Feb 30, Adjust to Normal Month End
							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--
									thisDD = DD < 10 ? '0' + DD : DD
								}
							}
							// Get Date That Meets Condition is Week X
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + thisDD + ' 00:00:00'), 'week')
							// When Sunday
							if (thisWeek == 1) {
								// Find Next Day First, Check if It's Month End
								DD++
								thisDD = DD < 10 ? '0' + DD : DD
								// Check if Next Day is No Longer Valid Date
								if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD -= 3
								}
							} else if (thisWeek == 7) {
								// When Saturday, Only Need to Check if Not 1st to Proceed
								if (this.dayRuleSup !== 1) {
									DD--
								} else {
									DD += 2
								}
							}
						} else if (this.dayRule == 'weekDay') {
							// If Specified Day of Week
							// Get Current Date Belongs to Which Day of Week
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + DD + ' 00:00:00'), 'week')
							// Validate Current Week is in Week Pool (dayRuleSup)
							if (this.dayRuleSup.indexOf(thisWeek) < 0) {
								// If Reached Maximum Value
								if (Di == DDate.length - 1) {
									resetDay()
									if (Mi == MDate.length - 1) {
										resetMonth()
										continue goYear
									}
									continue goMonth
								}
								continue
							}
						} else if (this.dayRule == 'assWeek') {
							// If Specified Nth Week Day of Week
							// Get 1st of Month Belongs to Which Day of Week
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + DD + ' 00:00:00'), 'week')
							if (this.dayRuleSup[1] >= thisWeek) {
								DD = (this.dayRuleSup[0] - 1) * 7 + this.dayRuleSup[1] - thisWeek + 1
							} else {
								DD = this.dayRuleSup[0] * 7 + this.dayRuleSup[1] - thisWeek + 1
							}
						} else if (this.dayRule == 'lastWeek') {
							// If Specified Last Day of Week of Month
							// Validate and Adjust if Invalid Date Like Feb 30, Adjust to Normal Month End
							if (this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
								while (DD > 0 && this.checkDate(YY + '-' + MM + '-' + thisDD + ' 00:00:00') !== true) {
									DD--
									thisDD = DD < 10 ? '0' + DD : DD
								}
							}
							// Get Last Day of Month is Which Day of Week
							let thisWeek = this.formatDate(new Date(YY + '-' + MM + '-' + thisDD + ' 00:00:00'), 'week')
							// Find Nearest Day of Week in Requirements
							if (this.dayRuleSup < thisWeek) {
								DD -= thisWeek - this.dayRuleSup
							} else if (this.dayRuleSup > thisWeek) {
								DD -= 7 - (this.dayRuleSup - thisWeek)
							}
						}
						// Check if Time Value is Less Than 10, Convert to "05" Format
						DD = DD < 10 ? '0' + DD : DD

						// Loop "Hour" Array
						goHour: for (let hi = hIdx; hi < hDate.length; hi++) {
							let hh = hDate[hi] < 10 ? '0' + hDate[hi] : hDate[hi]

							// If Reached Maximum Value
							if (nMin > mDate[mDate.length - 1]) {
								resetMin()
								if (hi == hDate.length - 1) {
									resetHour()
									if (Di == DDate.length - 1) {
										resetDay()
										if (Mi == MDate.length - 1) {
											resetMonth()
											continue goYear
										}
										continue goMonth
									}
									continue goDay
								}
								continue
							}
							// Loop "Minute" Array
							goMin: for (let mi = mIdx; mi < mDate.length; mi++) {
								let mm = mDate[mi] < 10 ? '0' + mDate[mi] : mDate[mi]

								// If Reached Maximum Value
								if (nSecond > sDate[sDate.length - 1]) {
									resetSecond()
									if (mi == mDate.length - 1) {
										resetMin()
										if (hi == hDate.length - 1) {
											resetHour()
											if (Di == DDate.length - 1) {
												resetDay()
												if (Mi == MDate.length - 1) {
													resetMonth()
													continue goYear
												}
												continue goMonth
											}
											continue goDay
										}
										continue goHour
									}
									continue
								}
								// Loop "Second" Array
								goSecond: for (let si = sIdx; si <= sDate.length - 1; si++) {
									let ss = sDate[si] < 10 ? '0' + sDate[si] : sDate[si]
									// Add Current Time (Time Validity Already Checked in Date Loop)
									if (MM !== '00' && DD !== '00') {
										resultArr.push(YY + '-' + MM + '-' + DD + ' ' + hh + ':' + mm + ':' + ss)
										nums++
									}
									// Exit Loop if Count is Full
									if (nums == 5) break goYear
									// If Reached Maximum Value
									if (si == sDate.length - 1) {
										resetSecond()
										if (mi == mDate.length - 1) {
											resetMin()
											if (hi == hDate.length - 1) {
												resetHour()
												if (Di == DDate.length - 1) {
													resetDay()
													if (Mi == MDate.length - 1) {
														resetMonth()
														continue goYear
													}
													continue goMonth
												}
												continue goDay
											}
											continue goHour
										}
										continue goMin
									}
								} //goSecond
							} //goMin
						}//goHour
					}//goDay
				}//goMonth
			}
			// Check Result Count Within 100 Years
			if (resultArr.length == 0) {
				this.resultList = ['No results matching conditions!']
			} else {
				this.resultList = resultArr
				if (resultArr.length !== 5) {
					this.resultList.push('Only ' + resultArr.length + ' results in the last 100 years!')
				}
			}
			// Calculation Complete - Show Results
			this.isShow = true


		},
		// Calculate Index of a Number in Array
		getIndex(arr, value) {
			if (value <= arr[0] || value > arr[arr.length - 1]) {
				return 0
			} else {
				for (let i = 0; i < arr.length - 1; i++) {
					if (value > arr[i] && value <= arr[i + 1]) {
						return i + 1
					}
				}
			}
		},
		// Get "Year" Array
		getYearArr(rule, year) {
			this.dateArr[5] = this.getOrderArr(year, year + 100)
			if (rule !== undefined) {
				if (rule.indexOf('-') >= 0) {
					this.dateArr[5] = this.getCycleArr(rule, year + 100, false)
				} else if (rule.indexOf('/') >= 0) {
					this.dateArr[5] = this.getAverageArr(rule, year + 100)
				} else if (rule !== '*') {
					this.dateArr[5] = this.getAssignArr(rule)
				}
			}
		},
		// Get "Month" Array
		getMonthArr(rule) {
			this.dateArr[4] = this.getOrderArr(1, 12)
			if (rule.indexOf('-') >= 0) {
				this.dateArr[4] = this.getCycleArr(rule, 12, false)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[4] = this.getAverageArr(rule, 12)
			} else if (rule !== '*') {
				this.dateArr[4] = this.getAssignArr(rule)
			}
		},
		// Get "Day" Array - Mainly for Date Rules
		getWeekArr(rule) {
			// Only when both values of date rule are "" does it mean date has options
			if (this.dayRule == '' && this.dayRuleSup == '') {
				if (rule.indexOf('-') >= 0) {
					this.dayRule = 'weekDay'
					this.dayRuleSup = this.getCycleArr(rule, 7, false)
				} else if (rule.indexOf('#') >= 0) {
					this.dayRule = 'assWeek'
					let matchRule = rule.match(/[0-9]{1}/g)
					this.dayRuleSup = [Number(matchRule[1]), Number(matchRule[0])]
					this.dateArr[3] = [1]
					if (this.dayRuleSup[1] == 7) {
						this.dayRuleSup[1] = 0
					}
				} else if (rule.indexOf('L') >= 0) {
					this.dayRule = 'lastWeek'
					this.dayRuleSup = Number(rule.match(/[0-9]{1,2}/g)[0])
					this.dateArr[3] = [31]
					if (this.dayRuleSup == 7) {
						this.dayRuleSup = 0
					}
				} else if (rule !== '*' && rule !== '?') {
					this.dayRule = 'weekDay'
					this.dayRuleSup = this.getAssignArr(rule)
				}
			}
		},
		// Get "Day" Array - Small Amount for Date Rules
		getDayArr(rule) {
			this.dateArr[3] = this.getOrderArr(1, 31)
			this.dayRule = ''
			this.dayRuleSup = ''
			if (rule.indexOf('-') >= 0) {
				this.dateArr[3] = this.getCycleArr(rule, 31, false)
				this.dayRuleSup = 'null'
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[3] = this.getAverageArr(rule, 31)
				this.dayRuleSup = 'null'
			} else if (rule.indexOf('W') >= 0) {
				this.dayRule = 'workDay'
				this.dayRuleSup = Number(rule.match(/[0-9]{1,2}/g)[0])
				this.dateArr[3] = [this.dayRuleSup]
			} else if (rule.indexOf('L') >= 0) {
				this.dayRule = 'lastDay'
				this.dayRuleSup = 'null'
				this.dateArr[3] = [31]
			} else if (rule !== '*' && rule !== '?') {
				this.dateArr[3] = this.getAssignArr(rule)
				this.dayRuleSup = 'null'
			} else if (rule == '*') {
				this.dayRuleSup = 'null'
			}
		},
		// Get "Hour" Array
		getHourArr(rule) {
			this.dateArr[2] = this.getOrderArr(0, 23)
			if (rule.indexOf('-') >= 0) {
				this.dateArr[2] = this.getCycleArr(rule, 24, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[2] = this.getAverageArr(rule, 23)
			} else if (rule !== '*') {
				this.dateArr[2] = this.getAssignArr(rule)
			}
		},
		// Get "Minute" Array
		getMinArr(rule) {
			this.dateArr[1] = this.getOrderArr(0, 59)
			if (rule.indexOf('-') >= 0) {
				this.dateArr[1] = this.getCycleArr(rule, 60, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[1] = this.getAverageArr(rule, 59)
			} else if (rule !== '*') {
				this.dateArr[1] = this.getAssignArr(rule)
			}
		},
		// Get "Second" Array
		getSecondArr(rule) {
			this.dateArr[0] = this.getOrderArr(0, 59)
			if (rule.indexOf('-') >= 0) {
				this.dateArr[0] = this.getCycleArr(rule, 60, true)
			} else if (rule.indexOf('/') >= 0) {
				this.dateArr[0] = this.getAverageArr(rule, 59)
			} else if (rule !== '*') {
				this.dateArr[0] = this.getAssignArr(rule)
			}
		},
		// Return an Ordered Array Based on min-max Passed In
		getOrderArr(min, max) {
			let arr = []
			for (let i = min; i <= max; i++) {
				arr.push(i)
			}
			return arr
		},
		// Return an Array Based on Scattered Values Specified in Rule
		getAssignArr(rule) {
			let arr = []
			let assiginArr = rule.split(',')
			for (let i = 0; i < assiginArr.length; i++) {
				arr[i] = Number(assiginArr[i])
			}
			arr.sort(this.compare)
			return arr
		},
		// Calculate and Return an Array Based on Arithmetic Rules
		getAverageArr(rule, limit) {
			let arr = []
			let agArr = rule.split('/')
			let min = Number(agArr[0])
			let step = Number(agArr[1])
			while (min <= limit) {
				arr.push(min)
				min += step
			}
			return arr
		},
		// Return a Periodic Array Based on Rules
		getCycleArr(rule, limit, status) {
			// status-- indicates whether to start from 0 (otherwise start from 1)
			let arr = []
			let cycleArr = rule.split('-')
			let min = Number(cycleArr[0])
			let max = Number(cycleArr[1])
			if (min > max) {
				max += limit
			}
			for (let i = min; i <= max; i++) {
				let add = 0
				if (status == false && i % limit == 0) {
					add = limit
				}
				arr.push(Math.round(i % limit + add))
			}
			arr.sort(this.compare)
			return arr
		},
		// Compare Number Size (Used for Array.sort)
		compare(value1, value2) {
			if (value2 - value1 > 0) {
				return -1
			} else {
				return 1
			}
		},
		// Format Date Format e.g.: 2017-9-19 18:04:33
		formatDate(value, type) {
			// Calculate Date Related Values
			let time = typeof value == 'number' ? new Date(value) : value
			let Y = time.getFullYear()
			let M = time.getMonth() + 1
			let D = time.getDate()
			let h = time.getHours()
			let m = time.getMinutes()
			let s = time.getSeconds()
			let week = time.getDay()
			// If type is Passed
			if (type == undefined) {
				return Y + '-' + (M < 10 ? '0' + M : M) + '-' + (D < 10 ? '0' + D : D) + ' ' + (h < 10 ? '0' + h : h) + ':' + (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s)
			} else if (type == 'week') {
				// In quartz, 1 is Sunday
				return week + 1
			}
		},
		// Check if Date Exists
		checkDate(value) {
			let time = new Date(value)
			let format = this.formatDate(time)
			return value === format
		}
	},
	watch: {
		'ex': 'expressionChange'
	},
	props: ['ex'],
	mounted: function () {
		// Initialize, Get Result Once
		this.expressionChange()
	}
}

</script>
