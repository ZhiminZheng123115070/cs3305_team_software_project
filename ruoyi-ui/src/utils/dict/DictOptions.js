import { mergeRecursive } from "@/utils/ruoyi"
import dictConverter from './DictConverter'

export const options = {
  metas: {
    '*': {
      /**
       * Dictionary request, method signature is function(dictMeta: DictMeta): Promise
       */
      request: (dictMeta) => {
        console.log(`load dict ${dictMeta.type}`)
        return Promise.resolve([])
      },
      /**
       * Dictionary response data converter, method signature is function(response: Object, dictMeta: DictMeta): DictData
       */
      responseConverter,
      labelField: 'label',
      valueField: 'value',
    },
  },
  /**
   * Default label field
   */
  DEFAULT_LABEL_FIELDS: ['label', 'name', 'title'],
  /**
   * Default value field
   */
  DEFAULT_VALUE_FIELDS: ['value', 'id', 'uid', 'key'],
}

/**
 * Map dictionary
 * @param {Object} response Dictionary data
 * @param {DictMeta} dictMeta Dictionary metadata
 * @returns {DictData}
 */
function responseConverter(response, dictMeta) {
  const dicts = response.content instanceof Array ? response.content : response
  if (dicts === undefined) {
    console.warn(`no dict data of "${dictMeta.type}" found in the response`)
    return []
  }
  return dicts.map(d => dictConverter(d, dictMeta))
}

export function mergeOptions(src) {
  mergeRecursive(options, src)
}

export default options
