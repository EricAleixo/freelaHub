import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["idleState", "pickerState", "selectedState", "selectedLabel", "hiddenInput"]

  connect() {
    this._show("idle")
  }

  // Clicou no botão dashed → abre a lista
  open() {
    this._show("picker")
  }

  // Clicou em um item da lista
  select(event) {
    const li = event.currentTarget
    const id    = li.dataset.jobId
    const title = li.dataset.jobTitle

    this.hiddenInputTarget.value      = id
    this.selectedLabelTarget.textContent = title
    this._show("selected")
  }

  // Fechou sem escolher
  cancel() {
    this.hiddenInputTarget.value = ""
    this._show("idle")
  }

  // Clicou no × do chip
  clear() {
    this.hiddenInputTarget.value = ""
    this._show("idle")
  }

  _show(state) {
    this.idleStateTarget.classList.toggle("hidden",     state !== "idle")
    this.pickerStateTarget.classList.toggle("hidden",   state !== "picker")
    this.selectedStateTarget.classList.toggle("hidden", state !== "selected")
  }
}