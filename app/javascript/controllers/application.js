import { Application } from "@hotwired/stimulus"
import Rails from '@rails/ujs'
import Sortable from 'stimulus-sortable'

const application = Application.start()
application.register('sortable', Sortable)

Rails.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
