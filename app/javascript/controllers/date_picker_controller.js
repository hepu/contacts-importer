import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr'

// Connects to data-controller="date-picker"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    flatpickr(
      this.context.scope.element,
      {
        dateFormat: "Y-m-d",
        onChange: this.onDateChange.bind(this)
      }
    );
  }

  onDateChange() {
    this.context.scope.element.closest('form').requestSubmit()
  }
}
