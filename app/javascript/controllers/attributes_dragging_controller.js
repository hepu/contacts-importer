import Sortable from 'stimulus-sortable'
import SortableJs from 'sortablejs'

// Connects to data-controller="attributes-dragging"
export default class extends Sortable {
  static values = {
    autoupdate: Boolean
  }

  connect() {
    this.sortable = new SortableJs(this.element, {
      ...this.defaultOptions,
      ...this.options,
      draggable: '.sortable-row'
    })
  }

  onUpdate(event) {
    super.onUpdate(event)

    this.updateValues(event.target.parentElement.parentElement.querySelector('ul'), event.target)

    if (this.autoupdateValue) {
      event.target.closest('form').requestSubmit()
    }
  }

  updateValues(inputsList, valuesList) {
    const inputs = inputsList.querySelectorAll('input[data-value=true')

    inputs.forEach((input, index) => {
      const valueListElement = valuesList.querySelectorAll('li')[index]
      if (valueListElement) {
        const valueElement = valueListElement.querySelector('.value')
        input.value = valueElement.innerText
        input.setAttribute('value', valueElement.innerText)
      }
    })
  }
}
