import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static values = {
    modalId: String
  }

  connect() {
    this.modal = new bootstrap.Modal(`${this.modalIdValue}`, { focus: true })
    this.modal._element.querySelectorAll('button[data-bs-dismiss="modal"]').forEach((button) => {
      button.addEventListener('click', this.hide.bind(this))
    })
    const submitBtn = this.modal._element.querySelector('button[type="submit"]')
    if (submitBtn && !submitBtn.attributes['data-modal-submit']) {
      submitBtn.setAttribute('data-modal-submit', true)
      submitBtn.addEventListener('click', this.submitForm.bind(this))

      document.addEventListener('turbo:frame-load', this.onFrameLoad.bind(this))
    }
    this.element.addEventListener('turbo:click', this.onTurboClick.bind(this))
  }

  disconnect() {
    this.modal._element.querySelectorAll('button[data-bs-dismiss="modal"]').forEach((button) => {
      button.removeEventListener('click', this.hide.bind(this))
    })
    const submitBtn = this.modal._element.querySelector('button[type="submit"]')
    if (submitBtn && submitBtn.attributes['data-modal-submit']) {
      submitBtn.setAttribute('data-modal-submit', false)
      submitBtn.removeEventListener('click', this.submitForm.bind(this))

      document.removeEventListener('turbo:frame-load', this.onFrameLoad)
    }
    this.element.removeEventListener('turbo:click', this.onTurboClick)
  }

  onTurboClick() {
    this.modal._element.querySelector('.modal-body #spinner').innerHTML = `
      <div class="text-center">
        <div class="spinner-border" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>
    `
    this.modal._element.querySelectorAll('.modal-body turbo-frame').forEach((frame) => {
      frame.innerHTML = ''
    })
  }

  onFrameLoad() {
    this.modal._element.querySelector('#spinner').innerHTML = ''
  }

  show() {
    this.modal.show()
  }

  hide() {
    this.modal.hide()
  }

  submitForm() {
    this.modal._element.querySelector('form').requestSubmit()
  }
}
