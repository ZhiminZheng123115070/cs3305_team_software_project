/**
 * @classdesc Dictionary data
 * @property {String} label Label
 * @property {*} value Value
 * @property {Object} raw Raw data
 */
export default class DictData {
  constructor(label, value, raw) {
    this.label = label
    this.value = value
    this.raw = raw
  }
}
